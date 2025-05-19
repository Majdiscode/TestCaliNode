//
//  LegsTreeView.swift
//  TestCaliNode
//

import SwiftUI

struct LegsTreeView: View {
    var body: some View {
        ScrollView {
            SkillTreeLayoutView(
                skills: legsSkills,
                positions: legsPositions,
                
                treeName: "legs"
            )
            .frame(minHeight: 1000)
            .padding(.top, 200)
        }
    }
}
