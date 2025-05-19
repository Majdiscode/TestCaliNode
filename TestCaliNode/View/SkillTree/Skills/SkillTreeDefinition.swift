//
//  SkillTreeDefinition.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/19/25.
//

import SwiftUI

struct SkillTreeDefinition {
    let name: String
    let positionedSkills: [PositionedSkill]

    var skills: [SkillNode] {
        positionedSkills.map(\.node)
    }

    var positions: [String: CGPoint] {
        Dictionary(uniqueKeysWithValues: positionedSkills.map { ($0.id, $0.position) })
    }
}

// Unified definition of all 4 skill trees
let allSkillTrees: [SkillTreeDefinition] = [
    // 🟣 Pull Tree
    SkillTreeDefinition(
        name: "pull",
        positionedSkills: [
            PositionedSkill(id: "deadHang", label: "🪢", fullLabel: "Dead Hang (10s)", requires: [], confirmPrompt: "Can you Dead Hang for 10 seconds?", unlocked: false, position: CGPoint(x: 200, y: 800)),
            PositionedSkill(id: "scapularPulls", label: "⬇️", fullLabel: "Scapular Pulls (2x6)", requires: ["deadHang"], confirmPrompt: "Can you do 2 sets of 6 Scapular Pulls?", unlocked: false, position: CGPoint(x: 200, y: 600)),
            PositionedSkill(id: "pullUp", label: "🆙", fullLabel: "Pull-Ups (2x5)", requires: ["scapularPulls"], confirmPrompt: "Can you do 2 sets of 5 Pull-Ups?", unlocked: false, position: CGPoint(x: 200, y: 400)),
            PositionedSkill(id: "isoHold", label: "🧍", fullLabel: "Isometric Hold (20s)", requires: ["pullUp"], confirmPrompt: "Can you hold an Isometric Pull-Up for 20 seconds?", unlocked: false, position: CGPoint(x: 100, y: 250))
        ]
    ),

    // 🔴 Push Tree
    SkillTreeDefinition(
        name: "push",
        positionedSkills: [
            PositionedSkill(id: "kneePushup", label: "🦵", fullLabel: "Knee Push-Up (2x10)", requires: [], confirmPrompt: "Can you do 2 sets of 10 Knee Push-Ups?", unlocked: false, position: CGPoint(x: 200, y: 800)),
            PositionedSkill(id: "inclinePushup", label: "📐", fullLabel: "Incline Push-Up (2x8)", requires: ["kneePushup"], confirmPrompt: "Can you do 2 sets of 8 Incline Push-Ups?", unlocked: false, position: CGPoint(x: 200, y: 600)),
            PositionedSkill(id: "pushup", label: "🙌", fullLabel: "Push-Up (2x10)", requires: ["inclinePushup"], confirmPrompt: "Can you do 2 sets of 10 Push-Ups?", unlocked: false, position: CGPoint(x: 200, y: 400))
        ]
    ),

    // 🟡 Core Tree
    SkillTreeDefinition(
        name: "core",
        positionedSkills: [
            PositionedSkill(id: "plank", label: "🧱", fullLabel: "Plank (60s)", requires: [], confirmPrompt: "Can you hold a Plank for 60 seconds?", unlocked: false, position: CGPoint(x: 280, y: 700)),
            PositionedSkill(id: "hollowHold", label: "🥚", fullLabel: "Hollow Hold (30s)", requires: [], confirmPrompt: "Can you do a Hollow Hold for 30 seconds?", unlocked: false, position: CGPoint(x: 120, y: 700)),
            PositionedSkill(id: "legRaises", label: "🦵⬆️", fullLabel: "Leg Raises (2x10)", requires: ["hollowHold", "plank"], confirmPrompt: "Can you do 2 sets of 10 Leg Raises?", unlocked: false, position: CGPoint(x: 200, y: 500))
        ]
    ),

    // 🟢 Legs Tree
    SkillTreeDefinition(
        name: "legs",
        positionedSkills: [
            PositionedSkill(id: "wallSit", label: "🪑", fullLabel: "Wall Sit (30s)", requires: [], confirmPrompt: "Can you hold a Wall Sit for 30 seconds?", unlocked: false, position: CGPoint(x: 200, y: 800)),
            PositionedSkill(id: "stepUp", label: "🦵⬆️", fullLabel: "Step Ups (2x10)", requires: ["wallSit"], confirmPrompt: "Can you do 2 sets of 10 Step Ups?", unlocked: false, position: CGPoint(x: 200, y: 600)),
            PositionedSkill(id: "pistolSquat", label: "🦿", fullLabel: "Pistol Squat (1x5)", requires: ["stepUp"], confirmPrompt: "Can you do 5 Pistol Squats?", unlocked: false, position: CGPoint(x: 200, y: 400))
        ]
    )
]
