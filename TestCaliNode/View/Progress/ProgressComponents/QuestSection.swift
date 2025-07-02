//
//  QuestSection.swift
//  TestCaliNode
//
//  Renamed from QuestProgressSection.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

struct QuestSection: View {
    @ObservedObject var questManager: QuestManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Header
            sectionHeader
            
            // Quest Stats Grid
            questStatsGrid
            
            // Mini Quest Widget
            if !questManager.activeQuests.isEmpty {
                miniQuestWidget
            }
        }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            Image(systemName: "flag.fill")
                .font(.title2)
                .foregroundColor(.purple)
            
            Text("Quest Progress")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Quick XP display
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text("\(questManager.playerExperience) XP")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
            )
        }
    }
    
    // MARK: - Quest Stats Grid
    private var questStatsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            QuestStatCard(
                title: "Active Quests",
                value: "\(questManager.activeQuests.count)",
                color: .blue,
                icon: "flag.fill",
                subtitle: questManager.activeQuests.isEmpty ? "Start a quest" : "in progress"
            )
            
            QuestStatCard(
                title: "Completed Today",
                value: "\(todayCompletedQuests)",
                color: .green,
                icon: "checkmark.circle.fill",
                subtitle: todayCompletedQuests == 0 ? "Get started" : "great work!"
            )
            
            QuestStatCard(
                title: "Total XP",
                value: "\(questManager.playerExperience)",
                color: .purple,
                icon: "star.fill",
                subtitle: "Level \(currentLevel)"
            )
            
            QuestStatCard(
                title: "Coins Earned",
                value: "\(questManager.playerCoins)",
                color: .yellow,
                icon: "dollarsign.circle.fill",
                subtitle: questManager.playerCoins > 0 ? "Nice haul!" : "Earn some!"
            )
        }
    }
    
    // MARK: - Mini Quest Widget
    private var miniQuestWidget: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Active Quests")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                NavigationLink("View All") {
                    // This would navigate to the full quest view
                    // For now, just a placeholder
                    Text("Quest View Placeholder")
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                ForEach(Array(questManager.activeQuests.prefix(3))) { quest in
                    MiniQuestRow(quest: quest)
                }
                
                if questManager.activeQuests.count > 3 {
                    Text("+ \(questManager.activeQuests.count - 3) more")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Computed Properties
    private var todayCompletedQuests: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return questManager.completedQuests.filter { quest in
            guard let completedAt = quest.completedAt else { return false }
            return Calendar.current.isDate(completedAt, inSameDayAs: today)
        }.count
    }
    
    private var currentLevel: Int {
        return questManager.playerExperience / 100 + 1
    }
}

// MARK: - Quest Stat Card Component
struct QuestStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Mini Quest Row Component
struct MiniQuestRow: View {
    let quest: Quest
    
    var body: some View {
        HStack(spacing: 12) {
            Text(quest.emoji)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(quest.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text("\(quest.progress.current)/\(quest.progress.target)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Mini progress indicator
            CircularProgressIndicator(
                progress: Double(quest.progress.current) / Double(quest.progress.target),
                size: 24,
                color: quest.progress.isCompleted ? .green : .blue
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.tertiarySystemBackground))
        )
    }
}

// MARK: - Circular Progress Indicator
struct CircularProgressIndicator: View {
    let progress: Double
    let size: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 2)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, lineWidth: 2)
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            if progress >= 1.0 {
                Image(systemName: "checkmark")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
        }
    }
}
