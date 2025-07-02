//
//  SkillTreeContainer.swift
//  TestCaliNode
//
//  FIXED VERSION - Properly synced navigation
//  REPLACE your existing SkillTreeContainer.swift
//

import SwiftUI

struct SkillTreeContainer: View {
    @ObservedObject var skillManager: GlobalSkillManager
    @State private var selectedTreeIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with tree selection and progress
            headerSection
            
            // Main content area with TabView
            TabView(selection: $selectedTreeIndex) {
                ForEach(Array(allEnhancedSkillTrees.enumerated()), id: \.offset) { index, tree in
                    SkillTreeLayoutContainer(
                        skillManager: skillManager,
                        skillTree: tree
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Current tree info card - NOW UPDATES WITH selectedTreeIndex
            if selectedTreeIndex < allEnhancedSkillTrees.count {
                let tree = allEnhancedSkillTrees[selectedTreeIndex]
                let metadata = treeMetadata.first { $0.id == tree.id }
                
                HStack {
                    Text(metadata?.emoji ?? "🌟")
                        .font(.system(size: 32))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tree.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(metadata?.description ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Progress indicator
                    VStack(alignment: .trailing, spacing: 4) {
                        let progress = skillManager.getTreeProgress(tree.id)
                        let progressPercentage = progress.total > 0 ? Double(progress.unlocked) / Double(progress.total) : 0
                        
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
                .padding(.horizontal, 20)
                .animation(.easeInOut(duration: 0.3), value: selectedTreeIndex) // Animate changes
            }
            
            // Tree navigation dots - NOW SYNCED WITH selectedTreeIndex
            HStack(spacing: 16) {
                ForEach(Array(allEnhancedSkillTrees.enumerated()), id: \.offset) { index, tree in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTreeIndex = index
                        }
                    }) {
                        VStack(spacing: 4) {
                            let metadata = treeMetadata.first { $0.id == tree.id }
                            let progress = skillManager.getTreeProgress(tree.id)
                            let isComplete = progress.unlocked == progress.total && progress.total > 0
                            let isSelected = selectedTreeIndex == index
                            
                            Text(metadata?.emoji ?? "🌟")
                                .font(.system(size: isSelected ? 24 : 18))
                                .scaleEffect(isSelected ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: isSelected)
                            
                            Circle()
                                .fill(isSelected ?
                                     Color(hex: metadata?.color ?? "#3498DB") :
                                     (isComplete ? .green : .gray.opacity(0.3)))
                                .frame(width: isSelected ? 8 : 6, height: isSelected ? 8 : 6)
                                .animation(.spring(response: 0.3), value: isSelected)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .background(Color(UIColor.systemBackground).opacity(0.95))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
