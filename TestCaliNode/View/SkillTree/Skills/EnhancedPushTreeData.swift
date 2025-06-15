//
//  EnhancedPushTreeData.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/14/25.
//


import Foundation
import SwiftUI

let enhancedPushTreeV1 = EnhancedSkillTreeModel(
    id: "push",
    name: "Push Tree",
    version: 1,
    
    // FOUNDATIONAL SKILLS - Building basic pushing strength
    foundationalSkills: [
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
    
    foundationalPositions: [
        "kneePushup": CGPoint(x: 200, y: 800),
        "inclinePushup": CGPoint(x: 200, y: 650),
        "pushup": CGPoint(x: 200, y: 500)
    ],
    
    // SPECIALIZED BRANCHES
    branches: [
        // STRENGTH BRANCH - High resistance, low reps
        SkillBranch(
            id: "strength",
            name: "Strength Push",
            description: "Maximum strength and power",
            color: "#E74C3C", // Red
            skills: [
                SkillNode(
                    id: "declinePushup",
                    label: "⬆️",
                    fullLabel: "Decline Push-Up (2x8)",
                    tree: "push",
                    requires: ["pushup"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 8 Decline Push-Ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "diamondPushup",
                    label: "💎",
                    fullLabel: "Diamond Push-Up (2x6)",
                    tree: "push",
                    requires: ["declinePushup"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 6 Diamond Push-Ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "oneArmPushup",
                    label: "☝️",
                    fullLabel: "One-Arm Push-Up (1x3)",
                    tree: "push",
                    requires: ["diamondPushup"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 3 One-Arm Push-Ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "declinePushup": CGPoint(x: 80, y: 400),
                "diamondPushup": CGPoint(x: 80, y: 300),
                "oneArmPushup": CGPoint(x: 80, y: 180)
            ]
        ),
        
        // ENDURANCE BRANCH - High volume
        SkillBranch(
            id: "endurance",
            name: "Endurance Push",
            description: "High volume and stamina",
            color: "#3498DB", // Blue
            skills: [
                SkillNode(
                    id: "widePushup",
                    label: "🤝",
                    fullLabel: "Wide Push-Up (2x12)",
                    tree: "push",
                    requires: ["pushup"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you do 2 sets of 12 Wide Push-Ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "endurancePushup",
                    label: "🔥",
                    fullLabel: "Endurance Push-Up (1x25)",
                    tree: "push",
                    requires: ["widePushup"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you do 25 consecutive Push-Ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "centuryPushup",
                    label: "💯",
                    fullLabel: "Century Push-Up (1x100)",
                    tree: "push",
                    requires: ["endurancePushup"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 100 consecutive Push-Ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "widePushup": CGPoint(x: 200, y: 400),
                "endurancePushup": CGPoint(x: 200, y: 300),
                "centuryPushup": CGPoint(x: 200, y: 180)
            ]
        ),
        
        // SKILL BRANCH - Balance and coordination
        SkillBranch(
            id: "skill",
            name: "Skill Push",
            description: "Balance and technical skills",
            color: "#9B59B6", // Purple
            skills: [
                SkillNode(
                    id: "handstandWallHold",
                    label: "🤸",
                    fullLabel: "Handstand Wall Hold (30s)",
                    tree: "push",
                    requires: ["pushup"],
                    variationLevel: 1,
                    version: 1,
                    confirmPrompt: "Can you hold a Handstand against wall for 30 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "freeHandstand",
                    label: "🤸‍♂️",
                    fullLabel: "Free Handstand (10s)",
                    tree: "push",
                    requires: ["handstandWallHold"],
                    variationLevel: 2,
                    version: 1,
                    confirmPrompt: "Can you hold a free Handstand for 10 seconds?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                ),
                SkillNode(
                    id: "handstandPushup",
                    label: "🤸‍♂️💪",
                    fullLabel: "Handstand Push-Up (1x3)",
                    tree: "push",
                    requires: ["freeHandstand"],
                    variationLevel: 3,
                    version: 1,
                    confirmPrompt: "Can you do 3 Handstand Push-Ups?",
                    unlocked: false,
                    masteryLevel: nil,
                    logHistory: []
                )
            ],
            positions: [
                "handstandWallHold": CGPoint(x: 320, y: 400),
                "freeHandstand": CGPoint(x: 320, y: 300),
                "handstandPushup": CGPoint(x: 320, y: 180)
            ]
        )
    ],
    
    // MASTER SKILLS - Require skills from multiple branches
    masterSkills: [
        SkillNode(
            id: "oneArmHandstandPushup",
            label: "☝️🤸‍♂️",
            fullLabel: "One-Arm Handstand Push-Up (1x1)",
            tree: "push",
            requires: ["oneArmPushup", "handstandPushup"], // Cross-branch requirement
            variationLevel: 6,
            version: 1,
            confirmPrompt: "Can you do a One-Arm Handstand Push-Up?",
            unlocked: false,
            masteryLevel: nil,
            logHistory: []
        )
    ],
    
    masterPositions: [
        "oneArmHandstandPushup": CGPoint(x: 200, y: 80)
    ]
)
