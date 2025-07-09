//
//  SkillTreeLayoutContainer.swift
//  TestCaliNode
//
//  FIXED - Removed conflicting component declarations
//

import SwiftUI

struct SkillTreeLayoutContainer: View {
    @ObservedObject var skillManager: GlobalSkillManager
    let skillTree: EnhancedSkillTreeModel
    
    // State management
    @State private var prereqMessage: String? = nil
    @State private var showCard = false
    @State private var pendingSkill: SkillNode? = nil
    @State private var selectedBranch: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Branch selection bar
            if !skillTree.branches.isEmpty {
                branchSelectionView
            }
            
            // Main skill tree canvas
            skillTreeCanvas
        }
        .overlay(overlayContent)
        .onAppear {
            ensureTreeSkillsAreLoaded()
        }
    }
    
    // MARK: - Branch Selection View
    private var branchSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                allBranchButton
                
                ForEach(skillTree.branches, id: \.id) { branch in
                    individualBranchButton(branch: branch)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(Color(UIColor.systemBackground).opacity(0.98))
    }
    
    private var allBranchButton: some View {
        Button("All") {
            withAnimation(.easeInOut(duration: 0.4)) {
                selectedBranch = nil
            }
        }
        .font(.system(size: 15, weight: selectedBranch == nil ? .semibold : .medium))
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedBranch == nil ? Color.blue : Color.gray.opacity(0.1))
        )
        .foregroundColor(selectedBranch == nil ? .white : .primary)
    }
    
    private func individualBranchButton(branch: SkillBranch) -> some View {
        Button(branch.name) {
            withAnimation(.easeInOut(duration: 0.4)) {
                selectedBranch = selectedBranch == branch.id ? nil : branch.id
            }
        }
        .font(.system(size: 15, weight: selectedBranch == branch.id ? .semibold : .medium))
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedBranch == branch.id ? Color(hex: branch.color) : Color.gray.opacity(0.1))
        )
        .foregroundColor(selectedBranch == branch.id ? .white : .primary)
    }
    
    // MARK: - Skill Tree Canvas
    private var skillTreeCanvas: some View {
        ScrollView {
            ZStack {
                connectionLines
                skillNodes
            }
            .frame(width: UIScreen.main.bounds.width, height: 1200)
            .clipped()
        }
    }
    
    private var connectionLines: some View {
        ForEach(skillTree.allSkills, id: \.id) { skill in
            ForEach(skill.requires, id: \.self) { reqID in
                connectionLine(from: reqID, to: skill.id, skill: skill)
            }
        }
    }
    
    private func connectionLine(from reqID: String, to skillID: String, skill: SkillNode) -> some View {
        Group {
            if let fromPos = skillTree.allPositions[reqID],
               let toPos = skillTree.allPositions[skillID] {
                
                let isVisible = selectedBranch == nil ||
                               isSkillInSelectedBranch(skill) ||
                               skillTree.foundationalSkills.contains(where: { $0.id == reqID })
                
                // Simple line connector (inline to avoid conflicts)
                Canvas { context, size in
                    var path = SwiftUI.Path()
                    path.move(to: fromPos)
                    path.addLine(to: toPos)
                    context.stroke(path, with: .color(.white.opacity(0.4)), lineWidth: 2)
                }
                .opacity(isVisible ? 0.6 : 0.1)
                .animation(.easeInOut(duration: 0.4), value: selectedBranch)
            }
        }
    }
    
    private var skillNodes: some View {
        Group {
            foundationalNodes
            branchNodes
            masterNodes
        }
    }
    
    private var foundationalNodes: some View {
        ForEach(skillTree.foundationalSkills) { skill in
            skillNodeView(skill: skill, branchColor: nil)
        }
    }
    
    private var branchNodes: some View {
        ForEach(skillTree.branches, id: \.id) { branch in
            Group {
                if selectedBranch == nil || selectedBranch == branch.id {
                    ForEach(branch.skills) { skill in
                        skillNodeView(skill: skill, branchColor: Color(hex: branch.color))
                    }
                }
            }
        }
    }
    
    private var masterNodes: some View {
        ForEach(skillTree.masterSkills) { skill in
            skillNodeView(skill: skill, branchColor: Color(hex: "#FFD700"))
        }
    }
    
    // MARK: - Enhanced skill rendering with PNG support
    private func skillNodeView(skill: SkillNode, branchColor: Color?) -> some View {
        Group {
            if let position = skillTree.allPositions[skill.id] {
                let isVisible = selectedBranch == nil || isSkillInSelectedBranch(skill)
                let isUnlocked = skillManager.isUnlocked(skill.id)
                
                // Skill content rendering
                ZStack {
                    // Background circle
                    Circle()
                        .fill(isUnlocked ? (branchColor ?? Color(hex: "#0096FF")) : Color.black.opacity(0.8))
                        .frame(width: 70, height: 70)
                    
                    // Smart content - PNG fills entire circle or emoji
                    Group {
                        switch skill.id {
                        case "deadHang":
                            if UIImage(named: "Deadhang") != nil {
                                Image("Deadhang")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            } else {
                                Text("🪢").font(.system(size: 28)).foregroundColor(.white)
                            }
                        case "pullUp":
                            if UIImage(named: "PullUp") != nil {
                                Image("PullUp")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            } else {
                                Text("🆙").font(.system(size: 28)).foregroundColor(.white)
                            }
                        case "kneePushup":
                            if UIImage(named: "KneePush") != nil {
                                Image("KneePush")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            } else {
                                Text("🦵").font(.system(size: 28)).foregroundColor(.white)
                            }
                        case "inclinePushup":
                            if UIImage(named: "InclinePush") != nil {
                                Image("InclinePush")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            } else {
                                Text("📐").font(.system(size: 28)).foregroundColor(.white)
                            }
                        case "pushup":
                            if UIImage(named: "Pushup") != nil {
                                Image("Pushup")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            } else {
                                Text("🙌").font(.system(size: 28)).foregroundColor(.white)
                            }
                        default:
                            // All other skills use emoji
                            Text(skill.label)
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .opacity(isUnlocked ? 1.0 : 0.7)
                }
                .overlay(
                    Circle()
                        .stroke(branchColor ?? .white, lineWidth: isUnlocked ? 3 : 1)
                        .opacity(0.8)
                )
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                .scaleEffect(isUnlocked ? 1.0 : 0.9)
                .animation(.spring(response: 0.4), value: isUnlocked)
                .position(position)
                .id(skill.id)
                .opacity(isVisible ? 1.0 : 0.2)
                .scaleEffect(isVisible ? 1.0 : 0.7)
                .animation(.easeInOut(duration: 0.4), value: isVisible)
                .onTapGesture {
                    handleSkillTap(skill: skill)
                }
            }
        }
    }
    
    // MARK: - Overlay Content
    private var overlayContent: some View {
        Group {
            if showCard, let skill = pendingSkill {
                confirmationOverlay(skill: skill)
            } else if let message = prereqMessage {
                errorOverlay(message: message)
            }
        }
    }
    
    private func confirmationOverlay(skill: SkillNode) -> some View {
        Color.black.opacity(0.4)
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
    
    private func errorOverlay(message: String) -> some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .overlay(
                // Inline error message to avoid conflicts
                ErrorMessageView(message: message) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        prereqMessage = nil
                    }
                }
            )
            .zIndex(9)
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
            let skillName = skill.fullLabel.components(separatedBy: " (").first!
            prereqMessage = "To unlock \(skillName), you must first unlock: \(requirementNames.joined(separator: " and "))"
        }
    }
    
    private func ensureTreeSkillsAreLoaded() {
        let treeSkillIDs = skillTree.allSkills.map(\.id)
        let missingSkills = treeSkillIDs.filter { skillManager.allSkills[$0] == nil }
        
        if !missingSkills.isEmpty {
            print("⚠️ Missing skills in GlobalSkillManager: \(missingSkills)")
            skillManager.forceRefresh()
        }
    }
}

// MARK: - Inline Error Message Component (to avoid conflicts)
struct ErrorMessageView: View {
    let message: String
    let onDismiss: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var animateCard = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 32))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .lineLimit(nil)
            
            Button(action: {
                withAnimation {
                    animateCard = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onDismiss()
                }
            }) {
                Text("Got it")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .padding(24)
        .frame(maxWidth: 320, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                .shadow(radius: 16)
        )
        .padding(.horizontal, 40)
        .scaleEffect(animateCard ? 1 : 0.9)
        .opacity(animateCard ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: animateCard)
        .onAppear {
            animateCard = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                if animateCard {
                    onDismiss()
                }
            }
        }
        .onTapGesture {
            onDismiss()
        }
    }
}
