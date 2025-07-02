//
//  PullTreeData.swift
//  TestCaliNode
//
//  FIXED VERSION - Replace your existing PullTreeData.swift
//

import Foundation
import SwiftUI

let enhancedPullTreeV1 = EnhancedSkillTreeModel(
    id: "pull",
    name: "Pull Tree",
    version: 1,
    
    // FOUNDATIONAL SKILLS
    foundationalSkills: [
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
        )
    ],
    
    foundationalPositions: [
        "deadHang": CGPoint(x: 200, y: 1000),
        "scapularPulls": CGPoint(x: 200, y: 800),
        "pullUp": CGPoint(x: 200, y: 600)
    ],
    
    // SPECIALIZED BRANCHES
    branches: [
        // EXPLOSIVE BRANCH
        SkillBranch(
            id: "explosive",
            name: "Explosive",
            description: "Power and speed",
            color: "#FF6B35",
            skills: [
                SkillNode(
                    id: "chestTouchPullup",
                    label: "💥",
                    fullLabel: "Chest-to-Bar Pull-up (2x3)",
                    tree: "pull",
                    requires: ["pullUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 3 Chest-to-Bar Pull-ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "muscleUp",
                    label: "💪",
                    fullLabel: "Muscle-Up (1x1)",
                    tree: "pull",
                    requires: ["chestTouchPullup"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do a Muscle-Up?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "chestTouchPullup": CGPoint(x: 60, y: 450),
                "muscleUp": CGPoint(x: 60, y: 250)
            ]
        ),
        
        // ISOMETRIC HOLDS BRANCH
        SkillBranch(
            id: "isometric",
            name: "Isometric",
            description: "Static strength",
            color: "#4ECDC4",
            skills: [
                SkillNode(
                    id: "flexedHang",
                    label: "💎",
                    fullLabel: "Flexed Arm Hang (10s)",
                    tree: "pull",
                    requires: ["pullUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you hold a Flexed Arm Hang for 10 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "frontLeverTuck",
                    label: "🦅",
                    fullLabel: "Front Lever Tuck (5s)",
                    tree: "pull",
                    requires: ["flexedHang"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you hold a Front Lever Tuck for 5 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "frontLever",
                    label: "🦅👑",
                    fullLabel: "Front Lever (3s)",
                    tree: "pull",
                    requires: ["frontLeverTuck"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you hold a Front Lever for 3 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "flexedHang": CGPoint(x: 200, y: 450),
                "frontLeverTuck": CGPoint(x: 200, y: 300),
                "frontLever": CGPoint(x: 200, y: 150)
            ]
        ),
        
        // UNILATERAL BRANCH
        SkillBranch(
            id: "unilateral",
            name: "Unilateral",
            description: "Single-arm strength",
            color: "#A8E6CF",
            skills: [
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
                    id: "oneArmPullup",
                    label: "☝️",
                    fullLabel: "One-Arm Pull-up (1x1)",
                    tree: "pull",
                    requires: ["archerPullup"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do a One-Arm Pull-up?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "archerPullup": CGPoint(x: 340, y: 450),
                "oneArmPullup": CGPoint(x: 340, y: 250)
            ]
        )
    ],
    
    // MASTER SKILLS
    masterSkills: [
        SkillNode(
            id: "oneArmFrontLever",
            label: "🦅☝️",
            fullLabel: "One-Arm Front Lever (1s)",
            tree: "pull",
            requires: ["frontLever", "oneArmPullup"],
            variationLevel: 6,
            version: 1,
            confirmPrompt: "Can you hold a One-Arm Front Lever for 1 second?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    masterPositions: [
        "oneArmFrontLever": CGPoint(x: 200, y: 50)
    ]
)
