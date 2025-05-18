//
//  PullSkills.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/18/25.
//

// SkillTree/Skills/PullSkills.swift

import Foundation

let pullSkills: [SkillNode] = [
    SkillNode(id: "pullStart", label: "", fullLabel: "", requires: [], confirmPrompt: "", unlocked: true),
    SkillNode(id: "deadHang", label: "🪢", fullLabel: "Dead Hang (10s)", requires: ["pullStart"], confirmPrompt: "Can you Dead Hang for 10 seconds?", unlocked: false),
    SkillNode(id: "scapularPulls", label: "⬇️", fullLabel: "Scapular Pulls (2x6)", requires: ["deadHang"], confirmPrompt: "Can you do 2 sets of 6 Scapular Pulls?", unlocked: false),
    SkillNode(id: "pullUp", label: "🆙", fullLabel: "Pull-Ups (2x5)", requires: ["scapularPulls"], confirmPrompt: "Can you do 2 sets of 5 Pull-Ups?", unlocked: false),
    SkillNode(id: "isoHold",label: "🧍",fullLabel: "Isometric Hold (20s)",requires: ["pullUp"],confirmPrompt: "Can you hold an Isometric Pull-Up for 20 seconds?",
        unlocked: false)

]
