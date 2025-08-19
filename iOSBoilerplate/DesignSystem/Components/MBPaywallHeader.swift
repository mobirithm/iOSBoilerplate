//
//  MBPaywallHeader.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - MBPaywallHeaderStyle

public enum MBPaywallHeaderStyle {
    case gradient
    case image
    case minimal

    var backgroundColor: LinearGradient {
        switch self {
        case .gradient:
            return LinearGradient(
                colors: [DesignTokens.Colors.primary, DesignTokens.Colors.primaryVariant],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .image:
            return LinearGradient(
                colors: [DesignTokens.Colors.primary.opacity(0.8), DesignTokens.Colors.primaryVariant.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .minimal:
            return LinearGradient(
                colors: [DesignTokens.Colors.surface, DesignTokens.Colors.surfaceVariant],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    var textColor: Color {
        switch self {
        case .gradient, .image:
            return DesignTokens.Colors.onPrimary
        case .minimal:
            return DesignTokens.Colors.textPrimary
        }
    }
}

// MARK: - MBPaywallHeader
public struct MBPaywallHeader: View {
    // MARK: - Properties
    private let title: String
    private let subtitle: String?
    private let description: String?
    private let style: MBPaywallHeaderStyle
    private let imageName: String?
    private let closeAction: (() -> Void)?

    // MARK: - Initialization
    public init(
        title: String,
        subtitle: String? = nil,
        description: String? = nil,
        style: MBPaywallHeaderStyle = .gradient,
        imageName: String? = nil,
        closeAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.style = style
        self.imageName = imageName
        self.closeAction = closeAction
    }

    // MARK: - Body
    public var body: some View {
        VStack(spacing: 0) {
            // Header Content
            VStack(spacing: DesignTokens.Spacing.lg) {
                // Close Button
                if let closeAction = closeAction {
                    HStack {
                        Spacer()
                        Button {
                            closeAction()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(style.textColor.opacity(0.8))
                        }
                    }
                    .padding(.top, DesignTokens.Spacing.md)
                }

                // Main Content
                VStack(spacing: DesignTokens.Spacing.md) {
                    // Image/Icon
                    if let imageName = imageName {
                        Image(systemName: imageName)
                            .font(.system(size: 60))
                            .foregroundColor(style.textColor)
                    }

                    // Text Content
                    VStack(spacing: DesignTokens.Spacing.sm) {
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(DesignTokens.Typography.callout)
                                .fontWeight(.medium)
                                .foregroundColor(style.textColor.opacity(0.9))
                                .multilineTextAlignment(.center)
                        }

                        Text(title)
                            .font(DesignTokens.Typography.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(style.textColor)
                            .multilineTextAlignment(.center)

                        if let description = description {
                            Text(description)
                                .font(DesignTokens.Typography.body)
                                .foregroundColor(style.textColor.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                    }
                }
                .padding(.bottom, DesignTokens.Spacing.xl)
            }
            .padding(.horizontal, DesignTokens.Spacing.screenPadding)
            .frame(maxWidth: .infinity)
            .background(style.backgroundColor)

            // Bottom Curve
            CurvedShape()
                .fill(style.backgroundColor)
                .frame(height: 30)
        }
    }
}

// MARK: - CurvedShape

struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height),
            control: CGPoint(x: rect.width / 2, y: rect.height * 1.5)
        )
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
#Preview("Paywall Header Styles") {
    ScrollView {
        VStack(spacing: DesignTokens.Spacing.xl) {
            MBPaywallHeader(
                title: "Unlock Premium",
                subtitle: "Get Started",
                description: "Access all premium features and content with our subscription plan.",
                style: .gradient,
                imageName: "crown.fill",
                closeAction: { print("Close tapped") }
            )

            MBPaywallHeader(
                title: "Special Offer",
                subtitle: "Limited Time",
                description: "50% off your first month. Don't miss out on this exclusive deal!",
                style: .image,
                imageName: "gift.fill"
            )

            MBPaywallHeader(
                title: "Upgrade Account",
                description: "Simple and clean header design for minimal interfaces.",
                style: .minimal,
                imageName: "arrow.up.circle"
            )
        }
    }
    .background(DesignTokens.Colors.background)
    .withThemeManager()
}
