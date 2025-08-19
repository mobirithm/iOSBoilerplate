//
//  LocalizationManager.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import Foundation
import SwiftUI

// MARK: - SupportedLocale

public enum SupportedLocale: String, CaseIterable {
    case english = "en"
    case turkish = "tr"
    case arabic = "ar"
    case hebrew = "he"

    public var displayName: String {
        switch self {
        case .english:
            return "English"
        case .turkish:
            return "Türkçe"
        case .arabic:
            return "العربية"
        case .hebrew:
            return "עברית"
        }
    }

    public var nativeDisplayName: String {
        switch self {
        case .english:
            return "English"
        case .turkish:
            return "Türkçe"
        case .arabic:
            return "العربية"
        case .hebrew:
            return "עברית"
        }
    }

    public var isRTL: Bool {
        switch self {
        case .arabic, .hebrew:
            return true
        case .english, .turkish:
            return false
        }
    }

    public var locale: Locale {
        return Locale(identifier: rawValue)
    }

    public var flag: String {
        switch self {
        case .english:
            return "🇺🇸"
        case .turkish:
            return "🇹🇷"
        case .arabic:
            return "🇸🇦"
        case .hebrew:
            return "🇮🇱"
        }
    }
}

// MARK: - LocalizationManager
public class LocalizationManager: ObservableObject {
    // MARK: - Singleton
    public static let shared = LocalizationManager()

    // MARK: - Published Properties
    @Published public var currentLocale: SupportedLocale {
        didSet {
            saveLocalePreference()
            updateBundle()
        }
    }

    @Published public var bundle: Bundle = .main

    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let localeKey = "app_locale"

    // MARK: - Initialization
    private init() {
        // Load saved locale preference
        let savedLocale = userDefaults.string(forKey: localeKey) ?? SupportedLocale.english.rawValue
        currentLocale = SupportedLocale(rawValue: savedLocale) ?? .english
        updateBundle()
    }

    // MARK: - Public Methods

    /// Set the current locale
    @MainActor
    public func setLocale(_ locale: SupportedLocale) {
        currentLocale = locale
    }

    /// Get localized string for key
    public func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, bundle: bundle, comment: "")
        if arguments.isEmpty {
            return format
        } else {
            return String(format: format, arguments: arguments)
        }
    }

    /// Get localized string with pluralization
    public func localizedString(for key: String, count: Int) -> String {
        let format = NSLocalizedString(key, bundle: bundle, comment: "")
        return String.localizedStringWithFormat(format, count)
    }

    /// Check if current locale is RTL
    public var isRTL: Bool {
        return currentLocale.isRTL
    }

    /// Get layout direction for current locale
    public var layoutDirection: LayoutDirection {
        return isRTL ? .rightToLeft : .leftToRight
    }

    // MARK: - Private Methods

    private func saveLocalePreference() {
        userDefaults.set(currentLocale.rawValue, forKey: localeKey)
    }

    private func updateBundle() {
        if
            let path = Bundle.main.path(forResource: currentLocale.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path)
        {
            self.bundle = bundle
        } else {
            bundle = Bundle.main
        }
    }
}

// MARK: - String Extension
public extension String {
    /// Get localized version of this string
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }

    /// Get localized version with arguments
    func localized(with arguments: CVarArg...) -> String {
        return LocalizationManager.shared.localizedString(for: self, arguments: arguments)
    }

    /// Get localized version with count for pluralization
    func localized(count: Int) -> String {
        return LocalizationManager.shared.localizedString(for: self, count: count)
    }
}

// MARK: - Environment Key
private struct LocalizationManagerKey: EnvironmentKey {
    static let defaultValue = LocalizationManager.shared
}

public extension EnvironmentValues {
    var localizationManager: LocalizationManager {
        get { self[LocalizationManagerKey.self] }
        set { self[LocalizationManagerKey.self] = newValue }
    }
}

// MARK: - View Extensions
public extension View {
    /// Inject localization manager into environment
    func withLocalizationManager() -> some View {
        environmentObject(LocalizationManager.shared)
            .environment(\.layoutDirection, LocalizationManager.shared.layoutDirection)
    }

    /// Apply RTL layout if needed
    func rtlAware() -> some View {
        environment(\.layoutDirection, LocalizationManager.shared.layoutDirection)
    }
}
