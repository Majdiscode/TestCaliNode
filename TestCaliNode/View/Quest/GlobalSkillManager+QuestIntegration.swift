//
//  GlobalSkillManager+QuestIntegration.swift
//  TestCaliNode
//
//  Quest integration for GlobalSkillManager - FIXED VERSION
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension GlobalSkillManager {
    
    // Enhanced unlock method with quest integration
    func unlockWithQuestIntegration(_ skillID: String) {
        let wasAlreadyUnlocked = isUnlocked(skillID)
        
        // Call the original unlock logic
        guard canUnlock(skillID) else { return }
        unlockedSkills.insert(skillID)
        
        // Save progress using the internal method
        saveProgress(skillID)
        
        // Notify quest system if this is a new unlock
        if !wasAlreadyUnlocked {
            QuestManager.shared.updateQuestProgress(skillUnlocked: skillID)
            checkSpecialQuestTriggers(skillID: skillID)
        }
        
        print("🔓 Unlocked skill: \(skillID)")
    }
    
    // Quest trigger checking (moved from main class to avoid conflicts)
    func checkSpecialQuestTriggers(skillID: String) {
        let questManager = QuestManager.shared
        
        // Check if this was a foundational skill
        let foundationalSkills = allEnhancedSkillTrees.flatMap { $0.foundationalSkills }
        if foundationalSkills.contains(where: { $0.id == skillID }) {
            questManager.triggerFoundationalSkillUnlock()
        }
        
        // Check if this completed a branch
        for tree in allEnhancedSkillTrees {
            for branch in tree.branches {
                let branchSkills = branch.skills.map(\.id)
                if branchSkills.contains(skillID) {
                    let allBranchSkillsUnlocked = branchSkills.allSatisfy { unlockedSkills.contains($0) }
                    if allBranchSkillsUnlocked {
                        questManager.triggerBranchCompletion(branchID: branch.id, treeID: tree.id)
                    }
                }
            }
        }
        
        // Check if this was a master skill
        let masterSkills = allEnhancedSkillTrees.flatMap { $0.masterSkills }
        if masterSkills.contains(where: { $0.id == skillID }) {
            questManager.triggerMasterSkillUnlock(skillID: skillID)
        }
        
        // Check if this completed a tree
        if let skill = allSkills[skillID] {
            let treeProgress = getTreeProgress(skill.tree)
            if treeProgress.unlocked == treeProgress.total && treeProgress.total > 0 {
                questManager.triggerTreeCompletion(treeID: skill.tree)
            }
        }
    }
}
