//
//  AchievementTags.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 7/1/25.
//

//
//  AchievementTags.swift
//  TestCaliNode
//
//  Split from AchievementComponents.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

// MARK: - Category Tag
struct CategoryTag: View {
    let category: AchievementCategory
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.caption2)
            
            Text(category.displayName)
                .font(.caption)
        }
        .foregroundColor(category.color)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(category.color.opacity(0.1))
        )
    }
}

// MARK: - Rarity Tag
struct RarityTag: View {
    let rarity: AchievementRarity
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<rarity.rawValue, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.caption2)
            }
        }
        .foregroundColor(rarity.color)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(rarity.color.opacity(0.1))
        )
    }
}
