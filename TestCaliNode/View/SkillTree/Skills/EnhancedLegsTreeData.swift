//
//  UpdatedLegsTreeData.swift
//  TestCaliNode
//
//  NEW UNLOCK LOGIC - Prerequisites to unlock next skill
//

import Foundation
import SwiftUI

let enhancedLegsTreeV1 = EnhancedSkillTreeModel(
    id: "legs",
    name: "Legs Tree",
    version: 1,
    
    // FOUNDATIONAL SKILLS - Basic leg strength and mobility (TWO SEPARATE STARTING POINTS)
    foundationalSkills: [
        SkillNode(
            id: "bodyweightSquat",
            label: "🪑",
            fullLabel: "Bodyweight Squat (2x12)",
            tree: "legs",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 5 bodyweight squats?", // ✅ Easy entry requirement
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "wallSit",
            label: "🧱",
            fullLabel: "Wall Sit (60s)",
            tree: "legs",
            requires: [],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you hold a wall sit for 15 seconds?", // ✅ Easy entry requirement (separate from squats)
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        ),
        SkillNode(
            id: "stepUp",
            label: "🦵⬆️",
            fullLabel: "Step Ups (2x10)",
            tree: "legs",
            requires: ["bodyweightSquat", "wallSit"],
            variationLevel: 0,
            version: 1,
            confirmPrompt: "Can you do 2 sets of 12 bodyweight squats AND hold a wall sit for 60 seconds?", // ✅ Prerequisites: both foundation movements mastered
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
                    fullLabel: "Jump Squat (2x8)",
                    tree: "legs",
                    requires: ["stepUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 10 step ups per leg?", // ✅ Prerequisite: step-up strength and coordination
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "sissySquat",
                    label: "👸",
                    fullLabel: "Sissy Squat (2x6)",
                    tree: "legs",
                    requires: ["jumpSquat"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 jump squats?", // ✅ Prerequisite: explosive bilateral power
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "shrimpSquat",
                    label: "🦐",
                    fullLabel: "Shrimp Squat (1x2)",
                    tree: "legs",
                    requires: ["sissySquat"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 6 sissy squats?", // ✅ Prerequisite: quad strength and knee mobility
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
                    fullLabel: "Bulgarian Split Squat (2x8)",
                    tree: "legs",
                    requires: ["stepUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 10 step ups per leg?", // ✅ Prerequisite: single-leg coordination
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "assistedPistolSquat",
                    label: "🦿🤝",
                    fullLabel: "Assisted Pistol Squat (2x6)",
                    tree: "legs",
                    requires: ["bulgaianSplitSquat"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 Bulgarian split squats per leg?", // ✅ Prerequisite: split squat strength
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "pistolSquat",
                    label: "🦿",
                    fullLabel: "Pistol Squat (1x3)",
                    tree: "legs",
                    requires: ["assistedPistolSquat"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 6 assisted pistol squats per leg?", // ✅ Prerequisite: assisted pistol progression
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
                    fullLabel: "Broad Jump (3x4)",
                    tree: "legs",
                    requires: ["stepUp"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 10 step ups per leg?", // ✅ Prerequisite: leg coordination and power base
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "boxJump",
                    label: "📦⬆️",
                    fullLabel: "Box Jump 24\" (3x6)",
                    tree: "legs",
                    requires: ["broadJump"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 3 sets of 4 broad jumps?", // ✅ Prerequisite: horizontal jumping power
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "depthJump",
                    label: "⚡",
                    fullLabel: "Depth Jump (3x4)",
                    tree: "legs",
                    requires: ["boxJump"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 3 sets of 6 box jumps (24 inches)?", // ✅ Prerequisite: vertical jumping and landing control
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
            confirmPrompt: "Can you do 2 shrimp squats per leg AND 3 pistol squats per leg AND 4 depth jumps?", // ✅ Prerequisites: all three branch paths mastered
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    masterPositions: [
        "dragonSquat": CGPoint(x: 200, y: 80)
    ]
)
