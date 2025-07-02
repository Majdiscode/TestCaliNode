//
//  ProgressDashboard.swift
//  TestCaliNode
//
//  Clean Progress Dashboard - Updated imports for renamed components
//

import SwiftUI

// MARK: - Main Progress Dashboard

struct ProgressDashboard: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @ObservedObject var questManager: QuestManager
    @State private var showResetConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section - Updated import
                HeaderSection(skillManager: skillManager)
                
                // Overall Progress Section - Updated import
                OverallSection(skillManager: skillManager)
                
                // Quest Progress Section - Updated import
                QuestSection(questManager: questManager)
                
                // Skill Trees Section
                SkillTreeSection(skillManager: skillManager)
                
                // Branch Mastery Section
                BranchMasterySection(skillManager: skillManager)
                
                // Achievements Section
                AchievementsSection(skillManager: skillManager)
                
                // Statistics Section
                StatisticsSection(skillManager: skillManager)
                
                // Danger Zone Section
                DangerZoneSection(
                    skillManager: skillManager,
                    questManager: questManager,
                    showResetConfirmation: $showResetConfirmation
                )
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
}
