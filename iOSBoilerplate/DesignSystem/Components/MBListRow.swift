//
//  MBListRow.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

// MARK: - MBListRowStyle

public enum MBListRowStyle {
    case plain
    case card
    case inset

    var backgroundColor: Color {
        switch self {
        case .plain:
            return DesignTokens.Colors.background
        case .card, .inset:
            return DesignTokens.Colors.surface
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .plain:
            return 0
        case .card, .inset:
            return DesignTokens.CornerRadius.card
        }
    }

    var padding: EdgeInsets {
        switch self {
        case .plain:
            return EdgeInsets(
                top: DesignTokens.Spacing.md,
                leading: DesignTokens.Spacing.screenPadding,
                bottom: DesignTokens.Spacing.md,
                trailing: DesignTokens.Spacing.screenPadding
            )
        case .card:
            return EdgeInsets(
                top: DesignTokens.Spacing.md,
                leading: DesignTokens.Spacing.md,
                bottom: DesignTokens.Spacing.md,
                trailing: DesignTokens.Spacing.md
            )
        case .inset:
            return EdgeInsets(
                top: DesignTokens.Spacing.sm,
                leading: DesignTokens.Spacing.md,
                bottom: DesignTokens.Spacing.sm,
                trailing: DesignTokens.Spacing.md
            )
        }
    }
}

// MARK: - MBListRow
public struct MBListRow<Leading: View, Trailing: View>: View {
    // MARK: - Properties
    private let title: String
    private let subtitle: String?
    private let style: MBListRowStyle
    private let leading: Leading?
    private let trailing: Trailing?
    private let action: (() -> Void)?

    // MARK: - Initialization
    public init(
        title: String,
        subtitle: String? = nil,
        style: MBListRowStyle = .plain,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.action = action
        self.leading = leading()
        self.trailing = trailing()
    }

    // MARK: - Body
    public var body: some View {
        Group {
            if let action = action {
                Button {
                    action()
                } label: {
                    rowContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                rowContent
            }
        }
    }

    // MARK: - Row Content
    private var rowContent: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Leading Content
            if !(leading is EmptyView) {
                leading
            }

            // Main Content
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(title)
                    .font(DesignTokens.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(DesignTokens.Colors.textPrimary)
                    .multilineTextAlignment(.leading)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(DesignTokens.Typography.callout)
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                        .multilineTextAlignment(.leading)
                }
            }

            Spacer()

            // Trailing Content
            if !(trailing is EmptyView) {
                trailing
            } else if action != nil {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(DesignTokens.Colors.textTertiary)
            }
        }
        .padding(style.padding)
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
        .if(style == .card) { view in
            view.shadow(DesignTokens.Shadow.small)
        }
    }
}

// MARK: - Convenience Initializers
public extension MBListRow where Leading == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        style: MBListRowStyle = .plain,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            style: style,
            action: action,
            leading: { EmptyView() },
            trailing: trailing
        )
    }
}

public extension MBListRow where Trailing == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        style: MBListRowStyle = .plain,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading = { EmptyView() }
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            style: style,
            action: action,
            leading: leading,
            trailing: { EmptyView() }
        )
    }
}

public extension MBListRow where Leading == EmptyView, Trailing == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        style: MBListRowStyle = .plain,
        action: (() -> Void)? = nil
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            style: style,
            action: action,
            leading: { EmptyView() },
            trailing: { EmptyView() }
        )
    }
}

// MARK: - Preview
#Preview("List Row Styles") {
    VStack(spacing: DesignTokens.Spacing.md) {
        MBListRow(
            title: "Plain Row",
            subtitle: "Basic list row with subtitle",
            style: .plain,
            action: { print("Tapped!") }
        )

        MBListRow(
            title: "Card Row",
            subtitle: "Card style with shadow",
            style: .card,
            leading: {
                Image(systemName: "star.fill")
                    .foregroundColor(DesignTokens.Colors.warning)
            },
            trailing: {
                Text("★ 4.8")
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
            }
        )

        MBListRow(
            title: "Inset Row",
            subtitle: "Compact inset style",
            style: .inset,
            leading: {
                Circle()
                    .fill(DesignTokens.Colors.success)
                    .frame(width: 12, height: 12)
            }
        )
    }
    .padding()
    .background(DesignTokens.Colors.background)
    .withThemeManager()
}
