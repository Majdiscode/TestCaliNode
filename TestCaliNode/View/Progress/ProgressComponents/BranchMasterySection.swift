//
//  BranchMasterySection.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ProgressComponents/BranchMasterySection.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ProgressComponents/
//

import SwiftUI

struct BranchMasterySection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Header
            sectionHeader
            
            // Branch Cards for each tree
            VStack(spacing: 16) {
                ForEach(allEnhancedSkillTrees, id: \.id) { tree in
                    if !tree.branches.isEmpty {
                        BranchCard(tree: tree, skillManager: skillManager)
                    }
                }
            }
        }
    }
    
    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack {
            Image(systemName: "leaf.fill")
                .font(.title2)
                .foregroundColor(.skillSecondary)
            
            Text("Branch Mastery")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            // Overall branch completion
            let totalBranches = allEnhancedSkillTrees.flatMap { $0.branches }.count
            let masteredBranches = masteredBranchesCount
            
            if totalBranches > 0 {
                Text("\(masteredBranches)/\(totalBranches)")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.homeBackground)
                    )
            }
        }
    }
    
    // MARK: - Computed Properties
    private var masteredBranchesCount: Int {
        var count = 0
        for tree in allEnhancedSkillTrees {
            for branch in tree.branches {
                let branchSkillIDs = branch.skills.map(\.id)
                let unlockedInBranch = branchSkillIDs.filter { skillManager.isUnlocked($0) }.count
                if unlockedInBranch == branchSkillIDs.count && !branchSkillIDs.isEmpty {
                    count += 1
                }
            }
        }
        return count
    }
}

// MARK: - Alternative Compact Version
struct CompactBranchMasterySection: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Branch Mastery")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            // Horizontal scroll for trees
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(allEnhancedSkillTrees, id: \.id) { tree in
                        if !tree.branches.isEmpty {
                            CompactBranchCard(tree: tree, skillManager: skillManager)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct CompactBranchCard: View {
    let tree: EnhancedSkillTreeModel
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        VStack(spacing: 12) {
            // Tree info
            VStack(spacing: 4) {
                Text(treeEmoji(for: tree.id))
                    .font(.title2)
                
                Text(tree.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
            }
            
            // Compact branch indicators
            HStack(spacing: 8) {
                ForEach(tree.branches.prefix(3), id: \.id) { branch in
                    CompactBranchIndicator(branch: branch, skillManager: skillManager)
                }
                
                if tree.branches.count > 3 {
                    Text("+\(tree.branches.count - 3)")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .frame(width: 120)
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

struct CompactBranchIndicator: View {
    let branch: SkillBranch
    @ObservedObject var skillManager: GlobalSkillManager
    
    private var isMastered: Bool {
        let branchSkillIDs = branch.skills.map(\.id)
        let unlockedInBranch = branchSkillIDs.filter { skillManager.isUnlocked($0) }.count
        return unlockedInBranch == branchSkillIDs.count && !branchSkillIDs.isEmpty
    }
    
    var body: some View {
        Circle()
            .fill(isMastered ? Color.branchColor(for: branch.id) : Color.gray.opacity(0.3))
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    .stroke(Color.branchColor(for: branch.id), lineWidth: isMastered ? 0 : 1)
            )
            .overlay(
                Group {
                    if isMastered {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            )
    }
}

