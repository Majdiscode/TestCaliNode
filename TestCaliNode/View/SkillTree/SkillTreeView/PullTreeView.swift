//
//  PullTreeView.swift
//  TestCaliNode
//

import SwiftUI

struct PullTreeView: View {
    var body: some View {
        ScrollView {
            SkillTreeLayoutView(
                skills: pullSkills,
                positions: pullPositions,
                baseSkillID: "pullStart",
                treeName: "pull"
            )
            .frame(minHeight: 1000)
            .padding(.top, 200)
        }
    }
}
