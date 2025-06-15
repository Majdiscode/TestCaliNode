//
//  EnhancedSkillTreeModel.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/14/25.
//

import Foundation
import SwiftUI

// MARK: - Original Model (for backward compatibility)
struct SkillTreeModel: Identifiable, Codable {
    let id: String
    let name: String
    let version: Int
    let skills: [SkillNode]
    let positions: [String: CGPoint]
}

// MARK: - Enhanced Models
struct SkillBranch: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let color: String
    let skills: [SkillNode]
    let positions: [String: CGPoint]
}

struct EnhancedSkillTreeModel: Identifiable, Codable {
    let id: String
    let name: String
    let version: Int
    let foundationalSkills: [SkillNode]
    let foundationalPositions: [String: CGPoint]
    let branches: [SkillBranch]
    let masterSkills: [SkillNode]
    let masterPositions: [String: CGPoint]
    
    var allSkills: [SkillNode] {
        var skills = foundationalSkills
        for branch in branches {
            skills.append(contentsOf: branch.skills)
        }
        skills.append(contentsOf: masterSkills)
        return skills
    }
    
    var allPositions: [String: CGPoint] {
        var positions = foundationalPositions
        for branch in branches {
            positions.merge(branch.positions) { _, new in new }
        }
        positions.merge(masterPositions) { _, new in new }
        return positions
    }
}

// MARK: - Protocol for compatibility
protocol TreeModel {
    var id: String { get }
    var name: String { get }
}

extension SkillTreeModel: TreeModel {}
extension EnhancedSkillTreeModel: TreeModel {}
