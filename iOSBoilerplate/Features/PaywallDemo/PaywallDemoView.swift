//
//  PaywallDemoView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct PaywallDemoView: View {
    @EnvironmentObject private var superwallManager: SuperwallManager
    @EnvironmentObject private var revenueCat: RevenueCatManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager

    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // MARK: - Header
                    headerSection

                    // MARK: - Premium Features Demo
                    premiumFeaturesSection

                    // MARK: - Paywall Triggers
                    paywallTriggersSection

                    // MARK: - Analytics Demo
                    analyticsSection

                    Spacer(minLength: DesignTokens.Spacing.xl)
                }
                .padding(DesignTokens.Spacing.screenPadding)
            }
            .background(DesignTokens.Colors.background)
            .navigationTitle("Paywall Demo")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: $showError) {
                Button("OK") {
                    showError = false
                }
            } message: {
                Text(errorMessage)
            }
            .onChange(of: superwallManager.lastError) { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        MBCard(style: .elevated) {
            VStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 40))
                    .foregroundColor(DesignTokens.Colors.primary)

                Text("Superwall Paywall Demo")
                    .font(DesignTokens.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text("Test different paywall triggers and premium features")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Premium Features Section
    private var premiumFeaturesSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("Premium Features")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(DesignTokens.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: DesignTokens.Spacing.sm) {
                // Premium Analytics
                premiumFeatureRow(
                    title: "Advanced Analytics",
                    description: "Detailed insights and metrics",
                    icon: "chart.bar.fill",
                    isLocked: !revenueCat.isPro
                ) {
                    if revenueCat.isPro {
                        // Show analytics
                        showAnalyticsDemo()
                    } else {
                        // Trigger paywall
                        superwallManager.presentFeaturePaywall(feature: .featureLockedAnalytics)
                    }
                }

                // Premium Notifications
                premiumFeatureRow(
                    title: "Smart Notifications",
                    description: "AI-powered notification scheduling",
                    icon: "bell.badge.fill",
                    isLocked: !revenueCat.isPro
                ) {
                    if revenueCat.isPro {
                        // Show notifications
                        showNotificationsDemo()
                    } else {
                        // Trigger paywall
                        superwallManager.presentFeaturePaywall(feature: .featureLockedNotifications)
                    }
                }

                // Premium Themes
                premiumFeatureRow(
                    title: "Custom Themes",
                    description: "Unlimited theme customization",
                    icon: "paintbrush.fill",
                    isLocked: !revenueCat.isPro
                ) {
                    if revenueCat.isPro {
                        // Show themes
                        showThemesDemo()
                    } else {
                        // Trigger paywall
                        superwallManager.presentFeaturePaywall(feature: .featureLockedThemes)
                    }
                }
            }
        }
    }

    // MARK: - Paywall Triggers Section
    private var paywallTriggersSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("Paywall Triggers")
                .font(DesignTokens.Typography.headline)
                .foregroundColor(DesignTokens.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: DesignTokens.Spacing.sm) {
                // Onboarding Complete Trigger
                MBButton(
                    title: "Simulate Onboarding Complete",
                    style: .primary,
                    size: .large
                ) {
                    superwallManager.presentOnboardingPaywall()
                }

                // Feature Locked Trigger
                MBButton(
                    title: "Trigger Feature Locked Paywall",
                    style: .secondary,
                    size: .large
                ) {
                    superwallManager.presentFeaturePaywall(feature: .featureLockedPremium)
                }

                // Custom Event Trigger
                MBButton(
                    title: "Custom Paywall Event",
                    style: .tertiary,
                    size: .large
                ) {
                    superwallManager.presentPaywall(event: .customDemo)
                }
            }
        }
    }

    // MARK: - Analytics Section
    private var analyticsSection: some View {
        MBCard(style: .outlined) {
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("Analytics Events")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Check Xcode console for Superwall analytics events")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    HStack(spacing: DesignTokens.Spacing.md) {
                        VStack {
                            Text("Paywall Presented")
                                .font(DesignTokens.Typography.caption)
                                .foregroundColor(DesignTokens.Colors.textSecondary)
                            Text(superwallManager.isPaywallPresented ? "Yes" : "No")
                                .font(DesignTokens.Typography.callout)
                                .fontWeight(.medium)
                                .foregroundColor(superwallManager.isPaywallPresented
                                    ? DesignTokens.Colors.success
                                    : DesignTokens.Colors.textSecondary
                                )
                        }

                        Spacer()

                        VStack {
                            Text("Superwall Configured")
                                .font(DesignTokens.Typography.caption)
                                .foregroundColor(DesignTokens.Colors.textSecondary)
                            Text(superwallManager.isConfigured ? "Yes" : "No")
                                .font(DesignTokens.Typography.callout)
                                .fontWeight(.medium)
                                .foregroundColor(superwallManager.isConfigured
                                    ? DesignTokens.Colors.success
                                    : DesignTokens.Colors.warning
                                )
                        }
                    }

                    // Error Display
                    if let error = superwallManager.lastError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(DesignTokens.Colors.error)
                            Text(error.localizedDescription)
                                .font(DesignTokens.Typography.caption)
                                .foregroundColor(DesignTokens.Colors.error)
                            Spacer()
                        }
                        .padding(.top, DesignTokens.Spacing.xs)
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func premiumFeatureRow(
        title: String,
        description: String,
        icon: String,
        isLocked: Bool,
        action: @escaping () -> Void
    )
    -> some View {
        MBListRow(
            title: title,
            subtitle: description,
            style: .plain,
            action: action,
            leading: {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isLocked ? DesignTokens.Colors.textTertiary : DesignTokens.Colors.primary)
            },
            trailing: {
                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(DesignTokens.Colors.textTertiary)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(DesignTokens.Colors.success)
                }
            }
        )
    }

    private func showAnalyticsDemo() {
        // TODO: Implement analytics demo
        print("Showing analytics demo for premium users")
    }

    private func showNotificationsDemo() {
        // TODO: Implement notifications demo
        print("Showing notifications demo for premium users")
    }

    private func showThemesDemo() {
        // TODO: Implement themes demo
        print("Showing themes demo for premium users")
    }
}

// MARK: - Preview
#Preview {
    PaywallDemoView()
        .withThemeManager()
        .withLocalizationManager()
        .withSuperwallManager()
        .withRevenueCatManager()
}
