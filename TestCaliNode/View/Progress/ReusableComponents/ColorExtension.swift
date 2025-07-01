//
//  ColorExtensions.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ReusableComponents/ColorExtensions.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ReusableComponents/
//

import SwiftUI

// MARK: - App Color Palette
extension Color {
    
    // MARK: - Skill Tree Specific Colors
    static func colorForTree(_ treeID: String) -> Color {
        switch treeID {
        case "pull": return Color.blue
        case "push": return Color.red
        case "core": return Color.orange
        case "legs": return Color.green
        default: return Color.gray
        }
    }
    
    // MARK: - Branch Specific Colors
    static func colorForBranch(_ branchID: String) -> Color {
        switch branchID {
        // Pull tree branches
        case "explosive": return Color(hexString: "#FF6B35")
        case "isometric": return Color(hexString: "#4ECDC4")
        case "unilateral": return Color(hexString: "#A8E6CF")
        
        // Push tree branches
        case "strength": return Color(hexString: "#E74C3C")
        case "endurance": return Color(hexString: "#3498DB")
        case "skill": return Color(hexString: "#9B59B6")
        
        // Core tree branches
        case "static": return Color(hexString: "#F39C12")
        case "dynamic": return Color(hexString: "#16A085")
        case "rotational": return Color(hexString: "#8E44AD")
        
        // Legs tree branches
        case "bilateral": return Color(hexString: "#E67E22")
        case "plyometric": return Color(hexString: "#2980B9")
        
        default: return Color.gray
        }
    }
    
    // MARK: - Difficulty Colors
    static func difficultyColor(for level: Int) -> Color {
        switch level {
        case 1: return Color.green
        case 2: return Color.yellow
        case 3: return Color.orange
        case 4: return Color.red
        case 5...: return Color.purple
        default: return Color.gray
        }
    }
    
    // MARK: - Progress Colors
    static func progressColor(for percentage: Double) -> Color {
        switch percentage {
        case 0..<0.25: return Color.red
        case 0.25..<0.5: return Color.orange
        case 0.5..<0.75: return Color.blue
        case 0.75..<1.0: return Color.green
        default: return Color.green
        }
    }
    
    // MARK: - Quest Colors
    static func questTypeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "story": return Color.blue
        case "daily": return Color.orange
        case "weekly": return Color.purple
        case "random": return Color.green
        case "achievement": return Color.red
        default: return Color.gray
        }
    }
    
    // MARK: - Rarity Colors
    static func rarityColor(for rarity: String) -> Color {
        switch rarity.lowercased() {
        case "common": return Color.gray
        case "rare": return Color.blue
        case "epic": return Color.purple
        case "legendary": return Color.orange
        case "mythic": return Color.red
        default: return Color.gray
        }
    }
}

// MARK: - Hex Color Initializer
extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
    
    // Convert Color to hex string
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}

// MARK: - Color Modifiers
extension Color {
    
    // Lighten a color by a percentage
    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    // Darken a color by a percentage
    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjustBrightness(by: -1 * abs(percentage))
    }
    
    // Adjust brightness
    func adjustBrightness(by percentage: CGFloat) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            brightness += (percentage / 100.0)
            brightness = max(min(brightness, 1.0), 0.0)
            return Color(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha))
        }
        return self
    }
    
    // Create a gradient version of the color
    func gradient(to endColor: Color = Color.clear, startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> LinearGradient {
        return LinearGradient(
            colors: [self, endColor],
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    // Create a radial gradient
    func radialGradient(center: UnitPoint = .center, startRadius: CGFloat = 0, endRadius: CGFloat = 100) -> RadialGradient {
        return RadialGradient(
            colors: [self, self.opacity(0)],
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }
}

// MARK: - Semantic Color Groups
extension Color {
    
    // Achievement colors
    struct Achievement {
        static let common = Color.gray
        static let rare = Color.blue
        static let epic = Color.purple
        static let legendary = Color.orange
        static let mythic = Color.red
    }
    
    // Skill level colors
    struct SkillLevel {
        static let beginner = Color.green
        static let intermediate = Color.yellow
        static let advanced = Color.orange
        static let expert = Color.red
        static let master = Color.purple
    }
    
    // Tree completion colors
    struct TreeCompletion {
        static let empty = Color.gray.opacity(0.3)
        static let started = Color.blue.opacity(0.6)
        static let halfComplete = Color.yellow
        static let nearComplete = Color.orange
        static let complete = Color.green
    }
    
    // Workout intensity colors
    struct WorkoutIntensity {
        static let light = Color.green
        static let moderate = Color.yellow
        static let intense = Color.orange
        static let extreme = Color.red
    }
}

// MARK: - Dynamic Color Support
extension Color {
    
    // Create a color that adapts to light/dark mode
    static func adaptive(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
    
    // Common adaptive colors
    static let adaptiveText = Color.adaptive(light: .black, dark: .white)
    static let adaptiveBackground = Color.adaptive(light: .white, dark: .black)
    static let adaptiveCard = Color.adaptive(
        light: Color(UIColor.secondarySystemBackground),
        dark: Color(UIColor.secondarySystemBackground)
    )
}

// MARK: - Color Accessibility
extension Color {
    
    // Check if color has sufficient contrast for text
    func hasAccessibleContrast(with backgroundColor: Color) -> Bool {
        let textColor = UIColor(self)
        let bgColor = UIColor(backgroundColor)
        
        let textLuminance = textColor.luminance
        let bgLuminance = bgColor.luminance
        
        let contrastRatio = (max(textLuminance, bgLuminance) + 0.05) / (min(textLuminance, bgLuminance) + 0.05)
        
        return contrastRatio >= 4.5 // WCAG AA standard
    }
    
    // Get appropriate text color for this background
    func contrastingTextColor() -> Color {
        let uiColor = UIColor(self)
        return uiColor.luminance > 0.5 ? .black : .white
    }
}

// MARK: - UIColor Extension for Luminance
extension UIColor {
    var luminance: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Apply gamma correction
        let r = red <= 0.03928 ? red / 12.92 : pow((red + 0.055) / 1.055, 2.4)
        let g = green <= 0.03928 ? green / 12.92 : pow((green + 0.055) / 1.055, 2.4)
        let b = blue <= 0.03928 ? blue / 12.92 : pow((blue + 0.055) / 1.055, 2.4)
        
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
}
