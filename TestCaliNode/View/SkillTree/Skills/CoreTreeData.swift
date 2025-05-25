//
//  CoreTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/22/25.
//

import Foundation
import SwiftUI

let coreTreeV1 = SkillTreeModel(
    id: "core",
    name: "Core Tree",
    version: 1,
    skills: [
        SkillNode(
            id: "plank",
            label: "🧱",
            fullLabel: "Plank (60s)",
            tree: "core",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you hold a Plank for 60 seconds?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "hollowHold",
            label: "🥚",
            fullLabel: "Hollow Hold (30s)",
            tree: "core",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do a Hollow Hold for 30 seconds?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "legRaises",
            label: "🦵⬆️",
            fullLabel: "Leg Raises (2x10)",
            tree: "core",
            requires: ["plank", "hollowHold"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 10 Leg Raises?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    positions: [
        "plank": CGPoint(x: 280, y: 700),
        "hollowHold": CGPoint(x: 120, y: 700),
        "legRaises": CGPoint(x: 200, y: 500)
    ]
)
