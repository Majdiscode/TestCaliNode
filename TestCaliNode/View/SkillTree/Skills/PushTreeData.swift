//
//  PushTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/22/25.
//

import Foundation
import SwiftUI

let pushTreeV1 = SkillTreeModel(
    id: "push",
    name: "Push Tree",
    version: 1,
    skills: [
        SkillNode(
            id: "kneePushup",
            label: "🦵",
            fullLabel: "Knee Push-Up (2x10)",
            tree: "push",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 10 Knee Push-Ups?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "inclinePushup",
            label: "📐",
            fullLabel: "Incline Push-Up (2x8)",
            tree: "push",
            requires: ["kneePushup"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 8 Incline Push-Ups?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "pushup",
            label: "🙌",
            fullLabel: "Push-Up (2x10)",
            tree: "push",
            requires: ["inclinePushup"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 10 Push-Ups?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    positions: [
        "kneePushup": CGPoint(x: 200, y: 800),
        "inclinePushup": CGPoint(x: 200, y: 600),
        "pushup": CGPoint(x: 200, y: 400)
    ]
)
