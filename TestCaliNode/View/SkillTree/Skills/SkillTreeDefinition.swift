//
//  SkillTreeDefinition.swift
//  TestCaliNode
//



import Foundation
import SwiftUI

// MARK: - Original trees array (kept for backward compatibility, but empty for now)
let allSkillTrees: [SkillTreeModel] = []

// MARK: - Enhanced trees array - All four skill trees
let allEnhancedSkillTrees: [EnhancedSkillTreeModel] = [
    enhancedPullTreeV1,
    enhancedPushTreeV1,
    enhancedCoreTreeV1,
    enhancedLegsTreeV1
]

// MARK: - Helper functions for easy access
extension Array where Element == EnhancedSkillTreeModel {
    func tree(withID id: String) -> EnhancedSkillTreeModel? {
        return self.first { $0.id == id }
    }
    
    var pullTree: EnhancedSkillTreeModel? { tree(withID: "pull") }
    var pushTree: EnhancedSkillTreeModel? { tree(withID: "push") }
    var coreTree: EnhancedSkillTreeModel? { tree(withID: "core") }
    var legsTree: EnhancedSkillTreeModel? { tree(withID: "legs") }
}

// MARK: - Tree metadata for UI
struct TreeMetadata {
    let id: String
    let name: String
    let emoji: String
    let color: String
    let description: String
}

let treeMetadata: [TreeMetadata] = [
    TreeMetadata(
        id: "pull",
        name: "Pull Tree",
        emoji: "🆙",
        color: "#3498DB",
        description: "Upper body pulling strength and skills"
    ),
    TreeMetadata(
        id: "push",
        name: "Push Tree",
        emoji: "🙌",
        color: "#E74C3C",
        description: "Upper body pushing power and handstand skills"
    ),
    TreeMetadata(
        id: "core",
        name: "Core Tree",
        emoji: "🧱",
        color: "#F39C12",
        description: "Core stability, strength and control"
    ),
    TreeMetadata(
        id: "legs",
        name: "Legs Tree",
        emoji: "🦿",
        color: "#27AE60",
        description: "Lower body strength and explosive power"
    )
]
