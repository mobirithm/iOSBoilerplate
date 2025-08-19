//
//  LocalePicker.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct LocalePicker: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(SupportedLocale.allCases, id: \.self) { locale in
                        MBListRow(
                            title: locale.nativeDisplayName,
                            subtitle: locale.displayName != locale.nativeDisplayName ? locale.displayName : nil,
                            style: .plain,
                            action: {
                                withAnimation(DesignTokens.Animation.medium) {
                                    localizationManager.setLocale(locale)
                                    dismiss()
                                }
                            },
                            leading: {
                                Text(locale.flag)
                                    .font(.title2)
                            },
                            trailing: {
                                if localizationManager.currentLocale == locale {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(DesignTokens.Colors.success)
                                        .fontWeight(.semibold)
                                }
                            }
                        )
                    }
                } header: {
                    Text("locale.picker.title".localized)
                        .font(DesignTokens.Typography.callout)
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                }

                Section {
                    MBCard(style: .filled) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("locale.current".localized)
                                .font(DesignTokens.Typography.headline)
                                .foregroundColor(DesignTokens.Colors.textPrimary)

                            HStack {
                                Text(localizationManager.currentLocale.flag)
                                    .font(.title)

                                VStack(alignment: .leading) {
                                    Text(localizationManager.currentLocale.nativeDisplayName)
                                        .font(DesignTokens.Typography.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(DesignTokens.Colors.textPrimary)

                                    Text("RTL: \(localizationManager.isRTL ? "Yes" : "No")")
                                        .font(DesignTokens.Typography.caption)
                                        .foregroundColor(DesignTokens.Colors.textSecondary)
                                }

                                Spacer()
                            }
                        }
                    }
                } header: {
                    Text("Current Selection")
                        .font(DesignTokens.Typography.callout)
                        .foregroundColor(DesignTokens.Colors.textSecondary)
                }
            }
            .background(DesignTokens.Colors.background)
            .navigationTitle("locale.picker.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("nav.done".localized) {
                        dismiss()
                    }
                    .foregroundColor(DesignTokens.Colors.primary)
                }
            }
        }
        .rtlAware()
    }
}

// MARK: - Preview
#Preview {
    LocalePicker()
        .withThemeManager()
        .withLocalizationManager()
}
