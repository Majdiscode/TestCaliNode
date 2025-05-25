//
//  SkillNode.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//


//
//  SkillNode.swift
//  TestCaliNode
//

import Foundation

struct WorkoutLog: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let sets: Int
    let reps: Int
    let notes: String?
}

struct SkillNode: Identifiable, Codable {
    let id: String
    let label: String
    let fullLabel: String
    let tree: String                  // e.g., "pull", "core"
    let requires: [String]           // Supports cross-tree dependencies
    let variationLevel: Int          // 0 = base, 1 = harder, etc.
    let version: Int                 // For versioned skill trees

    let confirmPrompt: String
    var unlocked: Bool               // Has user unlocked this skill?
    var masteryLevel: Int?           // 0 = beginner, 1 = intermediate, 2 = advanced
    var logHistory: [WorkoutLog]     // Logs of training sessions for this skill
}
