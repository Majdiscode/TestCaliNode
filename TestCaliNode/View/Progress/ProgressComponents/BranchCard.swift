//
//  BranchCard.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ReusableComponents/BranchCard.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ReusableComponents/
//

import SwiftUI

struct BranchCard: View {
    let tree: EnhancedSkillTreeModel
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with tree info
            cardHeader
            
            // Branch indicators grid
            branchGrid
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.treeColor(for: tree.id).opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Card Header
    private var cardHeader: some View {
        HStack {
            Text(treeEmoji(for: tree.id))
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(tree.name) Branches")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                // Overall tree progress
                let treeProgress = skillManager.getTreeProgress(tree.id)
                if treeProgress.total > 0 {
                    let percentage = Int((Double(treeProgress.unlocked) / Double(treeProgress.total)) * 100)
                    Text("\(percentage)% tree complete")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            // Mastered branches count
            let masteredCount = masteredBranchesInTree
            let totalBranches = tree.branches.count
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(masteredCount)/\(totalBranches)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text("mastered")
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(masteredCount == totalBranches && totalBranches > 0 ?
                          Color.success.opacity(0.2) : Color.homeBackground)
            )
        }
    }
    
    // MARK: - Branch Grid
    private var branchGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(tree.branches, id: \.id) { branch in
                BranchIndicator(branch: branch, skillManager: skillManager)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func treeEmoji(for treeID: String) -> String {
        switch treeID {
        case "pull": return "🆙"
        case "push": return "🙌"
        case "core": return "🧱"
        case "legs": return "🦿"
        default: return "🌟"
        }
    }
    
    private var masteredBranchesInTree: Int {
        var count = 0
        for branch in tree.branches {
            let branchSkillIDs = branch.skills.map(\.id)
            let unlockedInBranch = branchSkillIDs.filter { skillManager.isUnlocked($0) }.count
            if unlockedInBranch == branchSkillIDs.count && !branchSkillIDs.isEmpty {
                count += 1
            }
        }
        return count
    }
}

// MARK: - Branch Indicator
struct BranchIndicator: View {
    let branch: SkillBranch
    @ObservedObject var skillManager: GlobalSkillManager
    
    private var branchProgress: (unlocked: Int, total: Int) {
        let branchSkillIDs = branch.skills.map(\.id)
        let unlockedCount = branchSkillIDs.filter { skillManager.isUnlocked($0) }.count
        return (unlocked: unlockedCount, total: branchSkillIDs.count)
    }
    
    private var isMastered: Bool {
        branchProgress.unlocked == branchProgress.total && branchProgress.total > 0
    }
    
    private var progressPercentage: Double {
        guard branchProgress.total > 0 else { return 0 }
        return Double(branchProgress.unlocked) / Double(branchProgress.total)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Branch name
            Text(branch.name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            // Progress circle
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.branchColor(for: branch.id).opacity(0.3), lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: progressPercentage)
                    .stroke(Color.branchColor(for: branch.id), lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: branchProgress.unlocked)
                
                // Center content
                if isMastered {
                    Image(systemName: "checkmark")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.branchColor(for: branch.id))
                        .scaleEffect(1.2)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isMastered)
                } else if branchProgress.total > 0 {
                    Text("\(branchProgress.unlocked)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.branchColor(for: branch.id))
                }
            }
            
            // Progress text
            if branchProgress.total > 0 {
                Text("\(branchProgress.unlocked)/\(branchProgress.total)")
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isMastered ? Color.branchColor(for: branch.id).opacity(0.1) : Color.homeBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isMastered ? Color.branchColor(for: branch.id).opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Enhanced Branch Card with Tap Support
struct TappableBranchCard: View {
    let tree: EnhancedSkillTreeModel
    @ObservedObject var skillManager: GlobalSkillManager
    let onBranchTap: ((SkillBranch) -> Void)?
    let onCardTap: (() -> Void)?
    
    init(tree: EnhancedSkillTreeModel,
         skillManager: GlobalSkillManager,
         onBranchTap: ((SkillBranch) -> Void)? = nil,
         onCardTap: (() -> Void)? = nil) {
        self.tree = tree
        self.skillManager = skillManager
        self.onBranchTap = onBranchTap
        self.onCardTap = onCardTap
    }
    
    var body: some View {
        Button(action: {
            onCardTap?()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Text(treeEmoji(for: tree.id))
                        .font(.title2)
                    
                    Text("\(tree.name) Branches")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    if onCardTap != nil {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Interactive branch grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(tree.branches, id: \.id) { branch in
                        if let onBranchTap = onBranchTap {
                            Button(action: {
                                onBranchTap(branch)
                            }) {
                                BranchIndicator(branch: branch, skillManager: skillManager)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            BranchIndicator(branch: branch, skillManager: skillManager)
                        }
                    }
                }
            }
            .padding(20)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.treeColor(for: tree.id).opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(onCardTap == nil)
    }
    
    private func treeEmoji(for treeID: String) -> String {
        switch treeID {
        case "pull": return "🆙"
        case "push": return "🙌"
        case "core": return "🧱"
        case "legs": return "🦿"
        default: return "🌟"
        }
    }
}
