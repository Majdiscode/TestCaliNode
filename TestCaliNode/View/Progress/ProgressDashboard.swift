//
//  ProgressDashboard.swift
//  TestCaliNode
//
//  Enhanced with Quest System Integration - Updated by Majd Iskandarani on 6/14/25.
//

import SwiftUI
import Charts

struct ProgressDashboard: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @ObservedObject var questManager: QuestManager
    @State private var showResetConfirmation = false
    
    // Updated for enhanced trees
    private let allTrees = ["pull", "push", "core", "legs"]
    private let treeNames = [
        "pull": "Pull Tree",
        "push": "Push Tree",
        "core": "Core Tree",
        "legs": "Legs Tree"
    ]
    private let treeEmojis = [
        "pull": "🆙",
        "push": "🙌",
        "core": "🧱",
        "legs": "🦿"
    ]
    private let treeColors = [
        "pull": "#3498DB",
        "push": "#E74C3C",
        "core": "#F39C12",
        "legs": "#27AE60"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) { // More spacing for minimalist look
                headerSection
                
                overallProgressSection
                
                // NEW: Quest progress section
                questProgressSection
                
                enhancedTreeProgressSection
                
                branchProgressSection // New section for branch progress
                
                achievementsSection
                
                enhancedStatsSection
                
                resetSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
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
        }
    }
    
    // MARK: - Overall Progress
    private var overallProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Progress")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                HStack {
                    Text("\(Int(skillManager.completionPercentage * 100))% Complete")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(completionMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                ProgressView(value: skillManager.completionPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                    .scaleEffect(y: 3) // Thicker progress bar
            }
        }
        .padding(24)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(20)
    }
    
    // MARK: - NEW: Quest Progress Section
    private var questProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Quest Progress")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                QuestProgressStatCard(
                    title: "Active Quests",
                    value: "\(questManager.activeQuests.count)",
                    color: .blue,
                    icon: "flag.fill"
                )
                
                QuestProgressStatCard(
                    title: "Completed Today",
                    value: "\(todayCompletedQuests)",
                    color: .green,
                    icon: "checkmark.circle.fill"
                )
                
                QuestProgressStatCard(
                    title: "Total XP",
                    value: "\(questManager.playerExperience)",
                    color: .purple,
                    icon: "star.fill"
                )
                
                QuestProgressStatCard(
                    title: "Coins Earned",
                    value: "\(questManager.playerCoins)",
                    color: .yellow,
                    icon: "dollarsign.circle.fill"
                )
            }
            
            // Mini quest widget for quick access
            MiniQuestWidget(questManager: questManager)
        }
    }
    
    private var todayCompletedQuests: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return questManager.completedQuests.filter { quest in
            guard let completedAt = quest.completedAt else { return false }
            return Calendar.current.isDate(completedAt, inSameDayAs: today)
        }.count
    }
    
    // MARK: - Enhanced Tree Progress with Branch Breakdown
    private var enhancedTreeProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Skill Trees")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(allTrees, id: \.self) { treeID in
                    EnhancedTreeProgressCard(
                        treeID: treeID,
                        treeName: treeNames[treeID] ?? treeID,
                        emoji: treeEmojis[treeID] ?? "🌟",
                        color: Color(hex: treeColors[treeID] ?? "#3498DB"),
                        skillManager: skillManager
                    )
                }
            }
        }
    }
    
    // MARK: - Branch Progress Section (New!)
    private var branchProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Branch Mastery")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                ForEach(allEnhancedSkillTrees, id: \.id) { tree in
                    if !tree.branches.isEmpty {
                        BranchMasteryCard(tree: tree, skillManager: skillManager)
                    }
                }
            }
        }
    }
    
    // MARK: - Achievements
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(enhancedAchievements, id: \.id) { achievement in
                        EnhancedAchievementBadge(achievement: achievement)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Enhanced Stats
    private var enhancedStatsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                StatCard(title: "Skills Unlocked", value: "\(skillManager.unlockedSkills.count)", color: .blue)
                StatCard(title: "Trees Completed", value: "\(completedTreesCount)", color: .green)
                StatCard(title: "Branches Mastered", value: "\(masteredBranchesCount)", color: .purple)
                StatCard(title: "Master Skills", value: "\(masterSkillsUnlocked)", color: .orange)
            }
        }
    }
    
    // MARK: - Reset Section
    private var resetSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Danger Zone")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 12) {
                // Skills Reset
                Text("Reset All Skills")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("This will permanently delete all your unlocked skills and progress. This action cannot be undone.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button("Reset All Skills") {
                    showResetConfirmation = true
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Divider()
                    .padding(.vertical, 8)
                
                // Quest Reset
                Text("Reset Quest Data")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("Reset all quest progress, XP, and coins for testing purposes.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    Button("Reset Quests") {
                        questManager.resetAllQuests()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    Button("Reset Progress Only") {
                        questManager.resetQuestProgress()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(24)
        .background(Color.red.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(20)
        .alert("Reset All Skills?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset All", role: .destructive) {
                skillManager.resetAllSkills()
            }
        } message: {
            Text("This will permanently delete all your progress. This action cannot be undone.")
        }
    }
    
    // MARK: - Enhanced Computed Properties
    private var progressColor: Color {
        switch skillManager.completionPercentage {
        case 0..<0.25: return .red
        case 0.25..<0.5: return .orange
        case 0.5..<0.75: return .yellow
        case 0.75..<1.0: return .blue
        default: return .green
        }
    }
    
    private var completionMessage: String {
        switch skillManager.completionPercentage {
        case 0..<0.1: return "Just getting started!"
        case 0.1..<0.25: return "Building foundation"
        case 0.25..<0.5: return "Making solid progress"
        case 0.5..<0.75: return "Getting strong!"
        case 0.75..<0.9: return "Almost there!"
        case 0.9..<1.0: return "So close to mastery!"
        default: return "Calisthenics Master!"
        }
    }
    
    private var completedTreesCount: Int {
        allTrees.filter { treeID in
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
    
    private var masterSkillsUnlocked: Int {
        let masterSkills = allEnhancedSkillTrees.flatMap { $0.masterSkills }
        return masterSkills.filter { skillManager.isUnlocked($0.id) }.count
    }
    
    private var enhancedAchievements: [Achievement] {
        [
            Achievement(id: "first_skill", title: "First Steps", description: "Unlock your first skill", emoji: "🎯", isUnlocked: skillManager.globalLevel >= 1),
            Achievement(id: "foundational_complete", title: "Strong Foundation", description: "Complete all foundational skills", emoji: "🏗️", isUnlocked: foundationalSkillsComplete),
            Achievement(id: "first_branch", title: "Branch Explorer", description: "Master your first branch", emoji: "🌿", isUnlocked: masteredBranchesCount >= 1),
            Achievement(id: "tree_complete", title: "Tree Master", description: "Complete any skill tree", emoji: "🌳", isUnlocked: completedTreesCount >= 1),
            Achievement(id: "master_skill", title: "Master Achiever", description: "Unlock a master skill", emoji: "👑", isUnlocked: masterSkillsUnlocked >= 1),
            Achievement(id: "half_way", title: "Halfway Hero", description: "Reach 50% completion", emoji: "⭐", isUnlocked: skillManager.completionPercentage >= 0.5),
            Achievement(id: "all_trees", title: "Grand Master", description: "Complete all skill trees", emoji: "🏆", isUnlocked: completedTreesCount >= 4),
            Achievement(id: "master_achieved", title: "Calisthenics God", description: "Achieve 100% completion", emoji: "🔥", isUnlocked: skillManager.completionPercentage >= 1.0)
        ]
    }
    
    private var foundationalSkillsComplete: Bool {
        let foundationalSkills = allEnhancedSkillTrees.flatMap { $0.foundationalSkills }
        return foundationalSkills.allSatisfy { skillManager.isUnlocked($0.id) }
    }
}

// MARK: - Enhanced Supporting Views

struct EnhancedTreeProgressCard: View {
    let treeID: String
    let treeName: String
    let emoji: String
    let color: Color
    @ObservedObject var skillManager: GlobalSkillManager
    
    private var progress: (unlocked: Int, total: Int) {
        skillManager.getTreeProgress(treeID)
    }
    
    private var progressPercentage: Double {
        guard progress.total > 0 else { return 0 }
        return Double(progress.unlocked) / Double(progress.total)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(emoji)
                .font(.system(size: 40))
            
            VStack(spacing: 8) {
                Text(treeName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text("\(progress.unlocked)/\(progress.total)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ProgressView(value: progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: progressPercentage == 1.0 ? .green : color))
                    .scaleEffect(y: 2)
            }
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(progressPercentage == 1.0 ? .green : color, lineWidth: progressPercentage > 0 ? 2 : 0)
        )
    }
}

struct BranchMasteryCard: View {
    let tree: EnhancedSkillTreeModel
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                let treeMetadata = treeMetadata.first { $0.id == tree.id }
                Text(treeMetadata?.emoji ?? "🌟")
                    .font(.title2)
                
                Text("\(tree.name) Branches")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(tree.branches, id: \.id) { branch in
                    BranchProgressIndicator(branch: branch, skillManager: skillManager)
                }
            }
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct BranchProgressIndicator: View {
    let branch: SkillBranch
    @ObservedObject var skillManager: GlobalSkillManager
    
    private var branchProgress: (unlocked: Int, total: Int) {
        let branchSkillIDs = branch.skills.map(\.id)
        let unlockedCount = branchSkillIDs.filter { skillManager.isUnlocked($0) }.count
        return (unlocked: unlockedCount, total: branchSkillIDs.count)
    }
    
    private var isMastered: Bool {
        branchProgress.unlocked == branchProgress.total && branchProgress.total > 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(branch.name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            ZStack {
                Circle()
                    .stroke(Color(hex: branch.color).opacity(0.3), lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: CGFloat(branchProgress.unlocked) / CGFloat(max(branchProgress.total, 1)))
                    .stroke(Color(hex: branch.color), lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: branchProgress.unlocked)
                
                if isMastered {
                    Text("✓")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: branch.color))
                } else {
                    Text("\(branchProgress.unlocked)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: branch.color))
                }
            }
        }
    }
}

struct EnhancedAchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            Text(achievement.emoji)
                .font(.system(size: 48))
                .opacity(achievement.isUnlocked ? 1.0 : 0.3)
            
            VStack(spacing: 6) {
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(achievement.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .frame(width: 120, height: 140)
        .padding(12)
        .background(achievement.isUnlocked ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.isUnlocked ? Color.blue : Color.clear, lineWidth: 2)
        )
        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.95)
        .animation(.spring(response: 0.3), value: achievement.isUnlocked)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Quest Progress Stat Card Component (renamed to avoid conflicts)

struct QuestProgressStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Data Models

struct Achievement {
    let id: String
    let title: String
    let description: String
    let emoji: String
    let isUnlocked: Bool
}
