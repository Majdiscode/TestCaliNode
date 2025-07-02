//
//  SkillTreeHeaderSection.swift
//  TestCaliNode
//
//  SIMPLIFIED - No longer needed since we moved everything to container
//  You can DELETE this file since the header is now in SkillTreeContainer
//

import SwiftUI

// This component is no longer used - all header functionality
// has been moved directly into SkillTreeContainer for proper binding sync

struct SkillTreeHeaderSection: View {
    @Binding var selectedTreeIndex: Int
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        Text("This component is deprecated - delete this file")
    }
}
