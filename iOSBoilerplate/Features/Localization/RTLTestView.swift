//
//  RTLTestView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct RTLTestView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var notificationCount = 3
    @State private var messageCount = 1
    @State private var selectedItems = 5

    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                // MARK: - Header
                headerSection

                // MARK: - Layout Direction Test
                layoutDirectionSection

                // MARK: - Text Alignment Test
                textAlignmentSection

                // MARK: - Pluralization Test
                pluralizationSection

                // MARK: - Navigation Test
                navigationTestSection

                // MARK: - Mixed Content Test
                mixedContentSection
            }
            .padding(DesignTokens.Spacing.screenPadding)
        }
        .background(DesignTokens.Colors.background)
        .navigationTitle("rtl.title".localized)
        .navigationBarTitleDisplayMode(.large)
        .rtlAware()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(DesignTokens.Animation.medium) {
                        // Cycle through RTL locales for testing
                        switch localizationManager.currentLocale {
                        case .english:
                            localizationManager.setLocale(.arabic)
                        case .arabic:
                            localizationManager.setLocale(.hebrew)
                        case .hebrew:
                            localizationManager.setLocale(.english)
                        case .turkish:
                            localizationManager.setLocale(.arabic)
                        }
                    }
                } label: {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        Text(localizationManager.currentLocale.flag)
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .foregroundColor(DesignTokens.Colors.primary)
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        MBCard(style: .elevated) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Text("rtl.title".localized)
                        .font(DesignTokens.Typography.title2)
                        .foregroundColor(DesignTokens.Colors.textPrimary)

                    Spacer()

                    Text(localizationManager.currentLocale.flag)
                        .font(.title)
                }

                Text("rtl.description".localized)
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)

                HStack {
                    Text("Layout Direction:")
                        .font(DesignTokens.Typography.callout)
                        .fontWeight(.medium)

                    Spacer()

                    Text(localizationManager.isRTL ? "Right-to-Left" : "Left-to-Right")
                        .font(DesignTokens.Typography.callout)
                        .foregroundColor(DesignTokens.Colors.primary)
                }
            }
        }
    }

    // MARK: - Layout Direction Section
    private var layoutDirectionSection: some View {
        MBCard(style: .outlined) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Layout Direction Test")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                HStack {
                    Text("Leading")
                        .padding(DesignTokens.Spacing.sm)
                        .background(DesignTokens.Colors.primary.opacity(0.2))
                        .cornerRadius(DesignTokens.CornerRadius.sm)

                    Spacer()

                    Text("Trailing")
                        .padding(DesignTokens.Spacing.sm)
                        .background(DesignTokens.Colors.secondary.opacity(0.2))
                        .cornerRadius(DesignTokens.CornerRadius.sm)
                }

                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(DesignTokens.Colors.primary)
                    Text("rtl.alignment.test".localized)
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.textPrimary)
                    Image(systemName: "arrow.right")
                        .foregroundColor(DesignTokens.Colors.primary)
                }
            }
        }
    }

    // MARK: - Text Alignment Section
    private var textAlignmentSection: some View {
        MBCard(style: .filled) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Text Alignment Test")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text("rtl.sample.text".localized)
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Mixed: English + عربي + עברית + 123")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Numbers: 123 | Symbols: @#$% | Date: 2024-01-15")
                        .font(DesignTokens.Typography.callout)
                        .foregroundColor(DesignTokens.Colors.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - Pluralization Section
    private var pluralizationSection: some View {
        MBCard(style: .elevated) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Pluralization Examples")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                VStack(spacing: DesignTokens.Spacing.md) {
                    // Notifications
                    HStack {
                        VStack(alignment: .leading) {
                            Text("notification.count".localized(count: notificationCount))
                                .font(DesignTokens.Typography.body)
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                        }

                        Spacer()

                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Button("-") {
                                if notificationCount > 0 {
                                    notificationCount -= 1
                                }
                            }
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.primary)

                            Text("\(notificationCount)")
                                .font(DesignTokens.Typography.body)
                                .frame(width: 30)

                            Button("+") {
                                notificationCount += 1
                            }
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.primary)
                        }
                    }

                    Divider()

                    // Messages
                    HStack {
                        VStack(alignment: .leading) {
                            Text("message.count".localized(count: messageCount))
                                .font(DesignTokens.Typography.body)
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                        }

                        Spacer()

                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Button("-") {
                                if messageCount > 0 {
                                    messageCount -= 1
                                }
                            }
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.primary)

                            Text("\(messageCount)")
                                .font(DesignTokens.Typography.body)
                                .frame(width: 30)

                            Button("+") {
                                messageCount += 1
                            }
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.primary)
                        }
                    }

                    Divider()

                    // Selected Items
                    HStack {
                        VStack(alignment: .leading) {
                            Text("item.selected".localized(count: selectedItems))
                                .font(DesignTokens.Typography.body)
                                .foregroundColor(DesignTokens.Colors.textPrimary)
                        }

                        Spacer()

                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Button("-") {
                                if selectedItems > 0 {
                                    selectedItems -= 1
                                }
                            }
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.primary)

                            Text("\(selectedItems)")
                                .font(DesignTokens.Typography.body)
                                .frame(width: 30)

                            Button("+") {
                                selectedItems += 1
                            }
                            .font(DesignTokens.Typography.headline)
                            .foregroundColor(DesignTokens.Colors.primary)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Navigation Test Section
    private var navigationTestSection: some View {
        MBCard(style: .outlined) {
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("rtl.navigation.test".localized)
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                HStack(spacing: DesignTokens.Spacing.md) {
                    MBButton(title: "button.continue".localized, style: .primary, size: .small) {
                        print("Continue tapped")
                    }

                    MBButton(title: "button.cancel".localized, style: .tertiary, size: .small) {
                        print("Cancel tapped")
                    }
                }
            }
        }
    }

    // MARK: - Mixed Content Section
    private var mixedContentSection: some View {
        MBCard(style: .filled) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Mixed Content Test")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    MBListRow(
                        title: "settings.language".localized,
                        subtitle: localizationManager.currentLocale.displayName,
                        style: .inset,
                        leading: {
                            Text(localizationManager.currentLocale.flag)
                                .font(.title2)
                        },
                        trailing: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(DesignTokens.Colors.textTertiary)
                        }
                    )

                    MBListRow(
                        title: "settings.theme".localized,
                        subtitle: "theme.\(themeManager.currentMode.rawValue)".localized,
                        style: .inset,
                        leading: {
                            Image(systemName: themeManager.currentMode.systemImage)
                                .foregroundColor(DesignTokens.Colors.primary)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        RTLTestView()
    }
    .withThemeManager()
    .withLocalizationManager()
}
