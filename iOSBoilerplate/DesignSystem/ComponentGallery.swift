//
//  ComponentGallery.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct ComponentGallery: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var sampleText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var isLoading = false
    @State private var showError = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // MARK: - Buttons Section
                    buttonsSection

                    // MARK: - Text Fields Section
                    textFieldsSection

                    // MARK: - Cards Section
                    cardsSection

                    // MARK: - List Rows Section
                    listRowsSection

                    // MARK: - Paywall Headers Section
                    paywallHeadersSection
                }
                .padding(DesignTokens.Spacing.screenPadding)
            }
            .background(DesignTokens.Colors.background)
            .navigationTitle("Component Gallery")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(DesignTokens.Animation.medium) {
                            themeManager.toggleTheme()
                        }
                    } label: {
                        Image(systemName: themeManager.currentMode.systemImage)
                            .foregroundColor(DesignTokens.Colors.primary)
                    }
                }
            }
        }
    }

    // MARK: - Buttons Section
    private var buttonsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            sectionHeader("Buttons")

            VStack(spacing: DesignTokens.Spacing.md) {
                MBButton(title: "Primary Button", style: .primary) {
                    print("Primary tapped")
                }

                MBButton(title: "Secondary Button", style: .secondary) {
                    print("Secondary tapped")
                }

                MBButton(title: "Tertiary Button", style: .tertiary) {
                    print("Tertiary tapped")
                }

                HStack(spacing: DesignTokens.Spacing.md) {
                    MBButton(title: "Success", style: .success, size: .small) {
                        print("Success tapped")
                    }

                    MBButton(title: "Warning", style: .warning, size: .small) {
                        print("Warning tapped")
                    }

                    MBButton(title: "Destructive", style: .destructive, size: .small) {
                        print("Destructive tapped")
                    }
                }

                HStack(spacing: DesignTokens.Spacing.md) {
                    MBButton(title: "Loading", style: .primary, size: .medium, isLoading: isLoading) {
                        withAnimation {
                            isLoading.toggle()
                        }
                    }

                    MBButton(title: "Disabled", style: .primary, size: .medium, isDisabled: true) {
                        print("Won't execute")
                    }
                }
            }
        }
    }

    // MARK: - Text Fields Section
    private var textFieldsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            sectionHeader("Text Fields")

            VStack(spacing: DesignTokens.Spacing.md) {
                MBTextField(
                    text: $sampleText,
                    placeholder: "Enter some text",
                    title: "Sample Input",
                    helperText: "This is a helper text"
                )

                MBTextField(
                    text: $emailText,
                    placeholder: "your@email.com",
                    title: "Email Address",
                    errorText: showError ? "Please enter a valid email" : nil,
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress
                )

                MBTextField(
                    text: $passwordText,
                    placeholder: "Enter password",
                    title: "Password",
                    helperText: "Must be at least 8 characters",
                    isSecure: true,
                    textContentType: .password
                )

                MBTextField(
                    text: .constant("Disabled field"),
                    placeholder: "Can't edit this",
                    title: "Disabled Field",
                    isDisabled: true
                )

                MBButton(title: "Toggle Email Error", style: .tertiary, size: .small) {
                    withAnimation {
                        showError.toggle()
                    }
                }
            }
        }
    }

    // MARK: - Cards Section
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            sectionHeader("Cards")

            VStack(spacing: DesignTokens.Spacing.md) {
                MBCard(style: .elevated) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("Elevated Card")
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        Text("This card has a shadow for depth and hierarchy.")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }

                MBCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("Outlined Card")
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        Text("This card uses borders instead of shadows.")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }

                MBCard(style: .filled, action: {
                    print("Interactive card tapped!")
                }) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        HStack {
                            Text("Interactive Card")
                                .font(DesignTokens.Typography.headline)
                                .foregroundColor(DesignTokens.Colors.textPrimary)

                            Spacer()

                            Image(systemName: "arrow.right")
                                .foregroundColor(DesignTokens.Colors.primary)
                        }

                        Text("Tap this card to see interaction feedback.")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - List Rows Section
    private var listRowsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            sectionHeader("List Rows")

            VStack(spacing: DesignTokens.Spacing.sm) {
                MBListRow(
                    title: "Settings",
                    subtitle: "App preferences and configuration",
                    style: .plain,
                    action: { print("Settings tapped") },
                    leading: {
                        Image(systemName: "gear")
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                )

                MBListRow(
                    title: "Premium Feature",
                    subtitle: "Unlock advanced functionality",
                    style: .card,
                    action: { print("Premium tapped") },
                    leading: {
                        Image(systemName: "star.fill")
                            .foregroundColor(DesignTokens.Colors.warning)
                    },
                    trailing: {
                        Text("PRO")
                            .font(DesignTokens.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(DesignTokens.Colors.primary)
                            .padding(.horizontal, DesignTokens.Spacing.sm)
                            .padding(.vertical, DesignTokens.Spacing.xs)
                            .background(DesignTokens.Colors.primary.opacity(0.1))
                            .cornerRadius(DesignTokens.CornerRadius.sm)
                    }
                )

                MBListRow(
                    title: "Notification",
                    subtitle: "You have 3 new messages",
                    style: .inset,
                    leading: {
                        Circle()
                            .fill(DesignTokens.Colors.success)
                            .frame(width: 12, height: 12)
                    },
                    trailing: {
                        Text("3")
                            .font(DesignTokens.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(DesignTokens.Colors.onPrimary)
                            .frame(width: 20, height: 20)
                            .background(DesignTokens.Colors.primary)
                            .clipShape(Circle())
                    }
                )
            }
        }
    }

    // MARK: - Paywall Headers Section
    private var paywallHeadersSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            sectionHeader("Paywall Headers")

            VStack(spacing: DesignTokens.Spacing.lg) {
                MBPaywallHeader(
                    title: "Go Premium",
                    subtitle: "Unlock Everything",
                    description: "Get unlimited access to all features, remove ads, and enjoy premium content.",
                    style: .gradient,
                    imageName: "crown.fill",
                    closeAction: { print("Close premium") }
                )

                MBPaywallHeader(
                    title: "Special Offer",
                    subtitle: "50% Off",
                    description: "Limited time offer for new subscribers.",
                    style: .image,
                    imageName: "gift.fill"
                )

                MBPaywallHeader(
                    title: "Upgrade",
                    description: "Clean and minimal upgrade prompt.",
                    style: .minimal,
                    imageName: "arrow.up.circle"
                )
            }
        }
    }

    // MARK: - Section Header
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(DesignTokens.Typography.title2)
            .fontWeight(.bold)
            .foregroundColor(DesignTokens.Colors.textPrimary)
            .padding(.top, DesignTokens.Spacing.md)
    }
}

// MARK: - Preview
#Preview {
    ComponentGallery()
        .withThemeManager()
}
