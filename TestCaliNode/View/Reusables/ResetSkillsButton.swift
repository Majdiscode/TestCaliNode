//
//  ResetSkillsButton.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/14/25.
//

import SwiftUI

struct ResetSkillsButton: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Button("Reset All Skills") {
                action()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.bottom, 80)
        }
    }
}
