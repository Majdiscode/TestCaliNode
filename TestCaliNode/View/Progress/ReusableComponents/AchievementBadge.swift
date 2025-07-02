//
//  AchievementBadge.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 7/1/25.
//

//
//  AchievementBadge.swift
//  TestCaliNode
//
//  Split from AchievementComponents.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

// MARK: - Achievement Data Model
struct AchievementData: Identifiable {
    let id: String
    let title: String
    let description: String
    let emoji: String
    let isUnlocked: Bool
    let unlockedDate: Date?
    let category: AchievementCategory
    let rarity: AchievementRarity
    
    init(id: String, title: String, description: String, emoji: String, isUnlocked: Bool, unlockedDate: Date? = nil, category: AchievementCategory = .general, rarity: AchievementRarity = .common) {
        self.id = id
        self.title = title
        self.description = description
        self.emoji = emoji
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
        self.category = category
        self.rarity = rarity
    }
}

// MARK: - Achievement Badge Sizes
enum AchievementBadgeSize {
    case small
    case medium
    case large
    
    var emojiSize: CGFloat {
        switch self {
        case .small: return 24
        case .medium: return 48
        case .large: return 64
        }
    }
    
    var frameSize: CGFloat {
        switch self {
        case .small: return 80
        case .medium: return 120
        case .large: return 160
        }
    }
    
    var titleFont: Font {
        switch self {
        case .small: return .caption
        case .medium: return .caption
        case .large: return .subheadline
        }
    }
    
    var descriptionFont: Font {
        switch self {
        case .small: return .caption2
        case .medium: return .caption2
        case .large: return .caption
        }
    }
}

// MARK: - Main Achievement Badge
struct AchievementBadge: View {
    let achievement: AchievementData
    let size: AchievementBadgeSize
    let onTap: (() -> Void)?
    
    @State private var isPressed = false
    
    init(achievement: AchievementData, size: AchievementBadgeSize = .medium, onTap: (() -> Void)? = nil) {
        self.achievement = achievement
        self.size = size
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(spacing: size == .small ? 8 : 12) {
                // Achievement emoji with rarity glow
                ZStack {
                    if achievement.isUnlocked && achievement.rarity != .common {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [achievement.rarity.glowColor.opacity(0.3), .clear],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: size.emojiSize / 2
                                )
                            )
                            .frame(width: size.emojiSize + 10, height: size.emojiSize + 10)
                    }
                    
                    Text(achievement.emoji)
                        .font(.system(size: size.emojiSize))
                        .opacity(achievement.isUnlocked ? 1.0 : 0.3)
                        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.9)
                        .saturation(achievement.isUnlocked ? 1.0 : 0.3)
                }
                
                // Title and description
                VStack(spacing: size == .small ? 2 : 6) {
                    Text(achievement.title)
                        .font(size.titleFont)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                    
                    if size != .small {
                        Text(achievement.description)
                            .font(size.descriptionFont)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                }
                
                // Rarity indicator (for medium and large sizes)
                if size != .small && achievement.isUnlocked {
                    rarityIndicator
                }
                
                // Unlock date (for large size only)
                if size == .large && achievement.isUnlocked, let date = achievement.unlockedDate {
                    Text("Unlocked \(date, style: .date)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: size.frameSize, height: size == .large ? size.frameSize + 40 : size.frameSize)
        .padding(size == .small ? 8 : 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(achievement.isUnlocked ? achievement.category.color.opacity(0.1) : Color.gray.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    achievement.isUnlocked ? achievement.category.color : Color.clear,
                    lineWidth: achievement.isUnlocked ? 2 : 0
                )
        )
        .scaleEffect(achievement.isUnlocked ? (isPressed ? 0.95 : 1.0) : 0.95)
        .animation(.spring(response: 0.3), value: achievement.isUnlocked)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .disabled(onTap == nil)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            if onTap != nil {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var rarityIndicator: some View {
        HStack(spacing: 2) {
            ForEach(0..<achievement.rarity.rawValue, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(achievement.rarity.color)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(achievement.rarity.color.opacity(0.1))
        )
    }
}

// MARK: - Compact Achievement Badge
struct CompactAchievementBadge: View {
    let achievement: AchievementData
    let size: CGFloat
    
    init(achievement: AchievementData, size: CGFloat = 40) {
        self.achievement = achievement
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(achievement.isUnlocked ? achievement.category.color.opacity(0.2) : Color.gray.opacity(0.1))
                .frame(width: size, height: size)
            
            if achievement.isUnlocked && achievement.rarity != .common {
                Circle()
                    .stroke(achievement.rarity.color, lineWidth: 2)
                    .frame(width: size, height: size)
            }
            
            Text(achievement.emoji)
                .font(.system(size: size * 0.5))
                .opacity(achievement.isUnlocked ? 1.0 : 0.3)
        }
        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.9)
        .animation(.spring(response: 0.3), value: achievement.isUnlocked)
    }
}
