//
//  FeatureToggleRow.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 7/7/25.
//

import SwiftUI

struct FeatureToggleRow: View {
    let flag: FeatureFlag
    let title: String
    let description: String
    @ObservedObject private var featureFlags = FeatureFlagService.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Toggle("", isOn: .init(
                get: { featureFlags.isEnabled(flag) },
                set: { enabled in
                    featureFlags.setFlag(flag, enabled: enabled)
                    print("🚩 \(title) \(enabled ? "enabled" : "disabled")")
                }
            ))
        }
        .padding(.vertical, 4)
    }
}
