//
//  PullTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/22/25.
//

import Foundation
import SwiftUI

let pullTreeV1 = SkillTreeModel(
    id: "pull",
    name: "Pull Tree",
    version: 1,
    skills: [
        SkillNode(
            id: "deadHang",
            label: "🪢",
            fullLabel: "Dead Hang (10s)",
            tree: "pull",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you Dead Hang for 10 seconds?",
            unlocked: false,
            masteryLevel: 0,
            logHistory: []
        ),
        SkillNode(
            id: "scapularPulls",
            label: "⬇️",
            fullLabel: "Scapular Pulls (2x6)",
            tree: "pull",
            requires: ["deadHang"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 6 Scapular Pulls?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "pullUp",
            label: "🆙",
            fullLabel: "Pull-Ups (2x5)",
            tree: "pull",
            requires: ["scapularPulls"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 5 Pull-Ups?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "archerPullup",
            label: "🏹",
            fullLabel: "Archer Pull-Ups (2x3)",
            tree: "pull",
            requires: ["pullUp"],
            variationLevel: 1,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 3 Archer Pull-Ups?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "muscleUp",
            label: "💪",
            fullLabel: "Muscle-Up (1x1)",
            tree: "pull",
            requires: ["archerPullup"],
            variationLevel: 2,
            version: 1,
            confirmPrompt: "Can you do a Muscle-Up?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "fullBodyFlow",
            label: "🌐",
            fullLabel: "Full Body Flow (1x3)",
            tree: "pull",
            requires: ["pushup", "legRaises", "pistolSquat"],  // 👈 cross-tree skills
            variationLevel: 3,
            version: 1,
            confirmPrompt: "Can you do 3 reps of Full Body Flow?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )

    ],
    positions: [
        "deadHang": CGPoint(x: 200, y: 800),
        "scapularPulls": CGPoint(x: 200, y: 600),
        "pullUp": CGPoint(x: 200, y: 400),
        "archerPullup": CGPoint(x: 200, y: 250),
        "muscleUp": CGPoint(x: 200, y: 100),
        "fullBodyFlow": CGPoint(x: 120, y: 50),

    ]
)
