//
//  QuestManager+Extensions.swift
//  TestCaliNode
//
//  Quest Manager Extensions for Skill Integration
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension QuestManager {
    
    func triggerFoundationalSkillUnlock() {
        // Create dynamic quest for unlocking more foundational skills
        let foundationalQuest = createDynamicQuest(
            id: "foundational_streak_\(Date().timeIntervalSince1970)",
            title: "Foundation Master",
            description: "Unlock 3 more foundational skills",
            targetCount: 3,
            emoji: "🏗️",
            difficulty: .medium
        )
        
        addDynamicQuest(foundationalQuest)
    }
    
    func triggerBranchCompletion(branchID: String, treeID: String) {
        // Award bonus XP for branch completion
        playerExperience += 150
        playerCoins += 75
        
        // Create follow-up quest
        let branchQuest = createDynamicQuest(
            id: "branch_explorer_\(branchID)_\(Date().timeIntervalSince1970)",
            title: "Branch Explorer",
            description: "Complete another branch in any tree",
            targetCount: 1,
            emoji: "🌿",
            difficulty: .hard
        )
        
        addDynamicQuest(branchQuest)
        
        // Show completion notification (simplified - just print for now)
        print("🌿 Branch Completed! +150 XP, +75 Coins")
    }
    
    func triggerMasterSkillUnlock(skillID: String) {
        // Award major bonus for master skill
        playerExperience += 300
        playerCoins += 150
        
        // Add special title
        let masterTitle = "Master of \(skillID.capitalized)"
        if !playerTitles.contains(masterTitle) {
            playerTitles.append(masterTitle)
        }
        
        print("👑 Master Skill Unlocked! +300 XP, +150 Coins, New Title Earned!")
    }
    
    func triggerTreeCompletion(treeID: String) {
        // Award massive bonus for tree completion
        playerExperience += 500
        playerCoins += 250
        
        // Add tree completion badge
        let treeBadge = "🌳 \(treeID.capitalized) Master"
        if !playerBadges.contains(treeBadge) {
            playerBadges.append(treeBadge)
        }
        
        print("🌳 Tree Mastered! +500 XP, +250 Coins, New Badge Earned!")
    }
    
    private func createDynamicQuest(
        id: String,
        title: String,
        description: String,
        targetCount: Int,
        emoji: String,
        difficulty: QuestDifficulty
    ) -> Quest {
        Quest(
            id: id,
            title: title,
            description: description,
            type: .random,
            difficulty: difficulty,
            emoji: emoji,
            requiredLevel: 0,
            requiredSkills: [],
            prerequisites: [],
            targetSkills: [],
            targetTrees: [],
            targetCount: targetCount,
            expiresAt: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            unlockDate: Date(),
            reward: QuestReward(
                experience: difficulty.experienceReward,
                coins: difficulty.experienceReward / 2,
                title: difficulty == .legendary ? title : nil,
                badge: difficulty == .legendary ? emoji : nil
            ),
            status: .available,
            progress: QuestProgress(current: 0, target: targetCount)
        )
    }
    
    private func addDynamicQuest(_ quest: Quest) {
        if !availableQuests.contains(where: { $0.id == quest.id }) &&
           !activeQuests.contains(where: { $0.id == quest.id }) {
            availableQuests.append(quest)
            saveQuestProgress()
        }
    }
}
