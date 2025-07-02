//
//  SkillNodesLayer.swift
//  TestCaliNode
//
//  Skill Nodes Layer Component
//  CREATE this file in: View/SkillTree/Components/SkillNodesLayer.swift
//

import SwiftUI

struct SkillNodesLayer: View {
    let skillTree: EnhancedSkillTreeModel
    @ObservedObject var skillManager: GlobalSkillManager
    let selectedBranch: String?
    let onSkillTap: (SkillNode) -> Void
    
    var body: some View {
        Group {
            // Foundational skills
            ForEach(skillTree.foundationalSkills) { skill in
                SkillNodeView(
                    skill: skill,
                    skillTree: skillTree,
                    skillManager: skillManager,
                    branchColor: nil,
                    isVisible: selectedBranch == nil || isSkillInSelectedBranch(skill),
                    onTap: onSkillTap
                )
            }
            
            // Branch skills
            ForEach(skillTree.branches, id: \.id) { branch in
                if selectedBranch == nil || selectedBranch == branch.id {
                    ForEach(branch.skills) { skill in
                        SkillNodeView(
                            skill: skill,
                            skillTree: skillTree,
                            skillManager: skillManager,
                            branchColor: Color(hex: branch.color),
                            isVisible: true,
                            onTap: onSkillTap
                        )
                    }
                }
            }
            
            // Master skills
            ForEach(skillTree.masterSkills) { skill in
                SkillNodeView(
                    skill: skill,
                    skillTree: skillTree,
                    skillManager: skillManager,
                    branchColor: Color(hex: "#FFD700"),
                    isVisible: selectedBranch == nil,
                    onTap: onSkillTap
                )
            }
        }
    }
    
    private func isSkillInSelectedBranch(_ skill: SkillNode) -> Bool {
        guard let selectedBranch = selectedBranch else { return true }
        
        if skillTree.foundationalSkills.contains(where: { $0.id == skill.id }) ||
           skillTree.masterSkills.contains(where: { $0.id == skill.id }) {
            return true
        }
        
        return skillTree.branches.first(where: { $0.id == selectedBranch })?.skills.contains(where: { $0.id == skill.id }) == true
    }
}
