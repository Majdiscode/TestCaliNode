//
//  PushSkills.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/18/25.
//

import Foundation

let pushSkills: [SkillNode] = [
    SkillNode(id: "kneePushup", label: "🦵", fullLabel: "Knee Push-Up (2x10)", requires: [], confirmPrompt: "Can you do 2 sets of 10 Knee Push-Ups?", unlocked: false),
    SkillNode(id: "inclinePushup", label: "📐", fullLabel: "Incline Push-Up (2x8)", requires: ["kneePushup"], confirmPrompt: "Can you do 2 sets of 8 Incline Push-Ups?", unlocked: false),
    SkillNode(id: "pushup", label: "🙌", fullLabel: "Push-Up (2x10)", requires: ["inclinePushup"], confirmPrompt: "Can you do 2 sets of 10 Push-Ups?", unlocked: false)
]
