//
//  AllSkills.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/18/25.
//
// Only needed if AllSkills.swift is in another module or folder
// import SkillTreeDefinition


import Foundation

let allSkills: [SkillNode] = allSkillTrees.flatMap { $0.skills }
