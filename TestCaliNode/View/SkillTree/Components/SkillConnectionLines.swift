//
//  SkillConnectionLines.swift
//  TestCaliNode
//
//  Connection Lines Component
//  CREATE this file in: View/SkillTree/Components/SkillConnectionLines.swift
//

import SwiftUI

struct SkillConnectionLines: View {
    let skillTree: EnhancedSkillTreeModel
    let selectedBranch: String?
    
    var body: some View {
        ForEach(skillTree.allSkills, id: \.id) { skill in
            ForEach(skill.requires, id: \.self) { reqID in
                if let from = skillTree.allPositions[reqID],
                   let to = skillTree.allPositions[skill.id] {
                    
                    let isVisible = selectedBranch == nil ||
                                   isSkillVisible(skill) ||
                                   skillTree.foundationalSkills.contains(where: { $0.id == reqID })
                    
                    MinimalistLineConnector(from: from, to: to)
                        .opacity(isVisible ? 0.6 : 0.1)
                        .animation(.easeInOut(duration: 0.4), value: selectedBranch)
                }
            }
        }
    }
    
    private func isSkillVisible(_ skill: SkillNode) -> Bool {
        guard let selectedBranch = selectedBranch else { return true }
        return skillTree.branches.first(where: { $0.id == selectedBranch })?.skills.contains(where: { $0.id == skill.id }) == true
    }
}
