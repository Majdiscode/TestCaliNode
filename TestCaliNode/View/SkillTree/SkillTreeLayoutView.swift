//
//  FixedSkillTreeLayoutView.swift
//  TestCaliNode
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EnhancedSkillTreeLayoutView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var skillManager: GlobalSkillManager
    
    let skillTree: EnhancedSkillTreeModel
    
    @State private var prereqMessage: String? = nil
    @State private var showCard = false
    @State private var pendingSkill: SkillNode? = nil
    @State private var selectedBranch: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Minimalist branch selection - less cluttered
            if !skillTree.branches.isEmpty {
                minimalistBranchSelection
                    .background(Color(UIColor.systemBackground))
                    .zIndex(1)
            }
            
            // Clean scrollable content
            ScrollView {
                let contentHeight: CGFloat = 1200 // Fixed reasonable height
                
                ZStack {
                    // Subtle connection lines
                    minimalistConnectorLines()
                    
                    // Skills with better spacing
                    skillNodesView()
                    
                    // Clean error message if needed
                    if let message = prereqMessage {
                        minimalistErrorMessage(message)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: contentHeight)
                .clipped()
            }
        }
        .overlay(
            // Clean confirmation overlay
            Group {
                if showCard, let skill = pendingSkill {
                    Color.black.opacity(0.4) // Less intense overlay
                        .ignoresSafeArea()
                        .overlay(
                            ConfirmationCardView(
                                prompt: skill.confirmPrompt,
                                confirmAction: {
                                    skillManager.unlock(skill.id)
                                    showCard = false
                                },
                                cancelAction: {
                                    showCard = false
                                }
                            )
                        )
                        .zIndex(10)
                }
            }
        )
        .onAppear {
            // ✅ FIXED: Don't override skillManager.allSkills, just ensure this tree's skills are included
            ensureTreeSkillsAreLoaded()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SkillsReset"))) { _ in
            skillManager.resetAllSkills()
        }
    }
    
    // MARK: - Fixed: Don't Override All Skills
    private func ensureTreeSkillsAreLoaded() {
        // Just verify that this tree's skills are loaded in the global manager
        let treeSkillIDs = skillTree.allSkills.map(\.id)
        let missingSkills = treeSkillIDs.filter { skillManager.allSkills[$0] == nil }
        
        if !missingSkills.isEmpty {
            print("⚠️ Missing skills in GlobalSkillManager: \(missingSkills)")
            // Force a refresh if skills are missing
            skillManager.forceRefresh()
        }
    }
    
    // MARK: - Minimalist Branch Selection
    private var minimalistBranchSelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) { // More spacing between buttons
                // Clean "All" button
                Button("All") {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        selectedBranch = nil
                    }
                }
                .buttonStyle(MinimalistBranchButtonStyle(
                    isSelected: selectedBranch == nil,
                    color: .blue
                ))
                
                // Clean individual branch buttons
                ForEach(skillTree.branches, id: \.id) { branch in
                    Button(branch.name) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            selectedBranch = selectedBranch == branch.id ? nil : branch.id
                        }
                    }
                    .buttonStyle(MinimalistBranchButtonStyle(
                        isSelected: selectedBranch == branch.id,
                        color: Color(hex: branch.color)
                    ))
                }
            }
            .padding(.horizontal, 24) // More padding
            .padding(.vertical, 20)   // More vertical space
        }
        .background(Color(UIColor.systemBackground).opacity(0.98))
    }
    
    // MARK: - Clean Skills Display
    private func skillNodesView() -> some View {
        Group {
            // Foundational skills
            ForEach(skillTree.foundationalSkills) { skill in
                renderMinimalistSkillNode(skill: skill, branchColor: nil)
            }
            
            // Branch skills with conditional visibility
            ForEach(skillTree.branches, id: \.id) { branch in
                if selectedBranch == nil || selectedBranch == branch.id {
                    ForEach(branch.skills) { skill in
                        renderMinimalistSkillNode(skill: skill, branchColor: Color(hex: branch.color))
                    }
                }
            }
            
            // Master skills
            ForEach(skillTree.masterSkills) { skill in
                renderMinimalistSkillNode(skill: skill, branchColor: Color(hex: "#FFD700"))
            }
        }
    }
    
    // MARK: - Minimalist Skill Node
    private func renderMinimalistSkillNode(skill: SkillNode, branchColor: Color?) -> some View {
        guard let pos = skillTree.allPositions[skill.id] else {
            return AnyView(EmptyView())
        }
        
        let isUnlocked = skillManager.isUnlocked(skill.id)
        let canUnlock = skillManager.canUnlock(skill.id)
        
        return AnyView(
            MinimalistSkillCircle(
                label: skill.label,
                unlocked: isUnlocked,
                branchColor: branchColor
            )
            .position(pos)
            .id(skill.id)
            .opacity(selectedBranch == nil || isSkillInSelectedBranch(skill) ? 1.0 : 0.2)
            .scaleEffect(selectedBranch == nil || isSkillInSelectedBranch(skill) ? 1.0 : 0.7)
            .animation(.easeInOut(duration: 0.4), value: selectedBranch)
            .onTapGesture {
                handleSkillTap(skill: skill)
            }
        )
    }
    
    // MARK: - Subtle Connection Lines
    private func minimalistConnectorLines() -> some View {
        ForEach(skillTree.allSkills, id: \.id) { skill in
            ForEach(skill.requires, id: \.self) { reqID in
                if let from = skillTree.allPositions[reqID], let to = skillTree.allPositions[skill.id] {
                    let isVisible = selectedBranch == nil ||
                                   isSkillInSelectedBranch(skill) ||
                                   skillTree.foundationalSkills.contains(where: { $0.id == reqID })
                    
                    MinimalistLineConnector(from: from, to: to)
                        .opacity(isVisible ? 0.6 : 0.1) // Much more subtle
                        .animation(.easeInOut(duration: 0.4), value: selectedBranch)
                }
            }
        }
    }
    
    // MARK: - Clean Error Message
    private func minimalistErrorMessage(_ message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.9))
                        .shadow(color: .black.opacity(0.2), radius: 8)
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 80)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        prereqMessage = nil
                    }
                }
        }
    }
    
    // MARK: - Helper Functions
    private func isSkillInSelectedBranch(_ skill: SkillNode) -> Bool {
        guard let selectedBranch = selectedBranch else { return true }
        
        if skillTree.foundationalSkills.contains(where: { $0.id == skill.id }) ||
           skillTree.masterSkills.contains(where: { $0.id == skill.id }) {
            return true
        }
        
        return skillTree.branches.first(where: { $0.id == selectedBranch })?.skills.contains(where: { $0.id == skill.id }) == true
    }
    
    private func handleSkillTap(skill: SkillNode) {
        guard !skillManager.isUnlocked(skill.id) else { return }
        
        if skillManager.canUnlock(skill.id) {
            pendingSkill = skill
            showCard = true
        } else {
            let requirementNames = skillManager.getRequirementNames(for: skill.id)
            prereqMessage = "To unlock \(skill.fullLabel.components(separatedBy: " (").first!), you must first unlock: \(requirementNames.joined(separator: " and "))"
        }
    }
}

// MARK: - Minimalist Button Style
struct MinimalistBranchButtonStyle: ButtonStyle {
    let isSelected: Bool
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? color : Color.gray.opacity(0.1))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Minimalist Components
struct MinimalistSkillCircle: View {
    let label: String
    let unlocked: Bool
    let branchColor: Color?
    
    var body: some View {
        Text(label)
            .font(.system(size: 28)) // Slightly larger for better visibility
            .frame(width: 70, height: 70) // Bigger circles with more space
            .background(
                Circle()
                    .fill(unlocked ? (branchColor ?? Color(hex: "#0096FF")) : Color.black.opacity(0.8))
            )
            .foregroundColor(.white)
            .overlay(
                Circle()
                    .stroke(branchColor ?? .white, lineWidth: unlocked ? 3 : 1)
                    .opacity(0.8)
            )
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            .scaleEffect(unlocked ? 1.0 : 0.9)
            .animation(.spring(response: 0.4), value: unlocked)
    }
}

struct MinimalistLineConnector: View {
    let from: CGPoint
    let to: CGPoint
    
    var body: some View {
        Canvas { context, size in
            var path = SwiftUI.Path()
            path.move(to: from)
            path.addLine(to: to)
            context.stroke(path, with: .color(.white.opacity(0.4)), lineWidth: 2) // Thinner, more subtle lines
        }
    }
}
