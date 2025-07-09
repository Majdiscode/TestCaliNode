//
//  UpdatedCoreTreeData.swift
//  TestCaliNode
//
//  NEW UNLOCK LOGIC - Fixed compilation errors
//

import Foundation
import SwiftUI

let enhancedCoreTreeV1 = EnhancedSkillTreeModel(
    id: "core",
    name: "Core Tree",
    version: 1,
    
    // FOUNDATIONAL SKILLS - Basic core stability (TWO SEPARATE STARTING POINTS)
    foundationalSkills: [
        SkillNode(
            id: "plank",
            label: "🧱",
            fullLabel: "Plank (60s)",
            tree: "core",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you hold a plank for 15 seconds?", // ✅ Easy entry requirement
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "hollowHold",
            label: "🥚",
            fullLabel: "Hollow Hold (45s)",
            tree: "core",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do a hollow hold for 10 seconds?", // ✅ Easy entry requirement (separate from plank)
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "deadBug",
            label: "🪲",
            fullLabel: "Dead Bug (2x8)",
            tree: "core",
            requires: ["plank", "hollowHold"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you hold a plank for 60 seconds AND a hollow hold for 45 seconds?", // ✅ Prerequisites: both foundation holds mastered
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
                    fullLabel: "Side Plank (60s each)",
                    tree: "core",
                    requires: ["deadBug"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 dead bugs per side?", // ✅ Prerequisite: core coordination
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "lSit",
                    label: "🪑",
                    fullLabel: "L-Sit (15s)",
                    tree: "core",
                    requires: ["sidePlank"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you hold side planks for 60 seconds each side?", // ✅ Prerequisite: lateral core strength
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "vSit",
                    label: "✌️",
                    fullLabel: "V-Sit (8s)",
                    tree: "core",
                    requires: ["lSit"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you hold an L-Sit for 15 seconds?", // ✅ Prerequisite: L-Sit progression
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
                    fullLabel: "Leg Raises (2x8)",
                    tree: "core",
                    requires: ["deadBug"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 dead bugs per side?", // ✅ Prerequisite: core coordination
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "toesToBar",
                    label: "🦶📏",
                    fullLabel: "Toes-to-Bar (2x6)",
                    tree: "core",
                    requires: ["legRaises"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 leg raises?", // ✅ Prerequisite: leg raise strength
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "dragonFlag",
                    label: "🐉",
                    fullLabel: "Dragon Flag (1x3)",
                    tree: "core",
                    requires: ["toesToBar"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 6 toes-to-bar?", // ✅ Prerequisite: advanced hanging core strength
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
                    fullLabel: "Russian Twist (2x15)",
                    tree: "core",
                    requires: ["deadBug"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 dead bugs per side?", // ✅ Prerequisite: core coordination
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "windshieldWiper",
                    label: "🚗",
                    fullLabel: "Windshield Wiper (2x8)",
                    tree: "core",
                    requires: ["russianTwist"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 15 Russian twists?", // ✅ Prerequisite: rotational endurance
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "humanFlag",
                    label: "🏳️",
                    fullLabel: "Human Flag (5s)",
                    tree: "core",
                    requires: ["windshieldWiper"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 windshield wipers?", // ✅ Prerequisite: hanging rotational strength
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
            fullLabel: "One-Arm Human Flag (2s)",
            tree: "core",
            requires: ["vSit", "dragonFlag", "humanFlag"], // Cross-branch requirement
            variationLevel: 6,
            version: 1,
            confirmPrompt: "Can you hold a V-Sit for 8 seconds AND do 3 dragon flags AND hold a human flag for 5 seconds?", // ✅ Prerequisites: all three branch paths mastered
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    masterPositions: [
        "oneArmHumanFlag": CGPoint(x: 200, y: 80)
    ]
)
