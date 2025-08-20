//
//  MBPaywallTrigger.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - MBPaywallTrigger

/// A reusable component that triggers paywalls when users try to access premium features
struct MBPaywallTrigger<Content: View>: View {
    let content: Content
    let event: PaywallEvent
    let isLocked: Bool

    @EnvironmentObject private var superwallManager: SuperwallManager
    @EnvironmentObject private var revenueCat: RevenueCatManager

    init(
        event: PaywallEvent,
        isLocked: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.event = event
        self.isLocked = isLocked
        self.content = content()
    }

    var body: some View {
        Button {
            if isLocked {
                // Trigger paywall for locked feature
                superwallManager.presentPaywall(event: event)
            }
        } label: {
            content
                .overlay(
                    // Lock overlay for locked features
                    Group {
                        if isLocked {
                            lockOverlay
                        }
                    }
                )
        }
        .disabled(isLocked)
        .buttonStyle(PlainButtonStyle())
    }

    private var lockOverlay: some View {
        ZStack {
            // Semi-transparent overlay
            DesignTokens.Colors.surface.opacity(0.8)

            // Lock icon
            VStack(spacing: DesignTokens.Spacing.xs) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundColor(DesignTokens.Colors.primary)

                Text("Premium")
                    .font(DesignTokens.Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignTokens.Colors.primary)
            }
        }
        .cornerRadius(DesignTokens.CornerRadius.card)
    }
}

// MARK: - Convenience Initializers

extension MBPaywallTrigger {
    /// Create a paywall trigger that automatically checks RevenueCat entitlements
    init(
        event: PaywallEvent,
        @ViewBuilder content: () -> Content
    ) {
        self.init(event: event, isLocked: !RevenueCatManager.shared.isPro, content: content)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        // Locked feature example
        MBPaywallTrigger(event: .featureLockedAnalytics, isLocked: true) {
            MBCard(style: .elevated) {
                VStack {
                    Text("Premium Analytics")
                        .font(DesignTokens.Typography.headline)
                    Text("Advanced insights and metrics")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                }
                .padding()
            }
        }

        // Unlocked feature example
        MBPaywallTrigger(event: .featureLockedThemes, isLocked: false) {
            MBCard(style: .filled) {
                VStack {
                    Text("Basic Themes")
                        .font(DesignTokens.Typography.headline)
                    Text("Standard theme options")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                }
                .padding()
            }
        }
    }
    .padding()
    .withSuperwallManager()
    .withRevenueCatManager()
}
