//
//  MBCard.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - MBCardStyle

public enum MBCardStyle {
    case elevated
    case outlined
    case filled

    var backgroundColor: Color {
        switch self {
        case .elevated, .outlined:
            return DesignTokens.Colors.surface
        case .filled:
            return DesignTokens.Colors.surfaceVariant
        }
    }

    var shadow: DesignTokens.Shadow.ShadowStyle? {
        switch self {
        case .elevated:
            return DesignTokens.Shadow.medium
        case .outlined, .filled:
            return nil
        }
    }

    var borderColor: Color? {
        switch self {
        case .outlined:
            return DesignTokens.Colors.border
        case .elevated, .filled:
            return nil
        }
    }
}

// MARK: - MBCard
public struct MBCard<Content: View>: View {
    // MARK: - Properties
    private let style: MBCardStyle
    private let content: Content
    private let action: (() -> Void)?

    // MARK: - Initialization
    public init(
        style: MBCardStyle = .elevated,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.action = action
        self.content = content()
    }

    // MARK: - Body
    public var body: some View {
        Group {
            if let action = action {
                Button {
                    action()
                } label: {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                cardContent
            }
        }
    }

    // MARK: - Card Content
    private var cardContent: some View {
        content
            .padding(DesignTokens.Spacing.cardPadding)
            .background(style.backgroundColor)
            .cornerRadius(DesignTokens.CornerRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.card)
                    .stroke(style.borderColor ?? Color.clear, lineWidth: style.borderColor != nil ? 1 : 0)
            )
            .if(style.shadow != nil) { view in
                view.shadow(style.shadow!)
            }
    }
}

// MARK: - View Extension for Conditional Modifier
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview
#Preview("Card Styles") {
    VStack(spacing: DesignTokens.Spacing.lg) {
        MBCard(style: .elevated) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("Elevated Card")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text("This card has a shadow and elevated appearance.")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
            }
        }

        MBCard(style: .outlined) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("Outlined Card")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text("This card has a border outline.")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
            }
        }

        MBCard(style: .filled, action: {
            print("Card tapped!")
        }) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("Filled Card (Tappable)")
                    .font(DesignTokens.Typography.headline)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text("This card is filled and interactive.")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
            }
        }
    }
    .padding()
    .background(DesignTokens.Colors.background)
    .withThemeManager()
}
