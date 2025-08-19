//
//  ProfileView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var showSignOutAlert = false
    @State private var showDeleteAccountAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // MARK: - Profile Header
                    profileHeaderSection

                    // MARK: - User Information
                    userInformationSection

                    // MARK: - Account Actions
                    accountActionsSection

                    // MARK: - App Settings
                    appSettingsSection

                    Spacer(minLength: DesignTokens.Spacing.xl)
                }
                .padding(DesignTokens.Spacing.screenPadding)
            }
            .background(DesignTokens.Colors.background)
            .navigationTitle("nav.profile".localized)
            .navigationBarTitleDisplayMode(.large)
        }
        .rtlAware()
        .alert("auth.signOut.confirm".localized, isPresented: $showSignOutAlert) {
            Button("nav.cancel".localized, role: .cancel) {
                showSignOutAlert = false
            }
            Button("auth.signOut".localized, role: .destructive) {
                authManager.signOut()
            }
        } message: {
            Text("auth.signOut.message".localized)
        }
        .alert("auth.deleteAccount.confirm".localized, isPresented: $showDeleteAccountAlert) {
            Button("nav.cancel".localized, role: .cancel) {
                showDeleteAccountAlert = false
            }
            Button("auth.deleteAccount".localized, role: .destructive) {
                authManager.deleteAccount()
            }
        } message: {
            Text("auth.deleteAccount.message".localized)
        }
    }

    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        MBCard(style: .elevated) {
            VStack(spacing: DesignTokens.Spacing.md) {
                // Profile Avatar
                Circle()
                    .fill(DesignTokens.Colors.primary.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(DesignTokens.Colors.primary)
                    )

                // User Name
                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text(authManager.currentUser?.fullName ?? "auth.user.anonymous".localized)
                        .font(DesignTokens.Typography.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignTokens.Colors.textPrimary)

                    if let email = authManager.currentUser?.email {
                        Text(email)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }

                    // Account Status
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        Image(systemName: authManager.currentUser?.isEmailVerified == true
                            ? "checkmark.circle.fill"
                            : "exclamationmark.circle.fill"
                        )
                        .foregroundColor(authManager.currentUser?.isEmailVerified == true
                            ? DesignTokens.Colors.success
                            : DesignTokens.Colors.warning
                        )

                        Text(authManager.currentUser?.isEmailVerified == true
                            ? "auth.verified".localized
                            : "auth.unverified".localized
                        )
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - User Information Section
    private var userInformationSection: some View {
        MBCard(style: .outlined) {
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("auth.accountInfo".localized)
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    // User ID
                    HStack {
                        Text("auth.userID".localized)
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        Spacer()

                        Text(authManager.currentUser?.id ?? "N/A")
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }

                    Divider()

                    // Email
                    HStack {
                        Text("auth.email".localized)
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        Spacer()

                        Text(authManager.currentUser?.email ?? "auth.notProvided".localized)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }

                    Divider()

                    // Full Name
                    HStack {
                        Text("auth.fullName".localized)
                            .font(DesignTokens.Typography.callout)
                            .fontWeight(.medium)
                            .foregroundColor(DesignTokens.Colors.textPrimary)

                        Spacer()

                        Text(authManager.currentUser?.fullName ?? "auth.notProvided".localized)
                            .font(DesignTokens.Typography.callout)
                            .foregroundColor(DesignTokens.Colors.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Account Actions Section
    private var accountActionsSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("auth.accountActions".localized)
                .font(DesignTokens.Typography.headline)
                .foregroundColor(DesignTokens.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: DesignTokens.Spacing.sm) {
                MBButton(
                    title: "auth.signOut".localized,
                    style: .secondary,
                    size: .large
                ) {
                    showSignOutAlert = true
                }

                MBButton(
                    title: "auth.deleteAccount".localized,
                    style: .destructive,
                    size: .large
                ) {
                    showDeleteAccountAlert = true
                }
            }
        }
    }

    // MARK: - App Settings Section
    private var appSettingsSection: some View {
        MBCard(style: .filled) {
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("settings.title".localized)
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    MBListRow(
                        title: "settings.language".localized,
                        subtitle: localizationManager.currentLocale.displayName,
                        style: .plain,
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
                        style: .plain,
                        leading: {
                            Image(systemName: themeManager.currentMode.systemImage)
                                .foregroundColor(DesignTokens.Colors.primary)
                        },
                        trailing: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(DesignTokens.Colors.textTertiary)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("Signed In") {
    ProfileView()
        .withThemeManager()
        .withLocalizationManager()
        .withAuthManager()
}

#Preview("Dark Theme") {
    ProfileView()
        .withThemeManager()
        .withLocalizationManager()
        .withAuthManager()
        .preferredColorScheme(.dark)
}
