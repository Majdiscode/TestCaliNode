//
//  BranchButton.swift
//  TestCaliNode
//
//  Branch Button Component
//  CREATE this file in: View/SkillTree/Components/BranchButton.swift
//

import SwiftUI

struct BranchButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .scaleEffect(isSelected ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
