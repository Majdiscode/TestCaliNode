//
//  SkillTreeSection.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  SkillTreeSection.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ProgressComponents/SkillTreeSection.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ProgressComponents/
//

import SwiftUI

struct SkillTreeSection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @State private var selectedTreeFilter: String? = nil
    
    private let allTrees = ["pull", "push", "core", "legs"]
    private let treeNames = [
        "pull": "Pull Tree",
        "push": "Push Tree",
        "core": "Core Tree",
        "legs": "Legs Tree"
    ]
    private let treeEmojis = [
        "pull": "🆙",
        "push": "🙌",
        "core": "🧱",
        "legs": "🦿"
    ]
    private let treeColors = [
        "pull": Color.blue,
        "push": Color.red,
        "core": Color.orange,
        "legs": Color.green
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Header
            sectionHeader
            
            // Tree Filter (optional)
            if showTreeFilter {
                treeFilterRow
            }
            
            // Skill Trees Grid
            skillTreesGrid
            
            // Tree Completion Summary
            if completedTreesCount > 0 {
                treeCompletionSummary
            }
        }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            Image(systemName: "tree.fill")
                .font(.title2)
                .foregroundColor(.green)
            
            Text("Skill Trees")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Trees completed indicator
            HStack(spacing: 8) {
                Text("\(completedTreesCount)/4")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(completedTreesCount == 4 ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
            )
        }
    }
    
    // MARK: - Tree Filter Row
    private var treeFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All trees button
                TreeFilterButton(
                    title: "All",
                    emoji: "🌳",
                    isSelected: selectedTreeFilter == nil,
                    color: .gray
                ) {
                    selectedTreeFilter = nil
                }
                
                // Individual tree buttons
                ForEach(allTrees, id: \.self) { treeID in
                    TreeFilterButton(
                        title: treeNames[treeID] ?? treeID,
                        emoji: treeEmojis[treeID] ?? "🌟",
                        isSelected: selectedTreeFilter == treeID,
                        color: treeColors[treeID] ?? .blue
                    ) {
                        selectedTreeFilter = selectedTreeFilter == treeID ? nil : treeID
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Skill Trees Grid
    private var skillTreesGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(filteredTrees, id: \.self) { treeID in
                SkillTreeCard(
                    treeID: treeID,
                    treeName: treeNames[treeID] ?? treeID,
                    emoji: treeEmojis[treeID] ?? "🌟",
                    color: treeColors[treeID] ?? .blue,
                    skillManager: skillManager
                )
            }
        }
    }
    
    // MARK: - Tree Completion Summary
    private var treeCompletionSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.green)
                
                Text("Completed Trees")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                ForEach(completedTrees, id: \.self) { treeID in
                    HStack(spacing: 8) {
                        Text(treeEmojis[treeID] ?? "🌟")
                            .font(.title3)
                        
                        Text(treeNames[treeID] ?? treeID)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill((treeColors[treeID] ?? .blue).opacity(0.2))
                    )
                }
                
                Spacer()
            }
            
            if completedTreesCount == 4 {
                Text("🎉 All trees mastered! You've achieved complete skill tree mastery!")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Computed Properties
    private var showTreeFilter: Bool {
        // Show filter if user has made significant progress
        return skillManager.globalLevel > 5
    }
    
    private var filteredTrees: [String] {
        if let selectedTreeFilter = selectedTreeFilter {
            return [selectedTreeFilter]
        }
        return allTrees
    }
    
    private var completedTreesCount: Int {
        allTrees.filter { treeID in
            let progress = skillManager.getTreeProgress(treeID)
            return progress.unlocked == progress.total && progress.total > 0
        }.count
    }
    
    private var completedTrees: [String] {
        allTrees.filter { treeID in
            let progress = skillManager.getTreeProgress(treeID)
            return progress.unlocked == progress.total && progress.total > 0
        }
    }
}

// MARK: - Tree Filter Button
struct TreeFilterButton: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(emoji)
                    .font(.title3)
                
                Text(title)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? color : Color.gray.opacity(0.1))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Skill Tree Card
struct SkillTreeCard: View {
    let treeID: String
    let treeName: String
    let emoji: String
    let color: Color
    @ObservedObject var skillManager: GlobalSkillManager
    
    private var progress: (unlocked: Int, total: Int) {
        skillManager.getTreeProgress(treeID)
    }
    
    private var progressPercentage: Double {
        guard progress.total > 0 else { return 0 }
        return Double(progress.unlocked) / Double(progress.total)
    }
    
    private var isCompleted: Bool {
        progress.unlocked == progress.total && progress.total > 0
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Tree emoji with completion indicator
            ZStack {
                Text(emoji)
                    .font(.system(size: 40))
                
                if isCompleted {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.green)
                                .background(Circle().fill(Color.white))
                        }
                    }
                }
            }
            
            VStack(spacing: 8) {
                Text(treeName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("\(progress.unlocked)/\(progress.total)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Progress bar
                ProgressView(value: progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: isCompleted ? .green : color))
                    .scaleEffect(y: 2)
                    .animation(.easeInOut(duration: 0.5), value: progressPercentage)
                
                // Progress percentage
                Text("\(Int(progressPercentage * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isCompleted ? .green : color)
            }
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCompleted ? .green : color, lineWidth: isCompleted ? 2 : 1)
                .opacity(progressPercentage > 0 ? 1 : 0.3)
        )
        .scaleEffect(isCompleted ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isCompleted)
    }
}
