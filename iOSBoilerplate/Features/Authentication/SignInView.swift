//
//  SignInView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import AuthenticationServices
import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // MARK: - Header
                    headerSection

                    // MARK: - Welcome Content
                    welcomeSection

                    // MARK: - Authentication Section
                    authenticationSection

                    // MARK: - Footer
                    footerSection

                    Spacer(minLength: DesignTokens.Spacing.xl)
                }
                .padding(DesignTokens.Spacing.screenPadding)
            }
            .background(DesignTokens.Colors.background)
            .navigationBarHidden(true)
        }
        .rtlAware()
        .alert("error.general".localized, isPresented: $showError) {
            Button("button.ok".localized) {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
        .onChange(of: authManager.authState) { newState in
            if case let .error(error) = newState {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            // App Icon
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundColor(DesignTokens.Colors.primary)
                .shadow(DesignTokens.Shadow.medium)

            // App Title
            VStack(spacing: DesignTokens.Spacing.sm) {
                Text("app.title".localized)
                    .font(DesignTokens.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text("app.subtitle".localized)
                    .font(DesignTokens.Typography.title3)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
            }
        }
        .padding(.top, DesignTokens.Spacing.xl)
    }

    // MARK: - Welcome Section
    private var welcomeSection: some View {
        MBCard(style: .elevated) {
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("auth.welcome.title".localized)
                    .font(DesignTokens.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignTokens.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("auth.welcome.description".localized)
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
        }
    }

    // MARK: - Authentication Section
    private var authenticationSection: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            // Sign in with Apple Button
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { _ in
                    // Delegate-based flow handled in AuthManager
                }
            )
            .signInWithAppleButtonStyle(
                themeManager.colorScheme == .dark ? .white : .black
            )
            .frame(height: 50)
            .cornerRadius(DesignTokens.CornerRadius.button)
            .shadow(DesignTokens.Shadow.small)

            // Alternative: Custom Apple Sign-In Button
            MBButton(
                title: "auth.signInWithApple".localized,
                style: .primary,
                size: .large,
                isLoading: authManager.authState == .loading
            ) {
                authManager.signInWithApple()
            }

            // Guest Mode
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("auth.or".localized)
                    .font(DesignTokens.Typography.callout)
                    .foregroundColor(DesignTokens.Colors.textTertiary)

                MBButton(
                    title: "auth.continueAsGuest".localized,
                    style: .tertiary,
                    size: .large
                ) {
                    // In a real app, you might set a guest state
                    // For demo, we'll just show an alert
                    errorMessage = "auth.guestMode.description".localized
                    showError = true
                }
            }
        }
    }

    // MARK: - Footer Section
    private var footerSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("app.description".localized)
                .font(DesignTokens.Typography.footnote)
                .foregroundColor(DesignTokens.Colors.textTertiary)
                .multilineTextAlignment(.center)

            HStack(spacing: DesignTokens.Spacing.lg) {
                Button("auth.privacy".localized) {
                    // Open privacy policy
                    errorMessage = "auth.privacy.description".localized
                    showError = true
                }
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.textTertiary)

                Button("auth.terms".localized) {
                    // Open terms of service
                    errorMessage = "auth.terms.description".localized
                    showError = true
                }
                .font(DesignTokens.Typography.caption)
                .foregroundColor(DesignTokens.Colors.textTertiary)
            }
        }
    }
}

// MARK: - Preview
#Preview("Light Theme") {
    SignInView()
        .withThemeManager()
        .withLocalizationManager()
        .withAuthManager()
}

#Preview("Dark Theme") {
    SignInView()
        .withThemeManager()
        .withLocalizationManager()
        .withAuthManager()
        .preferredColorScheme(.dark)
}
