//
//  AboutView.swift
//  TestCaliNode
//
//  Uses existing FeatureRow component
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                Text("TestCaliNode")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Version 1.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text("Your journey to calisthenics mastery starts here. Track your progress, complete quests, and become stronger every day.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            VStack(spacing: 12) {
                Text("Features:")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    FeatureRow(icon: "tree", title: "Skill Trees", description: "Progressive calisthenics training")
                    FeatureRow(icon: "flag.fill", title: "Quest System", description: "Gamified progress tracking")
                    FeatureRow(icon: "figure.strengthtraining.traditional", title: "Workout Tracker", description: "Log your training sessions")
                    FeatureRow(icon: "chart.pie", title: "Progress Analytics", description: "Detailed performance insights")
                }
            }
            
            Spacer()
        }
        .padding(.top, 32)
        .padding(.horizontal, 20)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
