//
//  OverallSection.swift
//  TestCaliNode
//
//  Renamed from OverallProgressSection.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

struct OverallSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            sectionHeader
            
            // Progress Details
            progressDetails
            
            // Motivational Message
            motivationalMessage
        }
        .padding(24)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            Image(systemName: "chart.pie.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            Text("Overall Progress")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Completion badge
            Text("\(Int(skillManager.completionPercentage * 100))%")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(progressColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(progressColor.opacity(0.1))
                )
        }
    }
    
    // MARK: - Progress Details
    private var progressDetails: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(skillManager.unlockedSkills.count) of \(totalSkillsCount) skills unlocked")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Enhanced progress bar with segments
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [progressColor.opacity(0.8), progressColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * skillManager.completionPercentage, height: 12)
                        .animation(.easeInOut(duration: 0.8), value: skillManager.completionPercentage)
                    
                    // Milestone markers
                    HStack(spacing: 0) {
                        ForEach(0..<4) { index in
                            Spacer()
                            if index < 3 {
                                Circle()
                                    .fill(Color.white)
                                    .stroke(skillManager.completionPercentage > Double(index + 1) * 0.25 ? progressColor : Color.gray, lineWidth: 2)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            .frame(height: 12)
            
            // Milestone labels
            HStack {
                Text("0%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("25%")
                    .font(.caption2)
                    .foregroundColor(skillManager.completionPercentage >= 0.25 ? progressColor : .secondary)
                
                Spacer()
                
                Text("50%")
                    .font(.caption2)
                    .foregroundColor(skillManager.completionPercentage >= 0.5 ? progressColor : .secondary)
                
                Spacer()
                
                Text("75%")
                    .font(.caption2)
                    .foregroundColor(skillManager.completionPercentage >= 0.75 ? progressColor : .secondary)
                
                Spacer()
                
                Text("100%")
                    .font(.caption2)
                    .foregroundColor(skillManager.completionPercentage >= 1.0 ? progressColor : .secondary)
            }
        }
    }
    
    // MARK: - Motivational Message
    private var motivationalMessage: some View {
        HStack {
            Image(systemName: motivationalIcon)
                .font(.title3)
                .foregroundColor(progressColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(motivationalTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(motivationalDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(progressColor.opacity(0.1))
        )
    }
    
    // MARK: - Computed Properties
    private var totalSkillsCount: Int {
        let allSkills = allEnhancedSkillTrees.flatMap { tree in
            tree.foundationalSkills + tree.branches.flatMap { $0.skills } + tree.masterSkills
        }
        return allSkills.count
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
    
    private var motivationalIcon: String {
        switch skillManager.completionPercentage {
        case 0..<0.1: return "seedling"
        case 0.1..<0.25: return "sprout.fill"
        case 0.25..<0.5: return "leaf.fill"
        case 0.5..<0.75: return "tree.fill"
        case 0.75..<1.0: return "flame.fill"
        default: return "crown.fill"
        }
    }
    
    private var motivationalTitle: String {
        switch skillManager.completionPercentage {
        case 0..<0.1: return "Just Getting Started!"
        case 0.1..<0.25: return "Building Foundation"
        case 0.25..<0.5: return "Making Solid Progress"
        case 0.5..<0.75: return "Halfway There!"
        case 0.75..<0.9: return "Almost Complete!"
        case 0.9..<1.0: return "So Close to Mastery!"
        default: return "Calisthenics Master!"
        }
    }
    
    private var motivationalDescription: String {
        switch skillManager.completionPercentage {
        case 0..<0.1: return "Every journey begins with a single step"
        case 0.1..<0.25: return "Focus on foundational skills first"
        case 0.25..<0.5: return "Great momentum, keep it going"
        case 0.5..<0.75: return "You're getting strong!"
        case 0.75..<0.9: return "Elite level approaching"
        case 0.9..<1.0: return "Ultimate mastery within reach"
        default: return "You've achieved complete mastery!"
        }
    }
}
