//
//  SkillTreeCircle.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//

import SwiftUI

struct SkillCircle: View {
    let label: String
    let unlocked: Bool

    var body: some View {
        Text(label)
            .font(.system(size: 24))
            .frame(width: 60, height: 60)
            .background(
                unlocked ? Color(hex: "#0096FF") : Color.black
            )
            .foregroundColor(.white)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 8)
            )
            .clipShape(Circle())
            .shadow(radius: 4)
    }
}
