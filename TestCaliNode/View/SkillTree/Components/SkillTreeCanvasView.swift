//
//  SkillTreeCanvasView.swift
//  TestCaliNode
//
//  Canvas View - actual skill layout
//  CREATE this file in: View/SkillTree/Components/SkillTreeCanvasView.swift
//

import SwiftUI

struct SkillTreeCanvasView: View {
    let skillTree: EnhancedSkillTreeModel
    @ObservedObject var skillManager: GlobalSkillManager
    let selectedBranch: String?
    let onSkillTap: (SkillNode) -> Void
    
    var body: some View {
        ScrollView {
            let contentHeight: CGFloat = 1200
            
            ZStack {
                // Connection lines
                SkillConnectionLines(
                    skillTree: skillTree,
                    selectedBranch: selectedBranch
                )
                
                // Skill nodes
                SkillNodesLayer(
                    skillTree: skillTree,
                    skillManager: skillManager,
                    selectedBranch: selectedBranch,
                    onSkillTap: onSkillTap
                )
            }
            .frame(width: UIScreen.main.bounds.width, height: contentHeight)
            .clipped()
        }
    }
}
