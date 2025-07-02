//
//  MainTabView.swift
//  TestCaliNode
//
//  SIMPLE FIX - Just update this existing file
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var skillManager = GlobalSkillManager()
    @StateObject private var questManager = QuestManager.shared
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some View {
        TabView {
            // Skills Tab - CHANGE THIS LINE
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

            // Logout Tab
            LogoutView()
                .tabItem {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                }
        }
        .onAppear {
            questManager.setSkillManager(skillManager)
            questManager.refreshAvailableQuests()
        }
    }
}

// DELETE the SkillTreeViewWithManager struct at the bottom of this file
// It's causing the conflict
