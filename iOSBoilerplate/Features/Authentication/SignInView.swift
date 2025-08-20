//
//  SignInView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import AuthenticationServices
import SwiftUI
#if canImport(GoogleSignIn)
    import GoogleSignIn
#endif

// MARK: - SignInView

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
                onCompletion: { result in
                    switch result {
                    case let .success(authorization):
                        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                            let userID = appleIDCredential.user
                            let email = appleIDCredential.email
                            let fullName = appleIDCredential.fullName
                            let idToken = appleIDCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }

                            // Check if we already have stored email/full name
                            let storedEmail = try? authManager.keychainManager
                                .loadString(for: KeychainManager.Keys.userEmail)
                            let storedFullName = try? authManager.keychainManager
                                .loadString(for: KeychainManager.Keys.userFullName)

                            // Use Apple's values if provided, otherwise use stored values
                            let finalEmail = email ?? storedEmail
                            let finalFullName: String?

                            if let appleFullName = fullName {
                                let displayName = [appleFullName.givenName, appleFullName.familyName]
                                    .compactMap { $0 }
                                    .joined(separator: " ")
                                finalFullName = displayName.isEmpty ? storedFullName : displayName
                            } else {
                                finalFullName = storedFullName
                            }

                            let user = User(
                                id: userID,
                                email: finalEmail,
                                fullName: finalFullName,
                                isEmailVerified: finalEmail != nil,
                                authProvider: .apple
                            )

                            // Save to keychain and update state
                            authManager.setSignedInState(user: user)

                            // Save credentials to keychain for persistence
                            do {
                                try authManager.keychainManager.save(
                                    string: userID,
                                    for: KeychainManager.Keys.appleUserID
                                )
                                if let emailToSave = finalEmail {
                                    try authManager.keychainManager.save(
                                        string: emailToSave,
                                        for: KeychainManager.Keys.userEmail
                                    )
                                }
                                if let fullNameToSave = finalFullName {
                                    try authManager.keychainManager.save(
                                        string: fullNameToSave,
                                        for: KeychainManager.Keys.userFullName
                                    )
                                }
                                if let idToken = idToken {
                                    try authManager.keychainManager.save(
                                        string: idToken,
                                        for: KeychainManager.Keys.appleIDToken
                                    )
                                }
                            } catch {
                                print("Failed to save credentials to keychain: \(error)")
                            }
                        }
                    case let .failure(error):
                        if let authError = error as? ASAuthorizationError {
                            switch authError.code {
                            case .canceled:
                                authManager.setErrorState(error: .cancelled)
                            case .failed:
                                authManager.setErrorState(error: .failed)
                            case .invalidResponse:
                                authManager.setErrorState(error: .invalidCredentials)
                            case .notHandled:
                                authManager.setErrorState(error: .failed)
                            case .unknown:
                                authManager.setErrorState(error: .unknown(error))
                            @unknown default:
                                authManager.setErrorState(error: .unknown(error))
                            }
                        } else {
                            authManager.setErrorState(error: .unknown(error))
                        }
                    }
                }
            )
            .signInWithAppleButtonStyle(
                themeManager.colorScheme == .dark ? .white : .black
            )
            .frame(height: 50)
            .cornerRadius(DesignTokens.CornerRadius.button)
            .shadow(DesignTokens.Shadow.small)

            // Sign in with Google Button
            #if canImport(GoogleSignIn)
                MBGoogleSignInButton {
                    authManager.signInWithGoogle()
                }
                .shadow(DesignTokens.Shadow.small)
            #endif

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
