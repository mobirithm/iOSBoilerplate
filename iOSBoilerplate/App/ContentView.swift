//
//  ContentView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var showLocalePicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                // App Icon
                Image(systemName: "swift")
                    .font(.system(size: 80))
                    .foregroundColor(DesignTokens.Colors.primary)

                // App Title
                Text("app.title".localized)
                    .font(DesignTokens.Typography.largeTitle)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text("app.subtitle".localized)
                    .font(DesignTokens.Typography.title3)
                    .foregroundColor(DesignTokens.Colors.textSecondary)

                // Version Info Card
                VStack(spacing: DesignTokens.Spacing.sm) {
                    HStack {
                        Text("settings.version".localized)
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(DesignTokens.Colors.textPrimary)
                        Spacer()
                        Text(appVersion)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }

                    HStack {
                        Text("settings.build".localized)
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
                    NavigationLink(destination: ComponentGallery()) {
                        HStack {
                            Image(systemName: "square.grid.3x3")
                            Text("gallery.title".localized)
                                .font(DesignTokens.Typography.buttonTitle)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.buttonPadding)
                        .background(DesignTokens.Colors.primary)
                        .foregroundColor(DesignTokens.Colors.onPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.button)
                    }

                    NavigationLink(destination: DesignTokensDemo()) {
                        HStack {
                            Image(systemName: "paintpalette")
                            Text("designTokens.title".localized)
                                .font(DesignTokens.Typography.buttonTitle)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.buttonPadding)
                        .background(DesignTokens.Colors.secondary)
                        .foregroundColor(DesignTokens.Colors.onSecondary)
                        .cornerRadius(DesignTokens.CornerRadius.button)
                    }

                    NavigationLink(destination: RTLTestView()) {
                        HStack {
                            Image(systemName: "globe")
                            Text("rtl.title".localized)
                                .font(DesignTokens.Typography.buttonTitle)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.buttonPadding)
                        .background(DesignTokens.Colors.info)
                        .foregroundColor(DesignTokens.Colors.onPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.button)
                    }

                    NavigationLink(destination: PaywallDemoView()) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                            Text("Paywall Demo")
                                .font(DesignTokens.Typography.buttonTitle)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.buttonPadding)
                        .background(DesignTokens.Colors.warning)
                        .foregroundColor(DesignTokens.Colors.onPrimary)
                        .cornerRadius(DesignTokens.CornerRadius.button)
                    }

                    HStack(spacing: DesignTokens.Spacing.md) {
                        Button {
                            withAnimation(DesignTokens.Animation.medium) {
                                themeManager.toggleTheme()
                            }
                        } label: {
                            HStack {
                                Image(systemName: themeManager.currentMode.systemImage)
                                Text("theme.toggle".localized)
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

                        Button {
                            showLocalePicker = true
                        } label: {
                            HStack {
                                Text(localizationManager.currentLocale.flag)
                                Text("settings.language".localized)
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
                }

                Spacer()

                Text("app.description".localized)
                    .font(DesignTokens.Typography.footnote)
                    .foregroundColor(DesignTokens.Colors.textTertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(DesignTokens.Spacing.screenPadding)
            .background(DesignTokens.Colors.background)
            .navigationTitle("nav.home".localized)
        }
        .themedColorScheme()
        .rtlAware()
        .sheet(isPresented: $showLocalePicker) {
            LocalePicker()
        }
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
