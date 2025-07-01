//
//  StatisticsSection.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ProgressComponents/StatisticsSection.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ProgressComponents/
//

import SwiftUI

struct StatisticsSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section header with total stats
            sectionHeader
            
            // Statistics grid
            statisticsGrid
            
            // Additional insights (optional)
            if showInsights {
                statisticalInsights
            }
        }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            Image(systemName: "chart.bar.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            Text("Statistics")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Overall completion percentage
            Text("\(Int(skillManager.completionPercentage * 100))%")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(completionColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(completionColor.opacity(0.1))
                )
        }
    }
    
    // MARK: - Statistics Grid
    private var statisticsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            
            // Core statistics
            StatCard(
                title: "Skills Unlocked",
                value: "\(skillManager.unlockedSkills.count)",
                color: .blue,
                icon: "star.fill",
                subtitle: "of \(totalSkillsCount) total"
            )
            
            StatCard(
                title: "Trees Completed",
                value: "\(completedTreesCount)",
                color: .green,
                icon: "tree.fill",
                subtitle: completedTreesCount == 4 ? "All complete!" : "of 4 trees"
            )
            
            StatCard(
                title: "Branches Mastered",
                value: "\(masteredBranchesCount)",
                color: .cyan,
                icon: "leaf.fill",
                subtitle: "of \(totalBranchesCount) total"
            )
            
            StatCard(
                title: "Master Skills",
                value: "\(masterSkillsUnlocked)",
                color: .green,
                icon: "crown.fill",
                subtitle: masterSkillsUnlocked > 0 ? "Elite level!" : "Ultimate goal"
            )
            
            // Advanced statistics
            StatCard(
                title: "Current Level",
                value: "\(skillManager.globalLevel)",
                color: .cyan,
                icon: "arrow.up.circle.fill",
                subtitle: levelDescription
            )
            
            StatCard(
                title: "Completion Rate",
                value: "\(Int(skillManager.completionPercentage * 100))%",
                color: completionColor,
                icon: "percent",
                subtitle: completionDescription
            )
        }
    }
    
    // MARK: - Statistical Insights
    private var statisticalInsights: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                ForEach(insights, id: \.title) { insight in
                    InsightRow(insight: insight)
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Computed Properties
    private var totalSkillsCount: Int {
        let allSkills = allEnhancedSkillTrees.flatMap { tree in
            tree.foundationalSkills + tree.branches.flatMap { $0.skills } + tree.masterSkills
        }
        return allSkills.count
    }
    
    private var completedTreesCount: Int {
        let allTrees = ["pull", "push", "core", "legs"]
        return allTrees.filter { treeID in
            let progress = skillManager.getTreeProgress(treeID)
            return progress.unlocked == progress.total && progress.total > 0
        }.count
    }
    
    private var masteredBranchesCount: Int {
        var count = 0
        for tree in allEnhancedSkillTrees {
            for branch in tree.branches {
                let branchSkillIDs = branch.skills.map(\.id)
                let unlockedInBranch = branchSkillIDs.filter { skillManager.isUnlocked($0) }.count
                if unlockedInBranch == branchSkillIDs.count && !branchSkillIDs.isEmpty {
                    count += 1
                }
            }
        }
        return count
    }
    
    private var totalBranchesCount: Int {
        return allEnhancedSkillTrees.flatMap { $0.branches }.count
    }
    
    private var masterSkillsUnlocked: Int {
        let masterSkills = allEnhancedSkillTrees.flatMap { $0.masterSkills }
        return masterSkills.filter { skillManager.isUnlocked($0.id) }.count
    }
    
    private var completionColor: Color {
        switch skillManager.completionPercentage {
        case 0..<0.25: return .red
        case 0.25..<0.5: return .orange
        case 0.5..<0.75: return .blue
        case 0.75..<1.0: return .mint
        default: return .green
        }
    }
    
    private var levelDescription: String {
        switch skillManager.globalLevel {
        case 0: return "Beginner"
        case 1...5: return "Novice"
        case 6...15: return "Intermediate"
        case 16...30: return "Advanced"
        case 31...50: return "Expert"
        default: return "Master"
        }
    }
    
    private var completionDescription: String {
        switch skillManager.completionPercentage {
        case 0..<0.1: return "Just started"
        case 0.1..<0.25: return "Getting going"
        case 0.25..<0.5: return "Good progress"
        case 0.5..<0.75: return "Halfway there"
        case 0.75..<0.9: return "Almost done"
        case 0.9..<1.0: return "So close!"
        default: return "Complete!"
        }
    }
    
    private var showInsights: Bool {
        return skillManager.globalLevel > 0 // Only show insights after some progress
    }
    
    private var insights: [StatisticalInsight] {
        var insights: [StatisticalInsight] = []
        
        // Skill distribution insight
        let foundationalCount = allEnhancedSkillTrees.flatMap { $0.foundationalSkills }.filter { skillManager.isUnlocked($0.id) }.count
        let totalFoundational = allEnhancedSkillTrees.flatMap { $0.foundationalSkills }.count
        
        if foundationalCount == totalFoundational && totalFoundational > 0 {
            insights.append(StatisticalInsight(
                icon: "checkmark.circle.fill",
                title: "Foundation Complete",
                description: "All foundational skills mastered",
                color: .green
            ))
        } else if foundationalCount > 0 {
            insights.append(StatisticalInsight(
                icon: "building.2.fill",
                title: "Building Foundation",
                description: "\(foundationalCount)/\(totalFoundational) foundational skills unlocked",
                color: .blue
            ))
        }
        
        // Tree balance insight
        let treeProgresses = ["pull", "push", "core", "legs"].map { treeID in
            let progress = skillManager.getTreeProgress(treeID)
            return progress.total > 0 ? Double(progress.unlocked) / Double(progress.total) : 0.0
        }
        let averageProgress = treeProgresses.reduce(0, +) / Double(treeProgresses.count)
        let maxProgress = treeProgresses.max() ?? 0
        let minProgress = treeProgresses.min() ?? 0
        
        if maxProgress - minProgress > 0.3 { // Significant imbalance
            insights.append(StatisticalInsight(
                icon: "scale.3d",
                title: "Focus Balance",
                description: "Consider training weaker skill trees",
                color: .orange
            ))
        } else if averageProgress > 0.7 {
            insights.append(StatisticalInsight(
                icon: "flame.fill",
                title: "Well Balanced",
                description: "Great progress across all skill trees",
                color: .green
            ))
        }
        
        // Master skill insight
        if masterSkillsUnlocked > 0 {
            insights.append(StatisticalInsight(
                icon: "crown.fill",
                title: "Elite Achievement",
                description: "Master skill unlocked - exceptional!",
                color: .purple
            ))
        }
        
        return insights
    }
}

// MARK: - Statistical Insight Model
struct StatisticalInsight {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// MARK: - Insight Row
struct InsightRow: View {
    let insight: StatisticalInsight
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: insight.icon)
                .font(.title3)
                .foregroundColor(insight.color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(insight.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(insight.color.opacity(0.1))
        )
    }
}

// MARK: - Compact Statistics Section
struct CompactStatisticsSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                QuickStat(
                    title: "Skills",
                    value: "\(skillManager.unlockedSkills.count)",
                    color: .blue
                )
                
                QuickStat(
                    title: "Trees",
                    value: "\(completedTreesCount)",
                    color: .green
                )
                
                QuickStat(
                    title: "Level",
                    value: "\(skillManager.globalLevel)",
                    color: .cyan
                )
                
                QuickStat(
                    title: "Complete",
                    value: "\(Int(skillManager.completionPercentage * 100))%",
                    color: .purple
                )
            }
        }
    }
    
    private var completedTreesCount: Int {
        let allTrees = ["pull", "push", "core", "legs"]
        return allTrees.filter { treeID in
            let progress = skillManager.getTreeProgress(treeID)
            return progress.unlocked == progress.total && progress.total > 0
        }.count
    }
}

// MARK: - Quick Stat Component
struct QuickStat: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
