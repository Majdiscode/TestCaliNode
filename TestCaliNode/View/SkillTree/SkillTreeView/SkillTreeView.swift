//
//  SkillTreeView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//

import SwiftUI

struct SkillTreeView: View {
    var body: some View {
        TabView {
            ForEach(allSkillTrees) { tree in
                ScrollView {
                    SkillTreeLayoutView(
                        skills: tree.skills,
                        positions: tree.positions,
                        treeName: tree.id
                    )
                    .frame(minHeight: 1000)
                    .padding(.top, 200)
                }
                .tag(tree.id)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always)) // ✅ Shows page dots at bottom
    }
}
