//
//  AchievementEnums.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 7/1/25.
//

//
//  AchievementEnums.swift
//  TestCaliNode
//
//  Split from AchievementComponents.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

// MARK: - Achievement Category
enum AchievementCategory: String, CaseIterable {
    case general = "general"
    case skillTree = "skillTree"
    case milestone = "milestone"
    case workout = "workout"
    case quest = "quest"
    
    var displayName: String {
        switch self {
        case .general: return "General"
        case .skillTree: return "Skill Trees"
        case .milestone: return "Milestones"
        case .workout: return "Workouts"
        case .quest: return "Quests"
        }
    }
    
    var color: Color {
        switch self {
        case .general: return .blue
        case .skillTree: return .green
        case .milestone: return .purple
        case .workout: return .orange
        case .quest: return .pink
        }
    }
    
    var icon: String {
        switch self {
        case .general: return "star.fill"
        case .skillTree: return "tree.fill"
        case .milestone: return "flag.fill"
        case .workout: return "figure.strengthtraining.traditional"
        case .quest: return "scroll.fill"
        }
    }
}

// MARK: - Achievement Rarity
enum AchievementRarity: Int, CaseIterable {
    case common = 1
    case rare = 2
    case epic = 3
    case legendary = 4
    
    var displayName: String {
        switch self {
        case .common: return "Common"
        case .rare: return "Rare"
        case .epic: return "Epic"
        case .legendary: return "Legendary"
        }
    }
    
    var color: Color {
        switch self {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
    
    var glowColor: Color {
        switch self {
        case .common: return .clear
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}
