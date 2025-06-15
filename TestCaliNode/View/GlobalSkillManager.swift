//
//  GlobalSkillManager.swift
//  TestCaliNode
//
//  Fixed by Majd Iskandarani on 6/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class GlobalSkillManager: ObservableObject {
    @Published var unlockedSkills: Set<String> = []
    @Published var allSkills: [String: SkillNode] = [:]
    
    private let db = Firestore.firestore()
    
    init() {
        loadAllSkillsFromTrees() // Load all skills immediately
        loadUserProgress()
    }
    
    // MARK: - Load All Skills from Enhanced Trees
    private func loadAllSkillsFromTrees() {
        var skillsDict: [String: SkillNode] = [:]
        
        // Load all skills from all enhanced trees
        for tree in allEnhancedSkillTrees {
            // Add foundational skills
            for skill in tree.foundationalSkills {
                skillsDict[skill.id] = skill
            }
            
            // Add branch skills
            for branch in tree.branches {
                for skill in branch.skills {
                    skillsDict[skill.id] = skill
                }
            }
            
            // Add master skills
            for skill in tree.masterSkills {
                skillsDict[skill.id] = skill
            }
        }
        
        // Also load from original trees if any exist
        for tree in allSkillTrees {
            for skill in tree.skills {
                skillsDict[skill.id] = skill
            }
        }
        
        DispatchQueue.main.async {
            self.allSkills = skillsDict
            print("✅ Loaded \(skillsDict.count) total skills from all trees")
            self.printSkillCounts() // Debug helper
        }
    }
    
    // MARK: - Debug Helper
    private func printSkillCounts() {
        let treeCounts = ["pull", "push", "core", "legs"].map { treeID in
            let count = allSkills.values.filter { $0.tree == treeID }.count
            return "\(treeID): \(count)"
        }
        print("🔍 Skills per tree: \(treeCounts.joined(separator: ", "))")
    }
    
    // MARK: - Skill Management
    
    func canUnlock(_ skillID: String) -> Bool {
        guard let skill = allSkills[skillID] else { return false }
        guard !unlockedSkills.contains(skillID) else { return true }
        
        return skill.requires.allSatisfy { unlockedSkills.contains($0) }
    }
    
    func unlock(_ skillID: String) {
        guard canUnlock(skillID) else { return }
        
        unlockedSkills.insert(skillID)
        saveProgress(skillID)
        
        print("🔓 Unlocked skill: \(skillID)")
    }
    
    func isUnlocked(_ skillID: String) -> Bool {
        return unlockedSkills.contains(skillID)
    }
    
    func getUnmetRequirements(for skillID: String) -> [String] {
        guard let skill = allSkills[skillID] else { return [] }
        return skill.requires.filter { !unlockedSkills.contains($0) }
    }
    
    func getRequirementNames(for skillID: String) -> [String] {
        let unmetIDs = getUnmetRequirements(for: skillID)
        return unmetIDs.compactMap { id in
            allSkills[id]?.fullLabel.components(separatedBy: " (").first
        }
    }
    
    // MARK: - Progress Analytics
    
    func getTreeProgress(_ treeID: String) -> (unlocked: Int, total: Int) {
        let treeSkills = allSkills.values.filter { skill in
            return skill.tree == treeID
        }
        
        let unlockedCount = treeSkills.filter { unlockedSkills.contains($0.id) }.count
        let totalCount = treeSkills.count
        
        print("📊 Tree \(treeID): \(unlockedCount)/\(totalCount) skills")
        return (unlocked: unlockedCount, total: totalCount)
    }
    
    var globalLevel: Int {
        return unlockedSkills.count
    }
    
    var completionPercentage: Double {
        guard !allSkills.isEmpty else { return 0 }
        let percentage = Double(unlockedSkills.count) / Double(allSkills.count)
        print("📈 Completion: \(unlockedSkills.count)/\(allSkills.count) = \(Int(percentage * 100))%")
        return percentage
    }
    
    // MARK: - Branch Analytics
    func getBranchProgress(_ branchID: String, in treeID: String) -> (unlocked: Int, total: Int) {
        guard let tree = allEnhancedSkillTrees.first(where: { $0.id == treeID }),
              let branch = tree.branches.first(where: { $0.id == branchID }) else {
            return (0, 0)
        }
        
        let branchSkillIDs = branch.skills.map(\.id)
        let unlockedCount = branchSkillIDs.filter { unlockedSkills.contains($0) }.count
        return (unlocked: unlockedCount, total: branchSkillIDs.count)
    }
    
    func isBranchMastered(_ branchID: String, in treeID: String) -> Bool {
        let progress = getBranchProgress(branchID, in: treeID)
        return progress.unlocked == progress.total && progress.total > 0
    }
    
    // MARK: - Data Loading
    
    private func loadUserProgress() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("profiles").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let unlockedMap = snapshot?.data()?["skills"] as? [String: Bool] {
                DispatchQueue.main.async {
                    self.unlockedSkills = Set(unlockedMap.filter { $0.value }.map { $0.key })
                    print("📱 Loaded \(self.unlockedSkills.count) unlocked skills from Firebase")
                }
            }
        }
    }
    
    private func saveProgress(_ skillID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("profiles").document(uid).setData([
            "skills": [skillID: true]
        ], merge: true) { error in
            if let error = error {
                print("❌ Error saving skill \(skillID): \(error.localizedDescription)")
            } else {
                print("💾 Saved skill \(skillID) to Firebase")
            }
        }
    }
    
    // MARK: - Reset Functions
    
    func resetAllSkills() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let updates = Dictionary(uniqueKeysWithValues: unlockedSkills.map { ("skills.\($0)", FieldValue.delete()) })
        
        db.collection("profiles").document(uid).updateData(updates) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.unlockedSkills.removeAll()
                    print("🔄 Reset all skills")
                }
            }
        }
    }
    
    func resetTree(_ treeID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let treeSkillIDs = allSkills.values.filter { $0.tree == treeID }.map(\.id)
        let updates = Dictionary(uniqueKeysWithValues: treeSkillIDs.map { ("skills.\($0)", FieldValue.delete()) })
        
        db.collection("profiles").document(uid).updateData(updates) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    for skillID in treeSkillIDs {
                        self?.unlockedSkills.remove(skillID)
                    }
                    print("🔄 Reset tree: \(treeID)")
                }
            }
        }
    }
    
    // MARK: - Force Refresh (for debugging)
    func forceRefresh() {
        loadAllSkillsFromTrees()
        loadUserProgress()
    }
}
