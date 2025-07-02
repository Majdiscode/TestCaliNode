//
//  SkillNodeView.swift
//  TestCaliNode
//
//  Individual Skill Node Component
//  CREATE this file in: View/SkillTree/Components/SkillNodeView.swift
//

import SwiftUI

struct SkillNodeView: View {
    let skill: SkillNode
    let skillTree: EnhancedSkillTreeModel
    @ObservedObject var skillManager: GlobalSkillManager
    let branchColor: Color?
    let isVisible: Bool
    let onTap: (SkillNode) -> Void
    
    var body: some View {
        if let position = skillTree.allPositions[skill.id] {
            SkillCircleComponent(
                label: skill.label,
                unlocked: skillManager.isUnlocked(skill.id),
                branchColor: branchColor
            )
            .position(position)
            .id(skill.id)
            .opacity(isVisible ? 1.0 : 0.2)
            .scaleEffect(isVisible ? 1.0 : 0.7)
            .animation(.easeInOut(duration: 0.4), value: isVisible)
            .onTapGesture {
                onTap(skill)
            }
        }
    }
}
