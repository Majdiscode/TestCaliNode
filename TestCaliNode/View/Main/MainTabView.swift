//
//  MainTabView.swift
//  TestCaliNode
//
//  CLEAN VERSION - Only contains MainTabView, no other view definitions
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var skillManager = GlobalSkillManager()
    @StateObject private var questManager = QuestManager.shared
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some View {
        TabView {
            // Skills Tab
            SkillTreeContainer(skillManager: skillManager)
                .tabItem {
                    Label("Skills", systemImage: "tree")
                }
                .badge(questManager.activeQuests.count > 0 ? questManager.activeQuests.count : 0)
            
            // Workout Tracker Tab
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
            
            // Progress Tab
            ProgressDashboard(skillManager: skillManager, questManager: questManager)
                .tabItem {
                    Label("Progress", systemImage: "chart.pie")
                }

            // Settings Tab
            EnhancedSettingsView(skillManager: skillManager, questManager: questManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .onAppear {
            questManager.setSkillManager(skillManager)
            questManager.refreshAvailableQuests()
        }
    }
}

// IMPORTANT: Remove ALL other struct definitions from this file
// Each view should be in its own separate file
