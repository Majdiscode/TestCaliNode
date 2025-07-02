//
//  AchievementProgress.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 7/1/25.
//

//
//  AchievementProgress.swift
//  TestCaliNode
//
//  Split from AchievementComponents.swift - Created by Majd Iskandarani on 6/27/25.
//

import SwiftUI

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
