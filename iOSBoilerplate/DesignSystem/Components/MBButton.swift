//
//  MBButton.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - MBButtonStyle

public enum MBButtonStyle {
    case primary
    case secondary
    case tertiary
    case destructive
    case success
    case warning

    var backgroundColor: Color {
        switch self {
        case .primary:
            return DesignTokens.Colors.primary
        case .secondary:
            return DesignTokens.Colors.secondary
        case .tertiary:
            return DesignTokens.Colors.surface
        case .destructive:
            return DesignTokens.Colors.error
        case .success:
            return DesignTokens.Colors.success
        case .warning:
            return DesignTokens.Colors.warning
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return DesignTokens.Colors.onPrimary
        case .secondary:
            return DesignTokens.Colors.onSecondary
        case .tertiary:
            return DesignTokens.Colors.textPrimary
        case .destructive, .success, .warning:
            return DesignTokens.Colors.onPrimary
        }
    }

    var borderColor: Color? {
        switch self {
        case .tertiary:
            return DesignTokens.Colors.border
        default:
            return nil
        }
    }
}

// MARK: - MBButtonSize

public enum MBButtonSize {
    case small
    case medium
    case large

    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(
                top: DesignTokens.Spacing.sm,
                leading: DesignTokens.Spacing.md,
                bottom: DesignTokens.Spacing.sm,
                trailing: DesignTokens.Spacing.md
            )
        case .medium:
            return EdgeInsets(
                top: DesignTokens.Spacing.md,
                leading: DesignTokens.Spacing.lg,
                bottom: DesignTokens.Spacing.md,
                trailing: DesignTokens.Spacing.lg
            )
        case .large:
            return EdgeInsets(
                top: DesignTokens.Spacing.lg,
                leading: DesignTokens.Spacing.xl,
                bottom: DesignTokens.Spacing.lg,
                trailing: DesignTokens.Spacing.xl
            )
        }
    }

    var font: Font {
        switch self {
        case .small:
            return DesignTokens.Typography.footnote
        case .medium:
            return DesignTokens.Typography.buttonTitle
        case .large:
            return DesignTokens.Typography.headline
        }
    }
}

// MARK: - MBButton
public struct MBButton: View {
    // MARK: - Properties
    private let title: String
    private let style: MBButtonStyle
    private let size: MBButtonSize
    private let isLoading: Bool
    private let isDisabled: Bool
    private let action: () -> Void

    // MARK: - Initialization
    public init(
        title: String,
        style: MBButtonStyle = .primary,
        size: MBButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    // MARK: - Body
    public var body: some View {
        Button {
            if !isLoading && !isDisabled {
                action()
            }
        } label: {
            HStack(spacing: DesignTokens.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                }

                if !isLoading {
                    Text(title)
                        .font(size.font)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(size.padding)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button)
                    .fill(isDisabled ? DesignTokens.Colors.systemGroupedBackground : style.backgroundColor)
            )
            .foregroundColor(isDisabled ? DesignTokens.Colors.textDisabled : style.foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button)
                    .stroke(style.borderColor ?? Color.clear, lineWidth: style.borderColor != nil ? 1 : 0)
            )
            .opacity(isDisabled ? 0.6 : 1.0)
        }
        .disabled(isLoading || isDisabled)
        .animation(DesignTokens.Animation.fast, value: isLoading)
        .animation(DesignTokens.Animation.fast, value: isDisabled)
    }
}

// MARK: - Preview
#Preview("Button Styles") {
    VStack(spacing: DesignTokens.Spacing.md) {
        MBButton(title: "Primary Button", style: .primary) {}
        MBButton(title: "Secondary Button", style: .secondary) {}
        MBButton(title: "Tertiary Button", style: .tertiary) {}
        MBButton(title: "Destructive Button", style: .destructive) {}
        MBButton(title: "Success Button", style: .success) {}
        MBButton(title: "Warning Button", style: .warning) {}
        MBButton(title: "Loading Button", style: .primary, isLoading: true) {}
        MBButton(title: "Disabled Button", style: .primary, isDisabled: true) {}
    }
    .padding()
    .background(DesignTokens.Colors.background)
    .withThemeManager()
}
