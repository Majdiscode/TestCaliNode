//
//  SkillImageSupport.swift
//  TestCaliNode
//
//  ADD THIS AS A NEW FILE to your project
//  This provides the image mapping system without conflicts
//

import SwiftUI

// MARK: - Skill Image Mapping System
struct SkillImageMap {
    static let images: [String: String] = [
        // Pull Tree Images
        "deadHang": "Deadhang",
        "pullUp": "PullUp",
        
        // Push Tree Images
        "kneePushup": "KneePush",
        "inclinePushup": "InclinePush",
        "pushup": "Pushup"
        
        // TODO: Add more as you create PNG files:
        // "scapularPulls": "ScapularPulls",
        // "negativePullUp": "NegativePullUp",
        // "bandAssistedPullUp": "BandAssisted",
        // "plank": "Plank",
        // "hollowHold": "HollowHold",
        // etc.
    ]
    
    /// Check if a skill has a PNG image available
    static func hasImage(for skillID: String) -> Bool {
        guard let imageName = images[skillID] else { return false }
        return UIImage(named: imageName) != nil
    }
    
    /// Get the image name for a skill ID
    static func imageName(for skillID: String) -> String? {
        return images[skillID]
    }
    
    /// Get all skills that have images
    static var skillsWithImages: [String] {
        return Array(images.keys)
    }
}

// MARK: - Enhanced Skill Circle with Image Support
struct EnhancedSkillCircle: View {
    let skillID: String
    let fallbackEmoji: String
    let unlocked: Bool
    let branchColor: Color?
    let size: CGFloat
    
    init(skillID: String, fallbackEmoji: String, unlocked: Bool, branchColor: Color? = nil, size: CGFloat = 70) {
        self.skillID = skillID
        self.fallbackEmoji = fallbackEmoji
        self.unlocked = unlocked
        self.branchColor = branchColor
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(unlocked ? (branchColor ?? Color(hex: "#0096FF")) : Color.black.opacity(0.8))
                .frame(width: size, height: size)
            
            // Content - Image or Emoji
            if let imageName = SkillImageMap.imageName(for: skillID),
               UIImage(named: imageName) != nil {
                // ✅ Use PNG image
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.55, height: size * 0.55)
                    .foregroundColor(.white)
                    .opacity(unlocked ? 1.0 : 0.7)
            } else {
                // ✅ Fallback to emoji
                Text(fallbackEmoji)
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.white)
                    .opacity(unlocked ? 1.0 : 0.7)
            }
        }
        .overlay(
            Circle()
                .stroke(branchColor ?? .white, lineWidth: unlocked ? 3 : 1)
                .opacity(0.8)
        )
        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        .scaleEffect(unlocked ? 1.0 : 0.9)
        .animation(.spring(response: 0.4), value: unlocked)
    }
}

// MARK: - Preview for Testing Images
struct SkillImagePreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Skill Images Preview")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Skills with PNG Images")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(SkillImageMap.skillsWithImages, id: \.self) { skillID in
                        VStack(spacing: 8) {
                            EnhancedSkillCircle(
                                skillID: skillID,
                                fallbackEmoji: "🏋️",
                                unlocked: true,
                                branchColor: .blue,
                                size: 80
                            )
                            
                            Text(skillID)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Skills without Images (Emoji Fallback)")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        EnhancedSkillCircle(
                            skillID: "scapularPulls", // No image
                            fallbackEmoji: "⬇️",
                            unlocked: true,
                            branchColor: .orange
                        )
                        Text("scapularPulls")
                            .font(.caption)
                    }
                    
                    VStack(spacing: 8) {
                        EnhancedSkillCircle(
                            skillID: "plank", // No image
                            fallbackEmoji: "🧱",
                            unlocked: false,
                            branchColor: .orange
                        )
                        Text("plank")
                            .font(.caption)
                    }
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    SkillImagePreview()
}
