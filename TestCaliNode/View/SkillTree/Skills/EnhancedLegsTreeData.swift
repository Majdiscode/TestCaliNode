//
//  EnhancedLegsTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/14/25.
//

//
//  EnhancedLegsTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/14/25.
//

import Foundation
import SwiftUI

let enhancedLegsTreeV1 = EnhancedSkillTreeModel(
    id: "legs",
    name: "Legs Tree",
    version: 1,
    
    // FOUNDATIONAL SKILLS - Basic leg strength and mobility
    foundationalSkills: [
        SkillNode(
            id: "bodyweightSquat",
            label: "🪑",
            fullLabel: "Bodyweight Squat (2x15)",
            tree: "legs",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 15 Bodyweight Squats?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "wallSit",
            label: "🧱",
            fullLabel: "Wall Sit (45s)",
            tree: "legs",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you hold a Wall Sit for 45 seconds?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "stepUp",
            label: "🦵⬆️",
            fullLabel: "Step Ups (2x12)",
            tree: "legs",
            requires: ["bodyweightSquat", "wallSit"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 12 Step Ups per leg?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    foundationalPositions: [
        "bodyweightSquat": CGPoint(x: 120, y: 700),
        "wallSit": CGPoint(x: 280, y: 700),
        "stepUp": CGPoint(x: 200, y: 550)
    ],
    
    // SPECIALIZED BRANCHES
    branches: [
        // BILATERAL BRANCH - Two-leg strength
        SkillBranch(
            id: "bilateral",
            name: "Bilateral Power",
            description: "Two-leg strength and power",
            color: "#E67E22", // Orange
            skills: [
                SkillNode(
                    id: "jumpSquat",
                    label: "🦘",
                    fullLabel: "Jump Squat (2x10)",
                    tree: "legs",
                    requires: ["stepUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 10 Jump Squats?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "sissySquat",
                    label: "👸",
                    fullLabel: "Sissy Squat (2x8)",
                    tree: "legs",
                    requires: ["jumpSquat"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 Sissy Squats?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "shrimpSquat",
                    label: "🦐",
                    fullLabel: "Shrimp Squat (1x3)",
                    tree: "legs",
                    requires: ["sissySquat"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 3 Shrimp Squats per leg?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "jumpSquat": CGPoint(x: 80, y: 450),
                "sissySquat": CGPoint(x: 80, y: 320),
                "shrimpSquat": CGPoint(x: 80, y: 190)
            ]
        ),
        
        // UNILATERAL BRANCH - Single-leg strength
        SkillBranch(
            id: "unilateral",
            name: "Unilateral Control",
            description: "Single-leg strength and balance",
            color: "#27AE60", // Green
            skills: [
                SkillNode(
                    id: "bulgaianSplitSquat",
                    label: "🇧🇬",
                    fullLabel: "Bulgarian Split Squat (2x10)",
                    tree: "legs",
                    requires: ["stepUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 10 Bulgarian Split Squats per leg?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "assistedPistolSquat",
                    label: "🦿🤝",
                    fullLabel: "Assisted Pistol Squat (2x8)",
                    tree: "legs",
                    requires: ["bulgaianSplitSquat"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 Assisted Pistol Squats per leg?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "pistolSquat",
                    label: "🦿",
                    fullLabel: "Pistol Squat (1x5)",
                    tree: "legs",
                    requires: ["assistedPistolSquat"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 5 Pistol Squats per leg?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "bulgaianSplitSquat": CGPoint(x: 200, y: 450),
                "assistedPistolSquat": CGPoint(x: 200, y: 320),
                "pistolSquat": CGPoint(x: 200, y: 190)
            ]
        ),
        
        // PLYOMETRIC BRANCH - Explosive power
        SkillBranch(
            id: "plyometric",
            name: "Explosive Power",
            description: "Plyometric and explosive movements",
            color: "#2980B9", // Blue
            skills: [
                SkillNode(
                    id: "broadJump",
                    label: "🏃‍♂️",
                    fullLabel: "Broad Jump (3x5)",
                    tree: "legs",
                    requires: ["stepUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 3 sets of 5 Broad Jumps?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "boxJump",
                    label: "📦⬆️",
                    fullLabel: "Box Jump 24\" (3x8)",
                    tree: "legs",
                    requires: ["broadJump"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 3 sets of 8 Box Jumps (24 inches)?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "depthJump",
                    label: "⚡",
                    fullLabel: "Depth Jump (3x5)",
                    tree: "legs",
                    requires: ["boxJump"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 3 sets of 5 Depth Jumps?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "broadJump": CGPoint(x: 320, y: 450),
                "boxJump": CGPoint(x: 320, y: 320),
                "depthJump": CGPoint(x: 320, y: 190)
            ]
        )
    ],
    
    // MASTER SKILLS - Require skills from multiple branches
    masterSkills: [
        SkillNode(
            id: "dragonSquat",
            label: "🐲🦿",
            fullLabel: "Dragon Squat (1x1)",
            tree: "legs",
            requires: ["shrimpSquat", "pistolSquat", "depthJump"], // Cross-branch requirement
            variationLevel: 6,
            version: 1,
            confirmPrompt: "Can you do a Dragon Squat?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    masterPositions: [
        "dragonSquat": CGPoint(x: 200, y: 80)
    ]
)
