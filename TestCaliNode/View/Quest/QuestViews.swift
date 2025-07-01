//
//  QuestViews.swift
//  TestCaliNode
//
//  Quest System UI Components - FIXED VERSION
//

import SwiftUI

// MARK: - Main Quest View

struct QuestView: View {
    @ObservedObject var questManager: QuestManager
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Player Stats Header
                playerStatsHeader
                
                // Quest Tabs
                questTabView
            }
            .navigationTitle("Quests")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Player Stats Header
    private var playerStatsHeader: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                // Experience
                VStack(spacing: 4) {
                    Text("\(questManager.playerExperience)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    Text("XP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Coins
                VStack(spacing: 4) {
                    Text("\(questManager.playerCoins)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                    Text("Coins")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Active Quests
                VStack(spacing: 4) {
                    Text("\(questManager.activeQuests.count)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                    Text("Active")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Completed Today
                VStack(spacing: 4) {
                    Text("\(todayCompletedCount)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.purple)
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress Bar for Next Level (if using XP levels)
            if questManager.playerExperience > 0 {
                let currentLevel = questManager.playerExperience / 100 + 1
                let progressToNext = Double(questManager.playerExperience % 100) / 100.0
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Level \(currentLevel)")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(questManager.playerExperience % 100)/100 XP")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: progressToNext)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(y: 2)
                }
            }
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
    
    private var todayCompletedCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return questManager.completedQuests.filter { quest in
            guard let completedAt = quest.completedAt else { return false }
            return Calendar.current.isDate(completedAt, inSameDayAs: today)
        }.count
    }
    
    // MARK: - Quest Tab View
    private var questTabView: some View {
        VStack(spacing: 0) {
            // Custom Tab Selector
            HStack(spacing: 0) {
                QuestTabButton(title: "Active", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                QuestTabButton(title: "Available", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                QuestTabButton(title: "Completed", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Tab Content
            TabView(selection: $selectedTab) {
                ActiveQuestsView(questManager: questManager)
                    .tag(0)
                
                AvailableQuestsView(questManager: questManager)
                    .tag(1)
                
                CompletedQuestsView(questManager: questManager)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

// MARK: - Tab Button Component

struct QuestTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(isSelected ? .blue : .clear)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Active Quests View

struct ActiveQuestsView: View {
    @ObservedObject var questManager: QuestManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if questManager.activeQuests.isEmpty {
                    EmptyStateView(
                        emoji: "🎯",
                        title: "No Active Quests",
                        description: "Start some quests from the Available tab to begin your adventure!"
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(questManager.activeQuests) { quest in
                        QuestCard(quest: quest, questManager: questManager, showStartButton: false)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Available Quests View

struct AvailableQuestsView: View {
    @ObservedObject var questManager: QuestManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if questManager.availableQuests.isEmpty {
                    EmptyStateView(
                        emoji: "🔒",
                        title: "No Available Quests",
                        description: "Keep progressing to unlock new challenges!"
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(questManager.availableQuests) { quest in
                        QuestCard(quest: quest, questManager: questManager, showStartButton: true)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Completed Quests View

struct CompletedQuestsView: View {
    @ObservedObject var questManager: QuestManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if questManager.completedQuests.isEmpty {
                    EmptyStateView(
                        emoji: "🏆",
                        title: "No Completed Quests",
                        description: "Complete your first quest to see it here!"
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(questManager.completedQuests.reversed()) { quest in
                        CompletedQuestCard(quest: quest)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Quest Card Component

struct QuestCard: View {
    let quest: Quest
    @ObservedObject var questManager: QuestManager
    let showStartButton: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text(quest.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(quest.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 12) {
                        QuestTypeTag(type: quest.type)
                        DifficultyTag(difficulty: quest.difficulty)
                        
                        if let expiresAt = quest.expiresAt {
                            ExpirationTag(expiresAt: expiresAt)
                        }
                    }
                }
                
                Spacer()
                
                // Start button for available quests
                if showStartButton {
                    Button("Start") {
                        questManager.startQuest(quest.id)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
            
            // Description
            Text(quest.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(nil)
            
            // Progress (for active quests)
            if quest.status == .active {
                QuestProgressView(progress: quest.progress)
            }
            
            // Rewards
            RewardView(reward: quest.reward)
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(quest.difficulty.color.opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Completed Quest Card

struct CompletedQuestCard: View {
    let quest: Quest
    
    var body: some View {
        HStack(spacing: 16) {
            Text(quest.emoji)
                .font(.system(size: 28))
                .opacity(0.8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(quest.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .strikethrough()
                    .opacity(0.8)
                
                if let completedAt = quest.completedAt {
                    Text("Completed \(completedAt, style: .relative) ago")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Checkmark
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundColor(.green)
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Components

struct QuestTypeTag: View {
    let type: QuestType
    
    var body: some View {
        Text(type.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(typeColor.opacity(0.2))
            .foregroundColor(typeColor)
            .clipShape(Capsule())
    }
    
    private var typeColor: Color {
        switch type {
        case .story: return .blue
        case .daily: return .orange
        case .weekly: return .purple
        case .random: return .green
        case .achievement: return .red
        }
    }
}

struct DifficultyTag: View {
    let difficulty: QuestDifficulty
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<difficultyStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(difficulty.color)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(difficulty.color.opacity(0.1))
        .clipShape(Capsule())
    }
    
    private var difficultyStars: Int {
        switch difficulty {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        case .legendary: return 4
        }
    }
}

struct ExpirationTag: View {
    let expiresAt: Date
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .font(.caption2)
            
            Text(timeUntilExpiration)
                .font(.caption2)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color.red.opacity(0.1))
        .foregroundColor(.red)
        .clipShape(Capsule())
    }
    
    private var timeUntilExpiration: String {
        let timeInterval = expiresAt.timeIntervalSinceNow
        
        if timeInterval < 0 {
            return "Expired"
        }
        
        let hours = Int(timeInterval / 3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct QuestProgressView: View {
    let progress: QuestProgress
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(progress.current)/\(progress.target)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            ProgressView(value: Double(progress.current), total: Double(progress.target))
                .progressViewStyle(LinearProgressViewStyle(tint: progress.isCompleted ? .green : .blue))
                .scaleEffect(y: 1.5)
        }
    }
}

struct RewardView: View {
    let reward: QuestReward
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rewards")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                // Experience
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("\(reward.experience) XP")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                // Coins
                HStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text("\(reward.coins)")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                // Title (if available)
                if let title = reward.title {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundColor(.purple)
                        Text(title)
                            .font(.caption)
                            .fontWeight(.medium)
                            .lineLimit(1)
                    }
                }
                
                // Badge (if available)
                if let badge = reward.badge {
                    HStack(spacing: 4) {
                        Text(badge)
                            .font(.caption)
                        Text("Badge")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }
}

struct EmptyStateView: View {
    let emoji: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text(emoji)
                .font(.system(size: 64))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }
}

// MARK: - Quest Completion Notification View

struct QuestCompletionNotification: View {
    let quest: Quest
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Success animation
            Text("🎉")
                .font(.system(size: 64))
                .scaleEffect(isShowing ? 1.2 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: isShowing)
            
            VStack(spacing: 12) {
                Text("Quest Completed!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(quest.title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // Rewards earned
                VStack(spacing: 8) {
                    Text("Rewards Earned:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("+\(quest.reward.experience)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text("XP")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text("+\(quest.reward.coins)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                            Text("Coins")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if quest.reward.title != nil || quest.reward.badge != nil {
                            VStack(spacing: 4) {
                                Text("🏆")
                                    .font(.title3)
                                Text("Bonus")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            
            Button("Awesome!") {
                withAnimation(.easeOut(duration: 0.3)) {
                    isShowing = false
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 20)
        )
        .padding(.horizontal, 40)
        .scaleEffect(isShowing ? 1 : 0.7)
        .opacity(isShowing ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isShowing)
    }
}
