//
//  PositionedSkill.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/19/25.
//

import SwiftUI

struct PositionedSkill {
    var id: String
    var label: String
    var fullLabel: String
    var requires: [String]
    var confirmPrompt: String
    var unlocked: Bool
    var position: CGPoint

    var node: SkillNode {
        SkillNode(
            id: id,
            label: label,
            fullLabel: fullLabel,
            requires: requires,
            confirmPrompt: confirmPrompt,
            unlocked: unlocked
        )
    }
}
