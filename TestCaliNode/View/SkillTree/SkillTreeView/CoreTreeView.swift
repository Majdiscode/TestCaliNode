//
//  CoreTreeView.swift
//  TestCaliNode
//

import SwiftUI

struct CoreTreeView: View {
    var body: some View {
        ScrollView {
            SkillTreeLayoutView(
                skills: coreSkills,
                positions: corePositions,
                
                treeName: "core"
            )
            .frame(minHeight: 1000)
            .padding(.top, 200)
        }
    }
}
