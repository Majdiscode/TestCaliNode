//
//  CoreSkills.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/18/25.
//

import Foundation

let coreSkills: [SkillNode] = [
    SkillNode(id: "plank", label: "🧱", fullLabel: "Plank (60s)", requires: [], confirmPrompt: "Can you hold a Plank for 60 seconds?", unlocked: false),
    SkillNode(id: "hollowHold", label: "🥚", fullLabel: "Hollow Hold (30s)", requires: [], confirmPrompt: "Can you do a Hollow Hold for 30 seconds?", unlocked: false),
    SkillNode(id: "legRaises", label: "🦵⬆️", fullLabel: "Leg Raises (2x10)", requires: ["hollowHold", "plank"], confirmPrompt: "Can you do 2 sets of 10 Leg Raises?", unlocked: false)
]
