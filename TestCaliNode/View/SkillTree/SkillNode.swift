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

struct SkillNode: Identifiable, Codable {
    let id: String
    let label: String
    let fullLabel: String
    let requires: [String]
    let confirmPrompt: String
    var unlocked: Bool
}
