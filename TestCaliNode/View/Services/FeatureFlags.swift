//
//  FeatureFlagService.swift
//  TestCaliNode
//
//  CREATE this file in: TestCaliNode/Services/FeatureFlagService.swift
//

import Foundation
import SwiftUI

// MARK: - Feature Flags Enum
enum FeatureFlag: String, CaseIterable {
    case enhancedAnimations = "enhanced_animations"
    case betterProgress = "better_progress"
    case achievementBadges = "achievement_badges"
    case questNotifications = "quest_notifications"
    case advancedWorkouts = "advanced_workouts"
    case socialFeatures = "social_features"
    case premiumFeatures = "premium_features"
    
    var defaultValue: Bool {
        switch self {
        case .enhancedAnimations: return true
        case .betterProgress: return true
        case .achievementBadges: return true
        case .questNotifications: return false
        case .advancedWorkouts: return false
        case .socialFeatures: return false
        case .premiumFeatures: return false
        }
    }
    
    var displayName: String {
        switch self {
        case .enhancedAnimations: return "Enhanced Animations"
        case .betterProgress: return "Better Progress Tracking"
        case .achievementBadges: return "Achievement Badges"
        case .questNotifications: return "Quest Notifications"
        case .advancedWorkouts: return "Advanced Workouts"
        case .socialFeatures: return "Social Features"
        case .premiumFeatures: return "Premium Features"
        }
    }
    
    var description: String {
        switch self {
        case .enhancedAnimations: return "Smooth animations throughout the app"
        case .betterProgress: return "Enhanced progress tracking and analytics"
        case .achievementBadges: return "Unlock and display achievement badges"
        case .questNotifications: return "Get notified about quest progress"
        case .advancedWorkouts: return "Advanced workout templates and tracking"
        case .socialFeatures: return "Share progress with friends"
        case .premiumFeatures: return "Access premium content and features"
        }
    }
}

// MARK: - Feature Flag Service
class FeatureFlagService: ObservableObject {
    static let shared = FeatureFlagService()
    
    @Published private var flags: [String: Bool] = [:]
    
    private init() {
        loadFlags()
    }
    
    // MARK: - Public Methods
    func isEnabled(_ flag: FeatureFlag) -> Bool {
        return flags[flag.rawValue] ?? flag.defaultValue
    }
    
    func setFlag(_ flag: FeatureFlag, enabled: Bool) {
        flags[flag.rawValue] = enabled
        saveFlags()
        objectWillChange.send()
    }
    
    func resetToDefaults() {
        flags.removeAll()
        for flag in FeatureFlag.allCases {
            flags[flag.rawValue] = flag.defaultValue
        }
        saveFlags()
        objectWillChange.send()
    }
    
    // MARK: - Persistence
    private func loadFlags() {
        if let data = UserDefaults.standard.data(forKey: "FeatureFlags"),
           let decoded = try? JSONDecoder().decode([String: Bool].self, from: data) {
            flags = decoded
        } else {
            // Initialize with defaults
            resetToDefaults()
        }
    }
    
    private func saveFlags() {
        if let encoded = try? JSONEncoder().encode(flags) {
            UserDefaults.standard.set(encoded, forKey: "FeatureFlags")
        }
    }
}

// MARK: - Feature Flag Debug Panel
struct FeatureFlagDebugPanel: View {
    @ObservedObject private var featureFlags = FeatureFlagService.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Feature Flags")) {
                    ForEach(FeatureFlag.allCases, id: \.rawValue) { flag in
                        DebugFeatureRow(flag: flag)
                    }
                }
                
                Section(header: Text("Actions")) {
                    Button("Reset to Defaults") {
                        featureFlags.resetToDefaults()
                    }
                    .foregroundColor(.orange)
                    
                    Button("Enable All") {
                        for flag in FeatureFlag.allCases {
                            featureFlags.setFlag(flag, enabled: true)
                        }
                    }
                    .foregroundColor(.green)
                    
                    Button("Disable All") {
                        for flag in FeatureFlag.allCases {
                            featureFlags.setFlag(flag, enabled: false)
                        }
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Feature Flags")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct DebugFeatureRow: View {
    let flag: FeatureFlag
    @ObservedObject private var featureFlags = FeatureFlagService.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(flag.displayName)
                    .font(.headline)
                
                Text(flag.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Default: \(flag.defaultValue ? "ON" : "OFF")")
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            Toggle("", isOn: .init(
                get: { featureFlags.isEnabled(flag) },
                set: { enabled in
                    featureFlags.setFlag(flag, enabled: enabled)
                }
            ))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Feature Flag Extensions for Easy Access
extension FeatureFlagService {
    var enhancedAnimations: Bool { isEnabled(.enhancedAnimations) }
    var betterProgress: Bool { isEnabled(.betterProgress) }
    var achievementBadges: Bool { isEnabled(.achievementBadges) }
    var questNotifications: Bool { isEnabled(.questNotifications) }
    var advancedWorkouts: Bool { isEnabled(.advancedWorkouts) }
    var socialFeatures: Bool { isEnabled(.socialFeatures) }
    var premiumFeatures: Bool { isEnabled(.premiumFeatures) }
}

// MARK: - SwiftUI Environment Extension
extension EnvironmentValues {
    var featureFlags: FeatureFlagService {
        get { FeatureFlagService.shared }
    }
}
