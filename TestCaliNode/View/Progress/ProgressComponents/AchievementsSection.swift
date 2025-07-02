//
//  AchievementsSection.swift
//  TestCaliNode
//
//  Fixed - Uses split achievement components without duplicates
//

import SwiftUI

struct AchievementsSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @State private var selectedCategory: AchievementCategory? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section header with achievements count
            sectionHeader
            
            // Category filter (optional)
            if showCategoryFilter {
                categoryFilter
            }
            
            // Achievements display
            achievementsDisplay
        }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            Image(systemName: "trophy.fill")
                .font(.title2)
                .foregroundColor(.orange)
            
            Text("Achievements")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Achievement stats
            let unlockedCount = achievementsList.filter { $0.isUnlocked }.count
            let totalCount = achievementsList.count
            
            HStack(spacing: 8) {
                Text("\(unlockedCount)/\(totalCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                // Progress indicator
                ProgressView(value: Double(unlockedCount), total: Double(totalCount))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .frame(width: 60)
                    .scaleEffect(y: 1.5)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
            )
        }
    }
    
    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All categories button
                CategoryFilterButton(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    color: .blue
                ) {
                    selectedCategory = nil
                }
                
                // Individual category buttons
                ForEach(AchievementCategory.allCases, id: \.rawValue) { category in
                    let categoryAchievements = achievementsList.filter { $0.category == category }
                    if !categoryAchievements.isEmpty {
                        CategoryFilterButton(
                            title: category.displayName,
                            isSelected: selectedCategory == category,
                            color: category.color
                        ) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Achievements Display
    private var achievementsDisplay: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(filteredAchievements, id: \.id) { achievement in
                    AchievementBadge(
                        achievement: achievement,
                        size: .medium,
                        onTap: {
                            // Could add achievement detail view here
                            print("Tapped achievement: \(achievement.title)")
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Computed Properties
    private var showCategoryFilter: Bool {
        // Only show filter if we have achievements in multiple categories
        let categoriesWithAchievements = Set(achievementsList.map { $0.category })
        return categoriesWithAchievements.count > 1
    }
    
    private var filteredAchievements: [AchievementData] {
        if let selectedCategory = selectedCategory {
            return achievementsList.filter { $0.category == selectedCategory }
        }
        return achievementsList
    }
    
    var achievementsList: [AchievementData] {
        [
            AchievementData(
                id: "first_skill",
                title: "First Steps",
                description: "Unlock your first skill",
                emoji: "🎯",
                isUnlocked: skillManager.globalLevel >= 1,
                unlockedDate: skillManager.globalLevel >= 1 ? Date() : nil,
                category: .skillTree,
                rarity: .common
            ),
            AchievementData(
                id: "foundational_complete",
                title: "Strong Foundation",
                description: "Complete all foundational skills",
                emoji: "🏗️",
                isUnlocked: foundationalSkillsComplete,
                unlockedDate: foundationalSkillsComplete ? Date() : nil,
                category: .skillTree,
                rarity: .rare
            ),
            AchievementData(
                id: "first_branch",
                title: "Branch Explorer",
                description: "Master your first branch",
                emoji: "🌿",
                isUnlocked: masteredBranchesCount >= 1,
                unlockedDate: masteredBranchesCount >= 1 ? Date() : nil,
                category: .skillTree,
                rarity: .epic
            ),
            AchievementData(
                id: "tree_complete",
                title: "Tree Master",
                description: "Complete any skill tree",
                emoji: "🌳",
                isUnlocked: completedTreesCount >= 1,
                unlockedDate: completedTreesCount >= 1 ? Date() : nil,
                category: .milestone,
                rarity: .epic
            ),
            AchievementData(
                id: "master_skill",
                title: "Master Achiever",
                description: "Unlock a master skill",
                emoji: "👑",
                isUnlocked: masterSkillsUnlocked >= 1,
                unlockedDate: masterSkillsUnlocked >= 1 ? Date() : nil,
                category: .milestone,
                rarity: .legendary
            ),
            AchievementData(
                id: "half_way",
                title: "Halfway Hero",
                description: "Reach 50% completion",
                emoji: "⭐",
                isUnlocked: skillManager.completionPercentage >= 0.5,
                unlockedDate: skillManager.completionPercentage >= 0.5 ? Date() : nil,
                category: .general,
                rarity: .rare
            ),
            AchievementData(
                id: "all_trees",
                title: "Grand Master",
                description: "Complete all skill trees",
                emoji: "🏆",
                isUnlocked: completedTreesCount >= 4,
                unlockedDate: completedTreesCount >= 4 ? Date() : nil,
                category: .milestone,
                rarity: .legendary
            ),
            AchievementData(
                id: "master_achieved",
                title: "Calisthenics God",
                description: "Achieve 100% completion",
                emoji: "🔥",
                isUnlocked: skillManager.completionPercentage >= 1.0,
                unlockedDate: skillManager.completionPercentage >= 1.0 ? Date() : nil,
                category: .milestone,
                rarity: .legendary
            ),
            AchievementData(
                id: "dedicated_trainer",
                title: "Dedicated Trainer",
                description: "Train for 7 consecutive days",
                emoji: "💪",
                isUnlocked: false, // Would need workout tracking
                category: .workout,
                rarity: .rare
            ),
            AchievementData(
                id: "speed_demon",
                title: "Speed Demon",
                description: "Unlock 5 skills in one day",
                emoji: "⚡",
                isUnlocked: false, // Would need daily tracking
                category: .general,
                rarity: .epic
            )
        ]
    }
    
    // MARK: - Achievement Calculation Helpers
    private var foundationalSkillsComplete: Bool {
        let foundationalSkills = allEnhancedSkillTrees.flatMap { $0.foundationalSkills }
        return foundationalSkills.allSatisfy { skillManager.isUnlocked($0.id) }
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
    
    private var masterSkillsUnlocked: Int {
        let masterSkills = allEnhancedSkillTrees.flatMap { $0.masterSkills }
        return masterSkills.filter { skillManager.isUnlocked($0.id) }.count
    }
}

// MARK: - Category Filter Button (moved here to avoid duplication)
struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
