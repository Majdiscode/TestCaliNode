//
//  MainTabView.swift
//  TestCaliNode
//
//  CLEAN VERSION - Quest badges and integrations removed
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var skillManager = GlobalSkillManager()
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some View {
        TabView {
            // Skills Tab
            SkillTreeContainer(skillManager: skillManager)
                .tabItem {
                    Label("Skills", systemImage: "tree")
                }
                // REMOVED: quest badge
            
            // Workout Tracker Tab
            WorkoutTrackerView(workoutManager: workoutManager)
                .tabItem {
                    Label("Workouts", systemImage: "figure.strengthtraining.traditional")
                }
            
            // Quests Tab (Blank)
            QuestView()
                .tabItem {
                    Label("Quests", systemImage: "flag.fill")
                }
                // REMOVED: quest badge
            
            // Progress Tab
            ProgressDashboard(skillManager: skillManager)
                .tabItem {
                    Label("Progress", systemImage: "chart.pie")
                }

            // Settings Tab
            EnhancedSettingsView(skillManager: skillManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        // REMOVED: Quest manager initialization and setup
    }
}
