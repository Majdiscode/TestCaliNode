//
//  HeaderSection.swift
//  TestCaliNode
//
//  Renamed from ProgressHeaderSection.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

struct HeaderSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(skillManager.globalLevel)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text("Calisthenics Journey")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(skillManager.unlockedSkills.count)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("Skills Unlocked")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress indicator with level info
            if skillManager.globalLevel > 0 {
                VStack(spacing: 8) {
                    HStack {
                        Text(levelTitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(Int(skillManager.completionPercentage * 100))% Complete")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: skillManager.completionPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                        .scaleEffect(y: 2)
                        .animation(.easeInOut(duration: 0.5), value: skillManager.completionPercentage)
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
    }
    
    // MARK: - Computed Properties
    private var levelTitle: String {
        switch skillManager.globalLevel {
        case 0: return "Beginner"
        case 1...5: return "Novice"
        case 6...15: return "Intermediate"
        case 16...30: return "Advanced"
        case 31...50: return "Expert"
        default: return "Master"
        }
    }
    
    private var progressColor: Color {
        switch skillManager.completionPercentage {
        case 0..<0.25: return .red
        case 0.25..<0.5: return .orange
        case 0.5..<0.75: return .yellow
        case 0.75..<1.0: return .blue
        default: return .green
        }
    }
}
