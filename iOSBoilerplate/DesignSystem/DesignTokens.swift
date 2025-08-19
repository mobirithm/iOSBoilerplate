//
//  DesignTokens.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - DesignTokens

/// Centralized design tokens for consistent theming across the app
public enum DesignTokens {
    // MARK: - Colors
    public enum Colors {
        // MARK: - Primary Colors
        public static let primary = Color("Primary")
        public static let primaryVariant = Color("PrimaryVariant")
        public static let secondary = Color("Secondary")
        public static let secondaryVariant = Color("SecondaryVariant")

        // MARK: - Background Colors
        public static let background = Color("Background")
        public static let surface = Color("Surface")
        public static let surfaceVariant = Color("SurfaceVariant")

        // MARK: - Content Colors
        public static let onPrimary = Color("OnPrimary")
        public static let onSecondary = Color("OnSecondary")
        public static let onBackground = Color("OnBackground")
        public static let onSurface = Color("OnSurface")

        // MARK: - Semantic Colors
        public static let success = Color("Success")
        public static let warning = Color("Warning")
        public static let error = Color("Error")
        public static let info = Color("Info")

        // MARK: - Text Colors
        public static let textPrimary = Color("TextPrimary")
        public static let textSecondary = Color("TextSecondary")
        public static let textTertiary = Color("TextTertiary")
        public static let textDisabled = Color("TextDisabled")

        // MARK: - Border Colors
        public static let border = Color("Border")
        public static let borderVariant = Color("BorderVariant")

        // MARK: - System Colors (fallbacks)
        public static let systemBackground = Color(.systemBackground)
        public static let systemGroupedBackground = Color(.systemGroupedBackground)
        public static let label = Color(.label)
        public static let secondaryLabel = Color(.secondaryLabel)
        public static let tertiaryLabel = Color(.tertiaryLabel)
    }

    // MARK: - Typography
    public enum Typography {
        // MARK: - Font Weights
        public enum Weight {
            public static let light = Font.Weight.light
            public static let regular = Font.Weight.regular
            public static let medium = Font.Weight.medium
            public static let semibold = Font.Weight.semibold
            public static let bold = Font.Weight.bold
        }

        // MARK: - Font Sizes
        public enum Size {
            public static let caption: CGFloat = 12
            public static let footnote: CGFloat = 13
            public static let subheadline: CGFloat = 15
            public static let callout: CGFloat = 16
            public static let body: CGFloat = 17
            public static let headline: CGFloat = 17
            public static let title3: CGFloat = 20
            public static let title2: CGFloat = 22
            public static let title1: CGFloat = 28
            public static let largeTitle: CGFloat = 34
        }

        // MARK: - Predefined Styles
        public static let largeTitle = Font.system(size: Size.largeTitle, weight: Weight.bold)
        public static let title1 = Font.system(size: Size.title1, weight: Weight.bold)
        public static let title2 = Font.system(size: Size.title2, weight: Weight.bold)
        public static let title3 = Font.system(size: Size.title3, weight: Weight.semibold)
        public static let headline = Font.system(size: Size.headline, weight: Weight.semibold)
        public static let body = Font.system(size: Size.body, weight: Weight.regular)
        public static let callout = Font.system(size: Size.callout, weight: Weight.regular)
        public static let subheadline = Font.system(size: Size.subheadline, weight: Weight.regular)
        public static let footnote = Font.system(size: Size.footnote, weight: Weight.regular)
        public static let caption = Font.system(size: Size.caption, weight: Weight.regular)

        // MARK: - Custom Styles
        public static let buttonTitle = Font.system(size: Size.callout, weight: Weight.semibold)
        public static let navigationTitle = Font.system(size: Size.title2, weight: Weight.bold)
        public static let sectionHeader = Font.system(size: Size.headline, weight: Weight.semibold)
    }

    // MARK: - Spacing
    public enum Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
        public static let xxl: CGFloat = 48
        public static let xxxl: CGFloat = 64

        // MARK: - Component Specific
        public static let buttonPadding: CGFloat = md
        public static let cardPadding: CGFloat = md
        public static let screenPadding: CGFloat = md
        public static let sectionSpacing: CGFloat = lg
        public static let itemSpacing: CGFloat = sm
    }

    // MARK: - Corner Radius
    public enum CornerRadius {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 24
        public static let circle: CGFloat = 50

        // MARK: - Component Specific
        public static let button: CGFloat = md
        public static let card: CGFloat = md
        public static let sheet: CGFloat = lg
        public static let dialog: CGFloat = lg
    }

    // MARK: - Shadows
    public enum Shadow {
        public struct ShadowStyle {
            public let color: Color
            public let radius: CGFloat
            public let offsetX: CGFloat
            public let offsetY: CGFloat

            public init(color: Color, radius: CGFloat, offsetX: CGFloat, offsetY: CGFloat) {
                self.color = color
                self.radius = radius
                self.offsetX = offsetX
                self.offsetY = offsetY
            }
        }

        public static let small = ShadowStyle(color: Color.black.opacity(0.1), radius: 2, offsetX: 0, offsetY: 1)
        public static let medium = ShadowStyle(color: Color.black.opacity(0.15), radius: 4, offsetX: 0, offsetY: 2)
        public static let large = ShadowStyle(color: Color.black.opacity(0.2), radius: 8, offsetX: 0, offsetY: 4)
    }

    // MARK: - Animation
    public enum Animation {
        public static let fast = SwiftUI.Animation.easeInOut(duration: 0.2)
        public static let medium = SwiftUI.Animation.easeInOut(duration: 0.3)
        public static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)

        // MARK: - Spring Animations
        public static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
        public static let bouncy = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.6)
    }
}

// MARK: - Theme Extensions
extension Color {
    /// Initialize color from design token name
    init(_ tokenName: String) {
        self.init(tokenName, bundle: .main)
    }
}

// MARK: - View Extensions
extension View {
    /// Apply design token shadow
    func shadow(_ shadowStyle: DesignTokens.Shadow.ShadowStyle) -> some View {
        shadow(color: shadowStyle.color, radius: shadowStyle.radius, x: shadowStyle.offsetX, y: shadowStyle.offsetY)
    }
}
