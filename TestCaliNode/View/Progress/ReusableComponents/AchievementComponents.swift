//
//  AchievementComponents.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  AchievementComponents.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ReusableComponents/AchievementComponents.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ReusableComponents/
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

// MARK: - Achievement Progress Ring
struct AchievementProgressRing: View {
    let achievement: AchievementData
    let progress: Double // 0.0 to 1.0
    let size: CGFloat
    
    init(achievement: AchievementData, progress: Double, size: CGFloat = 60) {
        self.achievement = achievement
        self.progress = min(max(progress, 0.0), 1.0)
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(achievement.category.color, lineWidth: 4)
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: progress)
            
            // Center content
            if achievement.isUnlocked {
                Text(achievement.emoji)
                    .font(.system(size: size * 0.4))
            } else {
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(achievement.category.color)
            }
        }
    }
}
