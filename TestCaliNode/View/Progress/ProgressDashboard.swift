//
//  ProgressDashboard.swift
//  TestCaliNode
//
//  Final Cleaned Progress Dashboard - Quest References Removed
//

import SwiftUI

// MARK: - Main Progress Dashboard

struct ProgressDashboard: View {
    @ObservedObject var skillManager: GlobalSkillManager
    // REMOVED: questManager parameter
    @State private var showResetConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                HeaderSection(skillManager: skillManager)
                
                // Overall Progress Section
                OverallSection(skillManager: skillManager)
                
                // REMOVED: Quest Progress Section
                
                // Skill Trees Section
                SkillTreeSection(skillManager: skillManager)
                
                // Branch Mastery Section
                BranchMasterySection(skillManager: skillManager)
                
                // Achievements Section
                AchievementsSection(skillManager: skillManager)
                
                // Statistics Section
                StatisticsSection(skillManager: skillManager)
                
                // Fixed Danger Zone Section (Quest management removed)
                DangerZoneSection(
                    skillManager: skillManager,
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
