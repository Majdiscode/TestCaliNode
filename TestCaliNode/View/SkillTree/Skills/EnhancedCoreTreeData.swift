//
//  EnhancedCoreTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/14/25.
//

//
//  EnhancedCoreTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/14/25.
//

import Foundation
import SwiftUI

let enhancedCoreTreeV1 = EnhancedSkillTreeModel(
    id: "core",
    name: "Core Tree",
    version: 1,
    
    // FOUNDATIONAL SKILLS - Basic core stability
    foundationalSkills: [
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
            id: "deadBug",
            label: "🪲",
            fullLabel: "Dead Bug (2x10)",
            tree: "core",
            requires: ["plank", "hollowHold"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 10 Dead Bugs per side?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    foundationalPositions: [
        "plank": CGPoint(x: 120, y: 700),
        "hollowHold": CGPoint(x: 280, y: 700),
        "deadBug": CGPoint(x: 200, y: 550)
    ],
    
    // SPECIALIZED BRANCHES
    branches: [
        // STATIC HOLDS BRANCH - Isometric strength
        SkillBranch(
            id: "static",
            name: "Static Holds",
            description: "Isometric core strength",
            color: "#F39C12", // Orange
            skills: [
                SkillNode(
                    id: "sidePlank",
                    label: "📐",
                    fullLabel: "Side Plank (45s each)",
                    tree: "core",
                    requires: ["deadBug"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you hold Side Planks for 45 seconds each side?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "lSit",
                    label: "🪑",
                    fullLabel: "L-Sit (10s)",
                    tree: "core",
                    requires: ["sidePlank"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you hold an L-Sit for 10 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "vSit",
                    label: "✌️",
                    fullLabel: "V-Sit (5s)",
                    tree: "core",
                    requires: ["lSit"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you hold a V-Sit for 5 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "sidePlank": CGPoint(x: 80, y: 450),
                "lSit": CGPoint(x: 80, y: 320),
                "vSit": CGPoint(x: 80, y: 190)
            ]
        ),
        
        // DYNAMIC BRANCH - Movement-based exercises
        SkillBranch(
            id: "dynamic",
            name: "Dynamic Core",
            description: "Movement and coordination",
            color: "#16A085", // Teal
            skills: [
                SkillNode(
                    id: "legRaises",
                    label: "🦵⬆️",
                    fullLabel: "Leg Raises (2x10)",
                    tree: "core",
                    requires: ["deadBug"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 10 Leg Raises?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "toesToBar",
                    label: "🦶📏",
                    fullLabel: "Toes-to-Bar (2x8)",
                    tree: "core",
                    requires: ["legRaises"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 Toes-to-Bar?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "dragonFlag",
                    label: "🐉",
                    fullLabel: "Dragon Flag (1x5)",
                    tree: "core",
                    requires: ["toesToBar"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 5 Dragon Flags?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "legRaises": CGPoint(x: 200, y: 450),
                "toesToBar": CGPoint(x: 200, y: 320),
                "dragonFlag": CGPoint(x: 200, y: 190)
            ]
        ),
        
        // ROTATIONAL BRANCH - Rotational power and stability
        SkillBranch(
            id: "rotational",
            name: "Rotational Power",
            description: "Anti-rotation and power",
            color: "#8E44AD", // Purple
            skills: [
                SkillNode(
                    id: "russianTwist",
                    label: "🌪️",
                    fullLabel: "Russian Twist (2x20)",
                    tree: "core",
                    requires: ["deadBug"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 20 Russian Twists?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "windshieldWiper",
                    label: "🚗",
                    fullLabel: "Windshield Wiper (2x10)",
                    tree: "core",
                    requires: ["russianTwist"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 10 Windshield Wipers?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "humanFlag",
                    label: "🏳️",
                    fullLabel: "Human Flag (3s)",
                    tree: "core",
                    requires: ["windshieldWiper"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you hold a Human Flag for 3 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "russianTwist": CGPoint(x: 320, y: 450),
                "windshieldWiper": CGPoint(x: 320, y: 320),
                "humanFlag": CGPoint(x: 320, y: 190)
            ]
        )
    ],
    
    // MASTER SKILLS - Require skills from multiple branches
    masterSkills: [
        SkillNode(
            id: "oneArmHumanFlag",
            label: "☝️🏳️",
            fullLabel: "One-Arm Human Flag (1s)",
            tree: "core",
            requires: ["vSit", "dragonFlag", "humanFlag"], // Cross-branch requirement
            variationLevel: 6,
            version: 1,
            confirmPrompt: "Can you hold a One-Arm Human Flag for 1 second?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    masterPositions: [
        "oneArmHumanFlag": CGPoint(x: 200, y: 80)
    ]
)
