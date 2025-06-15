//
//  SkillNode.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
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
    let tree: String
    let requires: [String]
    let variationLevel: Int
    let version: Int
    let confirmPrompt: String
    var unlocked: Bool
    var masteryLevel: Int?
    var logHistory: [WorkoutLog]
}
