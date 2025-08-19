//
//  MBTextField.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - MBTextFieldState

public enum MBTextFieldState {
    case normal
    case focused
    case error
    case success
    case disabled

    var borderColor: Color {
        switch self {
        case .normal:
            return DesignTokens.Colors.border
        case .focused:
            return DesignTokens.Colors.primary
        case .error:
            return DesignTokens.Colors.error
        case .success:
            return DesignTokens.Colors.success
        case .disabled:
            return DesignTokens.Colors.borderVariant
        }
    }

    var backgroundColor: Color {
        switch self {
        case .disabled:
            return DesignTokens.Colors.systemGroupedBackground
        default:
            return DesignTokens.Colors.surface
        }
    }
}

// MARK: - MBTextField
public struct MBTextField: View {
    // MARK: - Properties
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    private let placeholder: String
    private let title: String?
    private let helperText: String?
    private let errorText: String?
    private let isSecure: Bool
    private let isDisabled: Bool
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?

    // MARK: - Computed Properties
    private var currentState: MBTextFieldState {
        if isDisabled {
            return .disabled
        } else if errorText != nil {
            return .error
        } else if isFocused {
            return .focused
        } else {
            return .normal
        }
    }

    // MARK: - Initialization
    public init(
        text: Binding<String>,
        placeholder: String,
        title: String? = nil,
        helperText: String? = nil,
        errorText: String? = nil,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) {
        _text = text
        self.placeholder = placeholder
        self.title = title
        self.helperText = helperText
        self.errorText = errorText
        self.isSecure = isSecure
        self.isDisabled = isDisabled
        self.keyboardType = keyboardType
        self.textContentType = textContentType
    }

    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            // Title
            if let title = title {
                Text(title)
                    .font(DesignTokens.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(DesignTokens.Colors.textPrimary)
            }

            // Text Field
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .focused($isFocused)
            .disabled(isDisabled)
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Colors.textPrimary)
            .padding(DesignTokens.Spacing.md)
            .background(currentState.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.button)
                    .stroke(currentState.borderColor, lineWidth: isFocused ? 2 : 1)
            )
            .animation(DesignTokens.Animation.fast, value: isFocused)
            .animation(DesignTokens.Animation.fast, value: currentState)

            // Helper/Error Text
            if let errorText = errorText {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(DesignTokens.Colors.error)
                        .font(.caption)
                    Text(errorText)
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.error)
                }
            } else if let helperText = helperText {
                Text(helperText)
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
            }
        }
    }
}

// MARK: - Preview
#Preview("TextField States") {
    VStack(spacing: DesignTokens.Spacing.lg) {
        MBTextField(
            text: .constant(""),
            placeholder: "Enter your email",
            title: "Email",
            helperText: "We'll never share your email"
        )

        MBTextField(
            text: .constant("john@example.com"),
            placeholder: "Enter your email",
            title: "Email (Filled)"
        )

        MBTextField(
            text: .constant("invalid-email"),
            placeholder: "Enter your email",
            title: "Email",
            errorText: "Please enter a valid email address"
        )

        MBTextField(
            text: .constant(""),
            placeholder: "Enter your password",
            title: "Password",
            isSecure: true
        )

        MBTextField(
            text: .constant("Disabled field"),
            placeholder: "Disabled",
            title: "Disabled Field",
            isDisabled: true
        )
    }
    .padding()
    .background(DesignTokens.Colors.background)
    .withThemeManager()
}
