//
//  ContentView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                // App Icon
                Image(systemName: "swift")
                    .font(.system(size: 80))
                    .foregroundColor(DesignTokens.Colors.primary)

                // App Title
                Text("iOS Boilerplate")
                    .font(DesignTokens.Typography.largeTitle)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text("SwiftUI Template")
                    .font(DesignTokens.Typography.title3)
                    .foregroundColor(DesignTokens.Colors.textSecondary)

                // Version Info Card
                VStack(spacing: DesignTokens.Spacing.sm) {
                    HStack {
                        Text("Version:")
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(DesignTokens.Colors.textPrimary)
                        Spacer()
                        Text(appVersion)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }

                    HStack {
                        Text("Build:")
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(DesignTokens.Colors.textPrimary)
                        Spacer()
                        Text(buildNumber)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }
                .padding(DesignTokens.Spacing.cardPadding)
                .background(DesignTokens.Colors.surface)
                .cornerRadius(DesignTokens.CornerRadius.card)
                .shadow(DesignTokens.Shadow.small)

                // Navigation Buttons
                VStack(spacing: DesignTokens.Spacing.md) {
                    NavigationLink(destination: DesignTokensDemo()) {
                        HStack {
                            Image(systemName: "paintpalette")
                            Text("Design Tokens Demo")
                                .font(DesignTokens.Typography.buttonTitle)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.buttonPadding)
                        .background(DesignTokens.Colors.primary)
                        .foregroundColor(DesignTokens.Colors.onPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.button)
                    }

                    Button {
                        withAnimation(DesignTokens.Animation.medium) {
                            themeManager.toggleTheme()
                        }
                    } label: {
                        HStack {
                            Image(systemName: themeManager.currentMode.systemImage)
                            Text("Toggle Theme (\(themeManager.currentMode.displayName))")
                                .font(DesignTokens.Typography.buttonTitle)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.buttonPadding)
                        .background(DesignTokens.Colors.surface)
                        .foregroundColor(DesignTokens.Colors.textPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button)
                                .stroke(DesignTokens.Colors.border, lineWidth: 1)
                        )
                    }
                }

                Spacer()

                Text("Ready for rapid consumer app development")
                    .font(DesignTokens.Typography.footnote)
                    .foregroundColor(DesignTokens.Colors.textTertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(DesignTokens.Spacing.screenPadding)
            .background(DesignTokens.Colors.background)
            .navigationTitle("Home")
        }
        .themedColorScheme()
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

#Preview {
    ContentView()
}
