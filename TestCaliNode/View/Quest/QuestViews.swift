//
//  QuestViews.swift
//  TestCaliNode
//
//  Blank Quest System - Complete Reset
//

import SwiftUI

// MARK: - Main Quest View (Blank)

struct QuestView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(spacing: 24) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.gray)
                    
                    Text("Quest System")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Coming Soon")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .navigationTitle("Quests")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
