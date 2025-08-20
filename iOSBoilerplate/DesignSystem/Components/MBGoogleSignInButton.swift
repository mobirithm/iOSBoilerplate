//
//  MBGoogleSignInButton.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI
#if canImport(GoogleSignIn)
    import GoogleSignIn
#endif

// MARK: - MBGoogleSignInButton

struct MBGoogleSignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                // Google Logo
                Image(systemName: "globe")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                // Button Text
                Text("auth.signInWithGoogle".localized)
                    .font(DesignTokens.Typography.buttonTitle)
                    .foregroundColor(DesignTokens.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button)
                    .stroke(DesignTokens.Colors.border, lineWidth: 1)
            )
            .cornerRadius(DesignTokens.CornerRadius.button)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        MBGoogleSignInButton {
            print("Google Sign-In tapped")
        }

        MBGoogleSignInButton {
            print("Google Sign-In tapped")
        }
        .preferredColorScheme(.dark)
    }
    .padding()
    .withLocalizationManager()
}
