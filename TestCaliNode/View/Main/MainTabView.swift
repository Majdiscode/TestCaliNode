//
//  MainTabView.swift
//  TestCaliNode
//
//  Enhanced with Quest System Integration - FIXED VERSION
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var skillManager = GlobalSkillManager()
    @StateObject private var questManager = QuestManager.shared
    @StateObject private var workoutManager = WorkoutManager() // NEW: Workout tracker
    
    var body: some View {
        TabView {
            // Skills Tab
            SkillTreeViewWithManager(skillManager: skillManager)
                .tabItem {
                    Label("Skills", systemImage: "tree")
                }
                .badge(questManager.activeQuests.count > 0 ? questManager.activeQuests.count : 0)
            
            // NEW: Workout Tracker Tab
            WorkoutTrackerView(workoutManager: workoutManager)
                .tabItem {
                    Label("Workouts", systemImage: "figure.strengthtraining.traditional")
                }
            
            // Quests Tab
            QuestView(questManager: questManager)
                .tabItem {
                    Label("Quests", systemImage: "flag.fill")
                }
                .badge(questManager.availableQuests.count > 0 ? questManager.availableQuests.count : 0)
            
            // Enhanced Progress Tab (using your existing ProgressDashboard)
            ProgressDashboard(skillManager: skillManager, questManager: questManager)
                .tabItem {
                    Label("Progress", systemImage: "chart.pie")
                }

            // Logout Tab (unchanged)
            LogoutView()
                .tabItem {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                }
        }
        .onAppear {
            // Connect quest manager to skill manager
            questManager.setSkillManager(skillManager)
            questManager.refreshAvailableQuests()
        }
        // Note: Reward notifications overlay removed for now to avoid conflicts
    }
}

// Wrapper to pass skillManager to SkillTreeView (unchanged)
struct SkillTreeViewWithManager: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        SkillTreeView(skillManager: skillManager)
    }
}
