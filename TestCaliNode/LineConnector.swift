//
//  LineConnector.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/10/25.
//

import SwiftUI

struct LineConnector: View {
    let from: CGPoint
    let to: CGPoint

    var body: some View {
        Canvas { context, size in
            var path = SwiftUI.Path()
            path.move(to: from)
            path.addLine(to: to)
            context.stroke(path, with: .color(.white), lineWidth: 3)
        }
    }
}
