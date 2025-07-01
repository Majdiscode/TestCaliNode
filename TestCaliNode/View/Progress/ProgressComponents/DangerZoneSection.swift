//
//  DangerZoneSection.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  DangerZoneSection.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ProgressComponents/DangerZoneSection.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ProgressComponents/
//

import SwiftUI

struct DangerZoneSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @ObservedObject var questManager: QuestManager
    @Binding var showResetConfirmation: Bool
    
    @State private var showSkillResetConfirmation = false
    @State private var showQuestResetConfirmation = false
    @State private var showProgressResetConfirmation = false
    @State private var expandedSection: DangerAction? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            sectionHeader
            
            // Danger Actions
            VStack(spacing: 12) {
                ForEach(DangerAction.allCases, id: \.rawValue) { action in
                    DangerActionCard(
                        action: action,
                        isExpanded: expandedSection == action,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                expandedSection = expandedSection == action ? nil : action
                            }
                        },
                        onConfirm: {
                            handleDangerAction(action)
                        }
                    )
                }
            }
        }
        .padding(24)
        .background(Color.red.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(20)
        .alert("Reset All Skills?", isPresented: $showSkillResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset All", role: .destructive) {
                skillManager.resetAllSkills()
            }
        } message: {
            Text("This will permanently delete all your skill progress. This action cannot be undone.")
        }
        .alert("Reset Quest Data?", isPresented: $showQuestResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset All", role: .destructive) {
                questManager.resetAllQuests()
            }
        } message: {
            Text("This will permanently delete all quest progress, XP, and coins.")
        }
        .alert("Reset Progress Only?", isPresented: $showProgressResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset Progress", role: .destructive) {
                questManager.resetQuestProgress()
            }
        } message: {
            Text("This will reset quest progress but keep completed quests for reference.")
        }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.red)
            
            Text("Danger Zone")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            Spacer()
            
            // Warning indicator
            Text("⚠️")
                .font(.title3)
        }
    }
    
    // MARK: - Handle Danger Actions
    private func handleDangerAction(_ action: DangerAction) {
        switch action {
        case .resetSkills:
            showSkillResetConfirmation = true
        case .resetQuests:
            showQuestResetConfirmation = true
        case .resetProgress:
            showProgressResetConfirmation = true
        }
        
        // Collapse the expanded section
        withAnimation(.easeInOut(duration: 0.3)) {
            expandedSection = nil
        }
    }
}

// MARK: - Danger Action Enum
enum DangerAction: String, CaseIterable {
    case resetSkills = "resetSkills"
    case resetQuests = "resetQuests"
    case resetProgress = "resetProgress"
    
    var title: String {
        switch self {
        case .resetSkills: return "Reset All Skills"
        case .resetQuests: return "Reset Quest Data"
        case .resetProgress: return "Reset Progress Only"
        }
    }
    
    var description: String {
        switch self {
        case .resetSkills: return "This will permanently delete all your unlocked skills and progress. This action cannot be undone."
        case .resetQuests: return "Reset all quest progress, XP, and coins for testing purposes."
        case .resetProgress: return "Reset quest progress but keep completed quests for reference."
        }
    }
    
    var buttonText: String {
        switch self {
        case .resetSkills: return "Reset All Skills"
        case .resetQuests: return "Reset Quests"
        case .resetProgress: return "Reset Progress Only"
        }
    }
    
    var color: Color {
        switch self {
        case .resetSkills: return .red
        case .resetQuests: return .orange
        case .resetProgress: return .yellow
        }
    }
    
    var icon: String {
        switch self {
        case .resetSkills: return "trash.fill"
        case .resetQuests: return "flag.slash.fill"
        case .resetProgress: return "arrow.counterclockwise"
        }
    }
}

// MARK: - Danger Action Card
struct DangerActionCard: View {
    let action: DangerAction
    let isExpanded: Bool
    let onTap: () -> Void
    let onConfirm: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header (always visible)
            Button(action: onTap) {
                HStack {
                    Image(systemName: action.icon)
                        .font(.title3)
                        .foregroundColor(action.color)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(action.title)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        if !isExpanded {
                            Text("Tap to expand")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                        .background(action.color.opacity(0.3))
                    
                    // Description
                    Text(action.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                    
                    // Action button
                    Button(action.buttonText) {
                        onConfirm()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(action.color)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity.combined(with: .move(edge: .top))
                ))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(action.color.opacity(isExpanded ? 0.5 : 0.2), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}

// MARK: - Simple Danger Zone (Alternative Compact Version)
struct SimpleDangerZoneSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @ObservedObject var questManager: QuestManager
    @State private var showResetConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reset Options")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            HStack(spacing: 12) {
                Button("Reset Skills") {
                    showResetConfirmation = true
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Button("Reset Quests") {
                    questManager.resetAllQuests()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
        .alert("Reset All Skills?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset All", role: .destructive) {
                skillManager.resetAllSkills()
            }
        } message: {
            Text("This will permanently delete all your progress. This action cannot be undone.")
        }
    }
}
