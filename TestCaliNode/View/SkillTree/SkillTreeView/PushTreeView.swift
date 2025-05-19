//
//  PushTreeView.swift
//  TestCaliNode
//

import SwiftUI

struct PushTreeView: View {
    var body: some View {
        ScrollView {
            SkillTreeLayoutView(
                skills: pushSkills,
                positions: pushPositions,
                
                treeName: "push"
            )
            .frame(minHeight: 1000)
            .padding(.top, 200)
        }
    }
}
