//
//  BranchSelectionBar.swift
//  TestCaliNode
//
//  Branch Selection Bar Component
//  CREATE this file in: View/SkillTree/Components/BranchSelectionBar.swift
//

import SwiftUI

struct BranchSelectionBar: View {
    let branches: [SkillBranch]
    @Binding var selectedBranch: String?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                BranchButton(
                    title: "All",
                    isSelected: selectedBranch == nil,
                    color: .blue
                ) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        selectedBranch = nil
                    }
                }
                
                ForEach(branches, id: \.id) { branch in
                    BranchButton(
                        title: branch.name,
                        isSelected: selectedBranch == branch.id,
                        color: Color(hex: branch.color)
                    ) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            selectedBranch = selectedBranch == branch.id ? nil : branch.id
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(Color(UIColor.systemBackground).opacity(0.98))
    }
}
