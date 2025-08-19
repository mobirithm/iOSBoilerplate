//
//  ThemeManager.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import Combine
import SwiftUI

// MARK: - ThemeMode

public enum ThemeMode: String, CaseIterable {
    case system
    case light
    case dark

    public var displayName: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }

    public var systemImage: String {
        switch self {
        case .system:
            return "gear"
        case .light:
            return "sun.max"
        case .dark:
            return "moon"
        }
    }
}

// MARK: - ThemeManager

@MainActor
public class ThemeManager: ObservableObject {
    // MARK: - Singleton
    public static let shared = ThemeManager()

    // MARK: - Published Properties
    @Published public var currentMode: ThemeMode {
        didSet {
            saveThemePreference()
            updateColorScheme()
        }
    }

    @Published public var colorScheme: ColorScheme?

    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let themeKey = "app_theme_mode"

    // MARK: - Initialization
    private init() {
        // Load saved theme preference
        let savedTheme = userDefaults.string(forKey: themeKey) ?? ThemeMode.system.rawValue
        currentMode = ThemeMode(rawValue: savedTheme) ?? .system
        updateColorScheme()
    }

    // MARK: - Public Methods

    /// Set the theme mode
    public func setTheme(_ mode: ThemeMode) {
        currentMode = mode
    }

    /// Toggle between light and dark (skips system)
    public func toggleTheme() {
        switch currentMode {
        case .system, .light:
            setTheme(.dark)
        case .dark:
            setTheme(.light)
        }
    }

    /// Get the effective color scheme for the current mode
    public func effectiveColorScheme(for systemScheme: ColorScheme) -> ColorScheme {
        switch currentMode {
        case .system:
            return systemScheme
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    // MARK: - Private Methods

    private func saveThemePreference() {
        userDefaults.set(currentMode.rawValue, forKey: themeKey)
    }

    private func updateColorScheme() {
        switch currentMode {
        case .system:
            colorScheme = nil // Use system default
        case .light:
            colorScheme = .light
        case .dark:
            colorScheme = .dark
        }
    }
}

// MARK: - ThemeManagerKey

private struct ThemeManagerKey: EnvironmentKey {
    @MainActor static var defaultValue: ThemeManager { ThemeManager.shared }
}

public extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}

// MARK: - View Extensions
public extension View {
    /// Apply the current theme's color scheme
    @MainActor
    func themedColorScheme() -> some View {
        preferredColorScheme(ThemeManager.shared.colorScheme)
    }

    /// Inject theme manager into environment
    @MainActor
    func withThemeManager() -> some View {
        environmentObject(ThemeManager.shared)
    }
}
