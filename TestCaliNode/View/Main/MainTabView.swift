//
//  MainTabView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SkillTreeView()
                .tabItem {
                    Label("Skill Tree", systemImage: "tree")
                }

            ProgressTab()
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
