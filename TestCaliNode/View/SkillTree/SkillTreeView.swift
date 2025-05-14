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
            PullTreeView()
                .tag(0)

            PushTreeView()
                .tag(1)

            CoreTreeView()
                .tag(2)

            LegsTreeView()
                .tag(3)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
