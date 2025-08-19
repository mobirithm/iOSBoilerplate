//
//  AuthenticatedView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - AuthenticatedView

struct AuthenticatedView: View {
    @EnvironmentObject private var authManager: AuthManager

    var body: some View {
        Group {
            switch authManager.authState {
            case .loading:
                LoadingView()
            case .signedOut, .error:
                SignInView()
            case .signedIn:
                MainTabView()
            }
        }
        .animation(DesignTokens.Animation.medium, value: authManager.authState)
    }
}

// MARK: - LoadingView

struct LoadingView: View {
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(DesignTokens.Colors.primary)

            Text("auth.loading".localized)
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignTokens.Colors.background)
    }
}

// MARK: - MainTabView

struct MainTabView: View {
    @EnvironmentObject private var authManager: AuthManager

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "house")
                    Text("nav.home".localized)
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("nav.profile".localized)
                }
        }
        .tint(DesignTokens.Colors.primary)
    }
}

// MARK: - Preview
#Preview("Loading") {
    LoadingView()
        .withThemeManager()
        .withLocalizationManager()
}

#Preview("Authenticated") {
    AuthenticatedView()
        .withThemeManager()
        .withLocalizationManager()
        .withAuthManager()
}
