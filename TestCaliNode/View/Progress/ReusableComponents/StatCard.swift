//
//  StatCard.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  StatCard.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 6/27/25.
//

//
//  ReusableComponents/StatCard.swift
//  TestCaliNode
//
//  CREATE this as a new file in: View/Progress/ReusableComponents/
//

import SwiftUI

// MARK: - Basic Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String?
    let subtitle: String?
    
    init(title: String, value: String, color: Color, icon: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon (if provided)
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            // Main value
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            // Title and subtitle
            VStack(spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Enhanced Stat Card with Progress
struct ProgressStatCard: View {
    let title: String
    let value: String
    let maxValue: String?
    let color: Color
    let icon: String
    let progress: Double?
    let subtitle: String?
    
    init(title: String, value: String, maxValue: String? = nil, color: Color, icon: String, progress: Double? = nil, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.maxValue = maxValue
        self.color = color
        self.icon = icon
        self.progress = progress
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            // Value display
            VStack(spacing: 4) {
                if let maxValue = maxValue {
                    Text("\(value)/\(maxValue)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                } else {
                    Text(value)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                }
                
                // Progress bar (if provided)
                if let progress = progress {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: color))
                        .scaleEffect(y: 1.5)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            
            // Title and subtitle
            VStack(spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Compact Stat Card
struct CompactStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String?
    
    init(title: String, value: String, color: Color, icon: String? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Animated Stat Card
struct AnimatedStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    let animationDelay: Double
    
    @State private var isVisible = false
    
    init(title: String, value: String, color: Color, icon: String, animationDelay: Double = 0) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.animationDelay = animationDelay
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(animationDelay), value: isVisible)
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .opacity(isVisible ? 1.0 : 0.0)
                .offset(y: isVisible ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(animationDelay + 0.2), value: isVisible)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5).delay(animationDelay + 0.4), value: isVisible)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .scaleEffect(isVisible ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(animationDelay), value: isVisible)
        )
        .onAppear {
            isVisible = true
        }
    }
}

// MARK: - Tappable Stat Card
struct TappableStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    let subtitle: String?
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(title: String, value: String, color: Color, icon: String, subtitle: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Tap indicator
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(isPressed ? 0.5 : 0.2), lineWidth: isPressed ? 2 : 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Stat Card with Trend
struct TrendStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    let trend: StatTrend
    let trendValue: String?
    
    init(title: String, value: String, color: Color, icon: String, trend: StatTrend, trendValue: String? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.trend = trend
        self.trendValue = trendValue
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
                
                // Trend indicator
                HStack(spacing: 4) {
                    Image(systemName: trend.icon)
                        .font(.caption)
                        .foregroundColor(trend.color)
                    
                    if let trendValue = trendValue {
                        Text(trendValue)
                            .font(.caption)
                            .foregroundColor(trend.color)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(trend.color.opacity(0.1))
                )
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Stat Trend Enum
enum StatTrend {
    case up
    case down
    case stable
    
    var icon: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .stable: return .gray
        }
    }
}
