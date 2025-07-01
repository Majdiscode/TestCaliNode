//
//  AppColors.swift.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  AppColors.swift
//  TestCaliNode
//
//  Clean color system - create this as a NEW file
//

import SwiftUI

// MARK: - App Color Palette
extension Color {
    
    // MAIN COLORS (from your palette)
    static let appPrimary = Color(hex: "#192F4D")    // Prussian blue
    static let appSecondary = Color(hex: "#BF9C73")  // Lion tan
    static let skillPrimary = Color(hex: "#07DEED")  // Robin egg blue
    static let skillSecondary = Color(hex: "#14A3A1") // Light sea green
    static let appError = Color(hex: "#B61624")      // Fire brick red
    
    // HOME SCREEN COLORS
    static let homePrimary = appPrimary
    static let homeAccent = appSecondary
    static let homeBackground = appPrimary.opacity(0.05)
    
    // SKILL COLORS
    static let skillUnlocked = skillPrimary
    static let skillLocked = Color.gray
    static let skillBranch = skillSecondary
    static let skillMaster = appSecondary
    
    // UI STATES
    static let success = skillPrimary
    static let warning = appError
    static let highlight = homeAccent
    
    // BUTTONS
    static let buttonPrimary = homePrimary
    static let buttonSecondary = homeAccent
    static let buttonSuccess = skillPrimary
    static let buttonDanger = appError
    
    // PROGRESS
    static let progressFill = homePrimary
    static let progressComplete = success
    
    // CARDS
    static let cardBackground = Color(UIColor.secondarySystemBackground)
    static let cardBorder = homeAccent.opacity(0.3)
    
    // TEXT
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textAccent = appPrimary
    
    // TREE COLORS
    static func treeColor(for treeID: String) -> Color {
        switch treeID {
        case "pull": return .skillPrimary
        case "push": return .skillSecondary
        case "core": return .skillBranch
        case "legs": return .skillPrimary
        default: return .skillPrimary
        }
    }
    
    // BRANCH COLORS
    static func branchColor(for branchID: String) -> Color {
        switch branchID {
        case "explosive", "strength", "static", "bilateral":
            return .skillPrimary
        case "isometric", "dynamic", "endurance", "unilateral":
            return .skillSecondary
        case "skill", "rotational", "plyometric":
            return .skillBranch
        default:
            return .skillPrimary
        }
    }
}

// MARK: - Helper for hex colors
extension Color {
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else { return "#000000" }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
