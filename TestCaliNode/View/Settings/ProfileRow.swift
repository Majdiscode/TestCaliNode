//
//  ProfileRow.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 7/7/25.
//

import SwiftUI

struct ProfileRow: View {
    @ObservedObject var skillManager: GlobalSkillManager
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Calisthenics Athlete")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Level \(skillManager.globalLevel) • \(skillManager.unlockedSkills.count) skills unlocked")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ProgressView(value: skillManager.completionPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(y: 1.5)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
