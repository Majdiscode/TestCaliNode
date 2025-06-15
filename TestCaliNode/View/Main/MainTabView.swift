//
//  MainTabView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var skillManager = GlobalSkillManager()
    
    var body: some View {
        TabView {
            // Pass the same skillManager to both views so they stay in sync
            SkillTreeViewWithManager(skillManager: skillManager)
                .tabItem {
                    Label("Skill Tree", systemImage: "tree")
                }
            
            ProgressDashboard(skillManager: skillManager)
                .tabItem {
                    Label("Progress", systemImage: "chart.pie")
                }

            LogoutView()
                .tabItem {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                }
        }
    }
}

// Wrapper to pass skillManager to SkillTreeView
struct SkillTreeViewWithManager: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        SkillTreeView(skillManager: skillManager)
    }
}
