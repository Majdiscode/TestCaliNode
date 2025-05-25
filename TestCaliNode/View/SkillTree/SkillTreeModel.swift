//
//  SkillTreeModel.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/22/25.
//

import Foundation
import SwiftUI

struct SkillTreeModel: Identifiable, Codable {
    let id: String                   // e.g., "pull"
    let name: String                 // e.g., "Pull Tree"
    let version: Int
    let skills: [SkillNode]
    let positions: [String: CGPoint]
}
