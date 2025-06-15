//
//  SkillTreeComponents.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/14/25.
//

import SwiftUI

// Enhanced Skill Circle with branch coloring
struct EnhancedSkillCircle: View {
    let label: String
    let unlocked: Bool
    let branchColor: Color?
    
    var body: some View {
        Text(label)
            .font(.system(size: 24))
            .frame(width: 60, height: 60)
            .background(
                unlocked ? (branchColor ?? Color(hex: "#0096FF")) : Color.black
            )
            .foregroundColor(.white)
            .overlay(
                Circle()
                    .stroke(branchColor ?? .white, lineWidth: unlocked ? 4 : 2)
            )
            .clipShape(Circle())
            .shadow(radius: 4)
            .scaleEffect(unlocked ? 1.1 : 1.0)
            .animation(.spring(response: 0.3), value: unlocked)
    }
}

// Enhanced Line Connector with colored lines
struct EnhancedLineConnector: View {
    let from: CGPoint
    let to: CGPoint
    let color: Color
    
    var body: some View {
        Canvas { context, size in
            var path = SwiftUI.Path()
            path.move(to: from)
            path.addLine(to: to)
            context.stroke(path, with: .color(color), lineWidth: 3)
        }
    }
}
