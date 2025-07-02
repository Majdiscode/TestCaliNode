//
//  AchievementRow.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 7/1/25.
//

//
//  AchievementRow.swift
//  TestCaliNode
//
//  Split from AchievementComponents.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

// MARK: - Achievement Row (for lists)
struct AchievementRow: View {
    let achievement: AchievementData
    let showCategory: Bool
    let onTap: (() -> Void)?
    
    init(achievement: AchievementData, showCategory: Bool = true, onTap: (() -> Void)? = nil) {
        self.achievement = achievement
        self.showCategory = showCategory
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: 16) {
                // Achievement emoji
                ZStack {
                    Circle()
                        .fill(achievement.isUnlocked ? achievement.category.color.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Text(achievement.emoji)
                        .font(.title2)
                        .opacity(achievement.isUnlocked ? 1.0 : 0.3)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(achievement.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                        
                        Spacer()
                        
                        if achievement.isUnlocked {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Text(achievement.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        if showCategory {
                            CategoryTag(category: achievement.category)
                        }
                        
                        if achievement.isUnlocked {
                            RarityTag(rarity: achievement.rarity)
                        }
                        
                        Spacer()
                        
                        if achievement.isUnlocked, let date = achievement.unlockedDate {
                            Text(date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(onTap == nil)
    }
}
