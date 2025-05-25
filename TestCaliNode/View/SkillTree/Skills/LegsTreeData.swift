//
//  LegsTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/22/25.
//

import Foundation
import SwiftUI

let legsTreeV1 = SkillTreeModel(
    id: "legs",
    name: "Legs Tree",
    version: 1,
    skills: [
        SkillNode(
            id: "wallSit",
            label: "🪑",
            fullLabel: "Wall Sit (30s)",
            tree: "legs",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you hold a Wall Sit for 30 seconds?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "stepUp",
            label: "🦵⬆️",
            fullLabel: "Step Ups (2x10)",
            tree: "legs",
            requires: ["wallSit"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 10 Step Ups?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "pistolSquat",
            label: "🦿",
            fullLabel: "Pistol Squat (1x5)",
            tree: "legs",
            requires: ["stepUp"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 5 Pistol Squats?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    positions: [
        "wallSit": CGPoint(x: 200, y: 800),
        "stepUp": CGPoint(x: 200, y: 600),
        "pistolSquat": CGPoint(x: 200, y: 400)
    ]
)
