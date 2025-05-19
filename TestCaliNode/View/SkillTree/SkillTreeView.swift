//
//  SkillTreeView.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//



//
//  SkillTreeView.swift
//  TestCaliNode
//
//
//  SkillTreeView.swift
//  TestCaliNode
//


//
//  SkillTreeView.swift
//  TestCaliNode
//

import SwiftUI

struct SkillTreeView: View {
    var body: some View {
        TabView {
            ForEach(allSkillTrees.indices, id: \.self) { i in
                ScrollView {
                    SkillTreeLayoutView(
                        skills: allSkillTrees[i].skills,
                        positions: allSkillTrees[i].positions,
                        treeName: allSkillTrees[i].name
                    )
                    .frame(minHeight: 1000)
                    .padding(.top, 200)
                }
                .tag(i)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
