//
//  QuestSystem.swift
//  TestCaliNode
//
//  Quest System Implementation
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - Quest Models

enum QuestType: String, Codable, CaseIterable {
    case story = "story"           // Predetermined story quests
    case daily = "daily"           // Daily challenges
    case weekly = "weekly"         // Weekly challenges
    case random = "random"         // Random quests
    case achievement = "achievement" // One-time achievements
}

enum QuestDifficulty: String, Codable, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    case legendary = "legendary"
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .orange
        case .legendary: return .purple
        }
    }
    
    var experienceReward: Int {
        switch self {
        case .easy: return 50
        case .medium: return 100
        case .hard: return 200
        case .legendary: return 500
        }
    }
}

enum QuestStatus: String, Codable {
    case locked = "locked"
    case available = "available"
    case active = "active"
    case completed = "completed"
    case expired = "expired"
}

struct QuestReward: Codable {
    let experience: Int
    let coins: Int
    let title: String?
    let badge: String?
}

struct QuestProgress: Codable {
    var current: Int
    var target: Int
    var isCompleted: Bool { current >= target }
}

struct Quest: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let type: QuestType
    let difficulty: QuestDifficulty
    let emoji: String
    
    // Requirements
    let requiredLevel: Int
    let requiredSkills: [String] // Skill IDs that must be unlocked
    let prerequisites: [String] // Quest IDs that must be completed
    
    // Quest specifics
    let targetSkills: [String] // Skills this quest involves
    let targetTrees: [String] // Trees this quest involves
    let targetCount: Int // How many times to complete the action
    
    // Timing
    let expiresAt: Date?
    let unlockDate: Date?
    
    // Rewards
    let reward: QuestReward
    
    // Status tracking
    var status: QuestStatus
    var progress: QuestProgress
    var startedAt: Date?
    var completedAt: Date?
}

// MARK: - Quest Manager

class QuestManager: ObservableObject {
    static let shared = QuestManager() // ✅ Proper singleton
    
    @Published var activeQuests: [Quest] = []
    @Published var completedQuests: [Quest] = []
    @Published var availableQuests: [Quest] = []
    @Published var playerExperience: Int = 0
    @Published var playerCoins: Int = 0
    @Published var playerTitles: [String] = []
    @Published var playerBadges: [String] = []
    
    // Reward notification properties
    @Published var showingBranchReward = false
    @Published var showingMasterReward = false
    @Published var showingTreeReward = false
    @Published var currentRewardMessage = ""
    
    private let db = Firestore.firestore()
    private var skillManager: GlobalSkillManager?
    
    // All possible quests (loaded from configuration)
    private var allQuests: [Quest] = []
    
    private init() { // ✅ Private init for singleton
        loadQuestTemplates()
        loadPlayerProgress()
        generateDailyQuests()
    }
    
    func setSkillManager(_ manager: GlobalSkillManager) {
        self.skillManager = manager
        refreshAvailableQuests()
    }
    
    // MARK: - Quest Templates
    
    private func loadQuestTemplates() {
        allQuests = [
            // STARTER QUEST - Only quest available at the beginning
            createStoryQuest(
                id: "first_unlock",
                title: "Begin Your Journey",
                description: "Unlock your very first skill to start your calisthenics adventure",
                requiredLevel: 0,
                targetCount: 1,
                emoji: "🎯"
            )
            
            // Future quests will be added here:
            // - Daily workout quests (after first skill unlock)
            // - Weekly challenges
            // - Achievement quests
        ]
    }
    
    // MARK: - Quest Creation Helpers
    
    private func createStoryQuest(
        id: String,
        title: String,
        description: String,
        requiredLevel: Int,
        requiredSkills: [String] = [],
        prerequisites: [String] = [],
        targetSkills: [String] = [],
        targetCount: Int,
        targetTrees: [String] = [],
        emoji: String
    ) -> Quest {
        Quest(
            id: id,
            title: title,
            description: description,
            type: .story,
            difficulty: .medium,
            emoji: emoji,
            requiredLevel: requiredLevel,
            requiredSkills: requiredSkills,
            prerequisites: prerequisites,
            targetSkills: targetSkills,
            targetTrees: targetTrees,
            targetCount: targetCount,
            expiresAt: nil,
            unlockDate: nil,
            reward: QuestReward(
                experience: 100,
                coins: 50,
                title: targetCount > 5 ? title : nil,
                badge: targetCount > 10 ? emoji : nil
            ),
            status: .locked,
            progress: QuestProgress(current: 0, target: targetCount)
        )
    }
    
    private func createAchievementQuest(
        id: String,
        title: String,
        description: String,
        requiredLevel: Int = 1,
        targetCount: Int,
        emoji: String
    ) -> Quest {
        Quest(
            id: id,
            title: title,
            description: description,
            type: .achievement,
            difficulty: .hard,
            emoji: emoji,
            requiredLevel: requiredLevel,
            requiredSkills: [],
            prerequisites: [],
            targetSkills: [],
            targetTrees: [],
            targetCount: targetCount,
            expiresAt: nil,
            unlockDate: nil,
            reward: QuestReward(
                experience: 200,
                coins: 100,
                title: title,
                badge: emoji
            ),
            status: .available,
            progress: QuestProgress(current: 0, target: targetCount)
        )
    }
    
    // MARK: - Daily Quest Generation (disabled for now)
    
    private func generateDailyQuests() {
        // Daily quests will be generated after first skill unlock
        // For now, keep this empty
        print("📅 Daily quest generation disabled - will activate after first skill unlock")
    }
    
    private func createDailyQuests(expiresAt: Date) -> [Quest] {
        let dailyQuestTemplates = [
            ("daily_skill_unlock", "Daily Progress", "Unlock any skill today", 1, "🎯"),
            ("daily_foundation", "Foundation Focus", "Work on foundational skills", 2, "🏗️"),
            ("daily_branch", "Branch Out", "Try skills from a new branch", 1, "🌿"),
            ("daily_consistency", "Stay Consistent", "Continue your training streak", 1, "🔥")
        ]
        
        let selectedTemplates = dailyQuestTemplates.shuffled().prefix(3)
        
        return selectedTemplates.map { template in
            Quest(
                id: "\(template.0)_\(DateFormatter.dayFormatter.string(from: Date()))",
                title: template.1,
                description: template.2,
                type: .daily,
                difficulty: .easy,
                emoji: template.4,
                requiredLevel: 0,
                requiredSkills: [],
                prerequisites: [],
                targetSkills: [],
                targetTrees: [],
                targetCount: template.3,
                expiresAt: expiresAt,
                unlockDate: nil,
                reward: QuestReward(experience: 25, coins: 10, title: nil, badge: nil),
                status: .available,
                progress: QuestProgress(current: 0, target: template.3)
            )
        }
    }
    
    // MARK: - Quest Management
    
    func refreshAvailableQuests() {
        guard let skillManager = skillManager else { return }
        
        let playerLevel = skillManager.globalLevel
        let unlockedSkills = skillManager.unlockedSkills
        
        for quest in allQuests {
            var questCopy = quest
            
            // Skip if quest is already completed
            if completedQuests.contains(where: { $0.id == questCopy.id }) {
                continue
            }
            
            // Skip if quest is already active
            if activeQuests.contains(where: { $0.id == questCopy.id }) {
                continue
            }
            
            // Skip if quest is already in available quests
            if availableQuests.contains(where: { $0.id == questCopy.id }) {
                continue
            }
            
            // Check if quest should be unlocked
            if questCopy.status == .locked {
                let levelMet = playerLevel >= questCopy.requiredLevel
                let skillsMet = questCopy.requiredSkills.allSatisfy { unlockedSkills.contains($0) }
                let prerequisitesMet = questCopy.prerequisites.allSatisfy { prereqID in
                    completedQuests.contains { $0.id == prereqID }
                }
                
                if levelMet && skillsMet && prerequisitesMet {
                    questCopy.status = .available
                    availableQuests.append(questCopy)
                }
            }
        }
    }
    
    func startQuest(_ questID: String) {
        if let index = availableQuests.firstIndex(where: { $0.id == questID }) {
            var quest = availableQuests[index]
            quest.status = .active
            quest.startedAt = Date()
            
            activeQuests.append(quest)
            availableQuests.remove(at: index)
            
            saveQuestProgress()
        }
    }
    
    func updateQuestProgress(skillUnlocked: String) {
        var questsToUpdate: [(Int, Quest)] = []
        
        // First, collect quests that need updating
        for i in 0..<activeQuests.count {
            let quest = activeQuests[i]
            
            if quest.status == .active && !quest.progress.isCompleted {
                if shouldUpdateQuest(quest, for: skillUnlocked) {
                    var updatedQuest = quest
                    updatedQuest.progress.current += 1
                    questsToUpdate.append((i, updatedQuest))
                }
            }
        }
        
        // Now update the quests and handle completion
        var completedQuestIndices: [Int] = []
        
        for (index, var updatedQuest) in questsToUpdate.reversed() {
            if updatedQuest.progress.isCompleted {
                completeQuest(&updatedQuest)
                completedQuestIndices.append(index)
            } else {
                activeQuests[index] = updatedQuest
            }
        }
        
        // Remove completed quests from active quests (in reverse order to maintain indices)
        for index in completedQuestIndices.sorted(by: >) {
            if index < activeQuests.count {
                activeQuests.remove(at: index)
            }
        }
        
        saveQuestProgress()
    }
    
    private func shouldUpdateQuest(_ quest: Quest, for skillID: String) -> Bool {
        switch quest.type {
        case .story, .daily, .achievement:
            // Check if this skill contributes to the quest
            if !quest.targetSkills.isEmpty {
                return quest.targetSkills.contains(skillID)
            }
            
            if !quest.targetTrees.isEmpty,
               let skill = skillManager?.allSkills[skillID] {
                return quest.targetTrees.contains(skill.tree)
            }
            
            // Default: any skill unlock counts
            return true
            
        case .weekly, .random:
            return true
        }
    }
    
    private func completeQuest(_ quest: inout Quest) {
        quest.status = .completed
        quest.completedAt = Date()
        
        // Award rewards
        playerExperience += quest.reward.experience
        playerCoins += quest.reward.coins
        
        if let title = quest.reward.title {
            playerTitles.append(title)
        }
        
        if let badge = quest.reward.badge {
            playerBadges.append(badge)
        }
        
        // Add to completed quests (don't remove from active here, that's handled in updateQuestProgress)
        completedQuests.append(quest)
        
        // Check for newly unlocked quests
        refreshAvailableQuests()
        
        print("🎉 Quest completed: \(quest.title) - Earned \(quest.reward.experience) XP and \(quest.reward.coins) coins!")
    }
    
    // MARK: - Data Persistence
    
    func saveQuestProgress() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let questData: [String: Any] = [
            "activeQuests": activeQuests.compactMap { try? JSONEncoder().encode($0) }.map { String(data: $0, encoding: .utf8)! },
            "completedQuests": completedQuests.compactMap { try? JSONEncoder().encode($0) }.map { String(data: $0, encoding: .utf8)! },
            "availableQuests": availableQuests.compactMap { try? JSONEncoder().encode($0) }.map { String(data: $0, encoding: .utf8)! },
            "playerExperience": playerExperience,
            "playerCoins": playerCoins,
            "playerTitles": playerTitles,
            "playerBadges": playerBadges
        ]
        
        db.collection("profiles").document(uid).setData([
            "quests": questData
        ], merge: true)
    }
    
    private func loadPlayerProgress() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("profiles").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self,
                  let questData = snapshot?.data()?["quests"] as? [String: Any] else { return }
            
            DispatchQueue.main.async {
                if let activeQuestStrings = questData["activeQuests"] as? [String] {
                    self.activeQuests = activeQuestStrings.compactMap { string in
                        guard let data = string.data(using: .utf8) else { return nil }
                        return try? JSONDecoder().decode(Quest.self, from: data)
                    }
                }
                
                if let completedQuestStrings = questData["completedQuests"] as? [String] {
                    self.completedQuests = completedQuestStrings.compactMap { string in
                        guard let data = string.data(using: .utf8) else { return nil }
                        return try? JSONDecoder().decode(Quest.self, from: data)
                    }
                }
                
                if let availableQuestStrings = questData["availableQuests"] as? [String] {
                    self.availableQuests = availableQuestStrings.compactMap { string in
                        guard let data = string.data(using: .utf8) else { return nil }
                        return try? JSONDecoder().decode(Quest.self, from: data)
                    }
                }
                
                self.playerExperience = questData["playerExperience"] as? Int ?? 0
                self.playerCoins = questData["playerCoins"] as? Int ?? 0
                self.playerTitles = questData["playerTitles"] as? [String] ?? []
                self.playerBadges = questData["playerBadges"] as? [String] ?? []
            }
        }
    }
    
    // MARK: - Reset Functions (for testing)
    
    func resetAllQuests() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Clear all quest data from Firebase
        db.collection("profiles").document(uid).updateData([
            "quests": FieldValue.delete()
        ]) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    // Clear all local quest data
                    self?.activeQuests.removeAll()
                    self?.completedQuests.removeAll()
                    self?.availableQuests.removeAll()
                    self?.playerExperience = 0
                    self?.playerCoins = 0
                    self?.playerTitles.removeAll()
                    self?.playerBadges.removeAll()
                    
                    // Regenerate initial quests
                    self?.loadQuestTemplates()
                    self?.generateDailyQuests()
                    self?.refreshAvailableQuests()
                    
                    print("🔄 Reset all quest data")
                }
            } else {
                print("❌ Error resetting quests: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func resetQuestProgress() {
        // Reset only progress, keep unlocked quests but reset their progress
        for i in 0..<activeQuests.count {
            activeQuests[i].progress.current = 0
            activeQuests[i].status = .available
        }
        
        // Move active quests back to available
        availableQuests.append(contentsOf: activeQuests)
        activeQuests.removeAll()
        
        // Reset player stats but keep completed quests for reference
        playerExperience = 0
        playerCoins = 0
        
        saveQuestProgress()
        print("🔄 Reset quest progress only")
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
