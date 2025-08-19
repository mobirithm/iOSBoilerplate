//
//  DesignTokensDemo.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - DesignTokensDemo

struct DesignTokensDemo: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // MARK: - Theme Controls
                    themeControlsSection

                    // MARK: - Colors
                    colorsSection

                    // MARK: - Typography
                    typographySection

                    // MARK: - Spacing & Layout
                    spacingSection

                    // MARK: - Components Preview
                    componentsSection
                }
                .padding(DesignTokens.Spacing.screenPadding)
            }
            .background(DesignTokens.Colors.background)
            .navigationTitle("Design Tokens")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Theme Controls
    private var themeControlsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Theme Controls")
                .font(DesignTokens.Typography.sectionHeader)
                .foregroundColor(DesignTokens.Colors.textPrimary)

            HStack(spacing: DesignTokens.Spacing.md) {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Button {
                        withAnimation(DesignTokens.Animation.medium) {
                            themeManager.setTheme(mode)
                        }
                    } label: {
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            Image(systemName: mode.systemImage)
                                .font(.title2)
                            Text(mode.displayName)
                                .font(DesignTokens.Typography.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.md)
                        .background(
                            themeManager.currentMode == mode
                                ? DesignTokens.Colors.primary
                                : DesignTokens.Colors.surface
                        )
                        .foregroundColor(
                            themeManager.currentMode == mode
                                ? DesignTokens.Colors.onPrimary
                                : DesignTokens.Colors.textPrimary
                        )
                        .cornerRadius(DesignTokens.CornerRadius.button)
                    }
                }
            }
        }
        .padding(DesignTokens.Spacing.cardPadding)
        .background(DesignTokens.Colors.surface)
        .cornerRadius(DesignTokens.CornerRadius.card)
    }

    // MARK: - Colors Section
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Colors")
                .font(DesignTokens.Typography.sectionHeader)
                .foregroundColor(DesignTokens.Colors.textPrimary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: DesignTokens.Spacing.sm) {
                ColorToken("Primary", color: DesignTokens.Colors.primary)
                ColorToken("Secondary", color: DesignTokens.Colors.secondary)
                ColorToken("Success", color: DesignTokens.Colors.success)
                ColorToken("Warning", color: DesignTokens.Colors.warning)
                ColorToken("Error", color: DesignTokens.Colors.error)
                ColorToken("Info", color: DesignTokens.Colors.info)
            }
        }
        .padding(DesignTokens.Spacing.cardPadding)
        .background(DesignTokens.Colors.surface)
        .cornerRadius(DesignTokens.CornerRadius.card)
    }

    // MARK: - Typography Section
    private var typographySection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Typography")
                .font(DesignTokens.Typography.sectionHeader)
                .foregroundColor(DesignTokens.Colors.textPrimary)

            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                TypographyToken("Large Title", font: DesignTokens.Typography.largeTitle)
                TypographyToken("Title 1", font: DesignTokens.Typography.title1)
                TypographyToken("Title 2", font: DesignTokens.Typography.title2)
                TypographyToken("Title 3", font: DesignTokens.Typography.title3)
                TypographyToken("Headline", font: DesignTokens.Typography.headline)
                TypographyToken("Body", font: DesignTokens.Typography.body)
                TypographyToken("Callout", font: DesignTokens.Typography.callout)
                TypographyToken("Subheadline", font: DesignTokens.Typography.subheadline)
                TypographyToken("Footnote", font: DesignTokens.Typography.footnote)
                TypographyToken("Caption", font: DesignTokens.Typography.caption)
            }
        }
        .padding(DesignTokens.Spacing.cardPadding)
        .background(DesignTokens.Colors.surface)
        .cornerRadius(DesignTokens.CornerRadius.card)
    }

    // MARK: - Spacing Section
    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Spacing")
                .font(DesignTokens.Typography.sectionHeader)
                .foregroundColor(DesignTokens.Colors.textPrimary)

            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                SpacingToken("XS", spacing: DesignTokens.Spacing.xs)
                SpacingToken("SM", spacing: DesignTokens.Spacing.sm)
                SpacingToken("MD", spacing: DesignTokens.Spacing.md)
                SpacingToken("LG", spacing: DesignTokens.Spacing.lg)
                SpacingToken("XL", spacing: DesignTokens.Spacing.xl)
                SpacingToken("XXL", spacing: DesignTokens.Spacing.xxl)
            }
        }
        .padding(DesignTokens.Spacing.cardPadding)
        .background(DesignTokens.Colors.surface)
        .cornerRadius(DesignTokens.CornerRadius.card)
    }

    // MARK: - Components Section
    private var componentsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Component Examples")
                .font(DesignTokens.Typography.sectionHeader)
                .foregroundColor(DesignTokens.Colors.textPrimary)

            VStack(spacing: DesignTokens.Spacing.md) {
                // Primary Button Example
                Button {
                    // Action
                } label: {
                    Text("Primary Button")
                }
                .font(DesignTokens.Typography.buttonTitle)
                .foregroundColor(DesignTokens.Colors.onPrimary)
                .frame(maxWidth: .infinity)
                .padding(DesignTokens.Spacing.buttonPadding)
                .background(DesignTokens.Colors.primary)
                .cornerRadius(DesignTokens.CornerRadius.button)

                // Card Example
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text("Sample Card")
                        .font(DesignTokens.Typography.headline)
                        .foregroundColor(DesignTokens.Colors.textPrimary)

                    Text(
                        """
                        This is an example of a card component using design tokens for consistent spacing, \
                        typography, and colors.
                        """
                    )
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
                }
                .padding(DesignTokens.Spacing.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DesignTokens.Colors.surface)
                .cornerRadius(DesignTokens.CornerRadius.card)
                .shadow(DesignTokens.Shadow.small)
            }
        }
        .padding(DesignTokens.Spacing.cardPadding)
        .background(DesignTokens.Colors.surface)
        .cornerRadius(DesignTokens.CornerRadius.card)
    }
}

// MARK: - ColorToken

struct ColorToken: View {
    let name: String
    let color: Color

    init(_ name: String, color: Color) {
        self.name = name
        self.color = color
    }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                .fill(color)
                .frame(height: 40)

            Text(name)
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.textSecondary)
        }
    }
}

// MARK: - TypographyToken

struct TypographyToken: View {
    let name: String
    let font: Font

    init(_ name: String, font: Font) {
        self.name = name
        self.font = font
    }

    var body: some View {
        HStack {
            Text(name)
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.textSecondary)
                .frame(width: 80, alignment: .leading)

            Text("Sample Text")
                .font(font)
                .foregroundColor(DesignTokens.Colors.textPrimary)

            Spacer()
        }
    }
}

// MARK: - SpacingToken

struct SpacingToken: View {
    let name: String
    let spacing: CGFloat

    init(_ name: String, spacing: CGFloat) {
        self.name = name
        self.spacing = spacing
    }

    var body: some View {
        HStack {
            Text(name)
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.textSecondary)
                .frame(width: 40, alignment: .leading)

            Rectangle()
                .fill(DesignTokens.Colors.primary)
                .frame(width: spacing, height: 20)

            Text("\(Int(spacing))pt")
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.textSecondary)

            Spacer()
        }
    }
}

#Preview {
    DesignTokensDemo()
        .withThemeManager()
}
