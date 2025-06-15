//
//  AllSkills.swift
//  TestCaliNode
//
//  Updated by Majd Iskandarani on 6/14/25.
//

import Foundation

// Combined skills from all enhanced trees
let allSkills: [SkillNode] = {
    var skills: [SkillNode] = []
    
    // Add skills from original trees (if any exist)
    for tree in allSkillTrees {
        skills.append(contentsOf: tree.skills)
    }
    
    // Add skills from all enhanced trees
    for tree in allEnhancedSkillTrees {
        skills.append(contentsOf: tree.allSkills)
    }
    
    return skills
}()

// MARK: - Convenience accessors for specific skill categories

extension Array where Element == SkillNode {
    /// All foundational skills across all trees
    var foundationalSkills: [SkillNode] {
        return allEnhancedSkillTrees.flatMap { $0.foundationalSkills }
    }
    
    /// All master skills across all trees
    var masterSkills: [SkillNode] {
        return allEnhancedSkillTrees.flatMap { $0.masterSkills }
    }
    
    /// All branch skills across all trees
    var branchSkills: [SkillNode] {
        return allEnhancedSkillTrees.flatMap { tree in
            tree.branches.flatMap { $0.skills }
        }
    }
    
    /// Skills from a specific tree
    func skills(fromTree treeID: String) -> [SkillNode] {
        return self.filter { $0.tree == treeID }
    }
    
    /// Cross-tree skills (skills that require skills from other trees)
    var crossTreeSkills: [SkillNode] {
        return self.filter { skill in
            let skillTreeID = skill.tree
            return skill.requires.contains { requiredSkillID in
                // Check if any required skill is from a different tree
                if let requiredSkill = self.first(where: { $0.id == requiredSkillID }) {
                    return requiredSkill.tree != skillTreeID
                }
                return false
            }
        }
    }
}

// MARK: - Quick access to specific skills by ID
func skill(withID id: String) -> SkillNode? {
    return allSkills.first { $0.id == id }
}

// MARK: - Tree-specific skill arrays for backward compatibility
let pullSkills = allSkills.skills(fromTree: "pull")
let pushSkills = allSkills.skills(fromTree: "push")
let coreSkills = allSkills.skills(fromTree: "core")
let legsSkills = allSkills.skills(fromTree: "legs")
