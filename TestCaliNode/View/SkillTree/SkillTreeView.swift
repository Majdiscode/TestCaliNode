//
//  SkillTreeView.swift
//  TestCaliNode
//
//  Updated by Majd Iskandarani on 6/14/25.
//

import SwiftUI

struct SkillTreeView: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @State private var selectedTreeIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Tree selection header
            treeSelectionHeader
            
            // Tabbed skill trees
            TabView(selection: $selectedTreeIndex) {
                ForEach(Array(allEnhancedSkillTrees.enumerated()), id: \.offset) { index, tree in
                    EnhancedSkillTreeLayoutView(
                        skillManager: skillManager,
                        skillTree: tree
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never)) // Hide default dots since we have custom header
        }
        .navigationBarHidden(true)
    }
    
    private var treeSelectionHeader: some View {
        VStack(spacing: 12) {
            // Current tree title
            if selectedTreeIndex < allEnhancedSkillTrees.count {
                let currentTree = allEnhancedSkillTrees[selectedTreeIndex]
                let metadata = treeMetadata.first { $0.id == currentTree.id }
                
                HStack {
                    Text(metadata?.emoji ?? "🌟")
                        .font(.system(size: 32))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentTree.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(metadata?.description ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Progress indicator for current tree
                    TreeProgressIndicator(
                        skillManager: skillManager,
                        treeID: currentTree.id
                    )
                }
                .padding(.horizontal, 20)
            }
            
            // Tree selection dots/indicators
            HStack(spacing: 16) {
                ForEach(Array(allEnhancedSkillTrees.enumerated()), id: \.offset) { index, tree in
                    let metadata = treeMetadata.first { $0.id == tree.id }
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTreeIndex = index
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(metadata?.emoji ?? "🌟")
                                .font(.system(size: selectedTreeIndex == index ? 24 : 18))
                                .scaleEffect(selectedTreeIndex == index ? 1.2 : 1.0)
                            
                            // Progress dot
                            let progress = skillManager.getTreeProgress(tree.id)
                            let isComplete = progress.unlocked == progress.total && progress.total > 0
                            
                            Circle()
                                .fill(selectedTreeIndex == index ?
                                     Color(hex: metadata?.color ?? "#3498DB") :
                                     (isComplete ? .green : .gray.opacity(0.3)))
                                .frame(width: selectedTreeIndex == index ? 8 : 6, height: selectedTreeIndex == index ? 8 : 6)
                        }
                    }
                    .animation(.spring(response: 0.3), value: selectedTreeIndex)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .background(Color(UIColor.systemBackground).opacity(0.95))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Supporting Views

struct TreeProgressIndicator: View {
    @ObservedObject var skillManager: GlobalSkillManager
    let treeID: String
    
    private var progress: (unlocked: Int, total: Int) {
        skillManager.getTreeProgress(treeID)
    }
    
    private var progressPercentage: Double {
        guard progress.total > 0 else { return 0 }
        return Double(progress.unlocked) / Double(progress.total)
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("\(progress.unlocked)/\(progress.total)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ProgressView(value: progressPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: progressPercentage == 1.0 ? .green : .blue))
                .frame(width: 60)
                .scaleEffect(y: 1.5)
        }
    }
}

