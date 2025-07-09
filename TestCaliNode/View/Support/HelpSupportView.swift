//
//  HelpSupportView.swift
//  TestCaliNode
//
//  Uses existing HelpRow component
//

import SwiftUI

struct HelpSupportView: View {
    var body: some View {
        List {
            Section("Getting Started") {
                HelpRow(
                    icon: "questionmark.circle",
                    title: "How to unlock skills",
                    description: "Tap on available skills to unlock them"
                )
                
                HelpRow(
                    icon: "target",
                    title: "Understanding quests",
                    description: "Complete objectives to earn XP and rewards"
                )
                
                HelpRow(
                    icon: "dumbbell",
                    title: "Tracking workouts",
                    description: "Log your exercises and monitor progress"
                )
            }
            
            Section("Tips") {
                HelpRow(
                    icon: "lightbulb",
                    title: "Focus on foundational skills first",
                    description: "Build a strong base before advanced moves"
                )
                
                HelpRow(
                    icon: "calendar",
                    title: "Train consistently",
                    description: "Regular practice is key to improvement"
                )
                
                HelpRow(
                    icon: "heart",
                    title: "Listen to your body",
                    description: "Rest when needed and avoid overtraining"
                )
            }
            
            Section("Support") {
                Button("Send Feedback") {
                    print("📧 Opening feedback...")
                }
                
                Button("Report a Bug") {
                    print("🐛 Opening bug report...")
                }
            }
        }
        .navigationTitle("Help & Support")
    }
}

// DELETE EVERYTHING FROM HERE DOWN - it's already in HelpRow.swift
