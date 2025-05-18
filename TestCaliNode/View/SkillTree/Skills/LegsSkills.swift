//
//  LegsSkills.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/18/25.
//


import Foundation

let legsSkills: [SkillNode] = [
    SkillNode(id: "legsStart", label: "", fullLabel: "", requires: [], confirmPrompt: "", unlocked: true),
    SkillNode(id: "wallSit", label: "🪑", fullLabel: "Wall Sit (30s)", requires: ["legsStart"], confirmPrompt: "Can you hold a Wall Sit for 30 seconds?", unlocked: false),
    SkillNode(id: "stepUp", label: "🦵⬆️", fullLabel: "Step Ups (2x10)", requires: ["wallSit"], confirmPrompt: "Can you do 2 sets of 10 Step Ups?", unlocked: false),
    SkillNode(id: "pistolSquat", label: "🦿", fullLabel: "Pistol Squat (1x5)", requires: ["stepUp"], confirmPrompt: "Can you do 5 Pistol Squats?", unlocked: false)
]
