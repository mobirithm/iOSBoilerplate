//
//  SuperwallManager.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import Foundation
import SwiftUI
#if canImport(SuperwallKit)
    import SuperwallKit
#endif

// MARK: - PaywallEvent

public enum PaywallEvent: String, CaseIterable {
    case onboardingComplete = "onboarding_complete"
    case featureLockedAnalytics = "feature_locked_analytics"
    case featureLockedNotifications = "feature_locked_notifications"
    case featureLockedThemes = "feature_locked_themes"
    case featureLockedPremium = "feature_locked_premium"
    case customDemo = "custom_demo_event"

    public var displayName: String {
        switch self {
        case .onboardingComplete:
            return "Onboarding Complete"
        case .featureLockedAnalytics:
            return "Analytics Feature Locked"
        case .featureLockedNotifications:
            return "Notifications Feature Locked"
        case .featureLockedThemes:
            return "Themes Feature Locked"
        case .featureLockedPremium:
            return "Premium Feature Locked"
        case .customDemo:
            return "Custom Demo Event"
        }
    }
}

// MARK: - SuperwallError

public enum SuperwallError: Error, LocalizedError {
    case notConfigured
    case invalidAPIKey
    case eventRegistrationFailed(String)
    case presentationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Superwall is not configured"
        case .invalidAPIKey:
            return "Invalid Superwall API key"
        case let .eventRegistrationFailed(event):
            return "Failed to register event: \(event)"
        case let .presentationFailed(reason):
            return "Failed to present paywall: \(reason)"
        }
    }
}

// MARK: - SuperwallManager

@MainActor
public class SuperwallManager: NSObject, ObservableObject {
    // MARK: - Singleton
    public static let shared = SuperwallManager()

    // MARK: - Published Properties
    @Published public var isConfigured = false
    @Published public var isPaywallPresented = false
    @Published public var lastError: SuperwallError?

    // MARK: - Private Properties
    private var paywallPresentedObserver: NSObjectProtocol?
    private var paywallDismissedObserver: NSObjectProtocol?
    private let apiKey: String

    // MARK: - Analytics Integration
    public weak var analyticsDelegate: PaywallAnalyticsDelegate?

    // MARK: - Initialization
    override private init() {
        // Load API key from Info.plist or use default
        if
            let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: path),
            let key = plist["SUPERWALL_API_KEY"] as? String
        {
            apiKey = key
        } else {
            // Fallback API key (replace with your actual key)
            apiKey = "pk_coTEC0yvj9G24dHIqiXYk"
        }

        super.init()
        setupObservers()
    }

    // MARK: - Configuration

    /// Configure Superwall with API key from Info.plist
    public func configure() {
        #if canImport(SuperwallKit)
            guard !apiKey.isEmpty else {
                lastError = .invalidAPIKey
                print("❌ Error: Superwall API key is empty")
                return
            }

            do {
                // Configure Superwall
                Superwall.configure(apiKey: apiKey)

                // Set delegate for analytics
                Superwall.shared.delegate = self

                // Register paywall events
                registerPaywallEvents()

                isConfigured = true
                lastError = nil
                print("✅ Superwall configured successfully with API key: \(String(apiKey.prefix(10)))...")
            } catch {
                lastError = .presentationFailed(error.localizedDescription)
                print("❌ Superwall configuration failed: \(error)")
            }
        #else
            lastError = .notConfigured
            print("⚠️ Superwall SDK not available")
        #endif
    }

    // MARK: - Paywall Management

    /// Present paywall with specific event
    public func presentPaywall(event: PaywallEvent) {
        #if canImport(SuperwallKit)
            guard isConfigured else {
                lastError = .notConfigured
                print("❌ Superwall not configured")
                return
            }

            Task {
                do {
                    try await Superwall.shared.register(placement: event.rawValue)
                    print("✅ Paywall event registered: \(event.displayName)")
                    lastError = nil
                } catch {
                    let errorMsg = "Failed to register paywall event: \(event.displayName)"
                    lastError = .eventRegistrationFailed(errorMsg)
                    print("❌ \(errorMsg): \(error)")
                }
            }
        #else
            lastError = .notConfigured
            print("⚠️ Superwall SDK not available")
        #endif
    }

    /// Present paywall with custom identifier (for backwards compatibility)
    public func presentPaywall(identifier: String) {
        #if canImport(SuperwallKit)
            guard isConfigured else {
                lastError = .notConfigured
                print("❌ Superwall not configured")
                return
            }

            Task {
                do {
                    try await Superwall.shared.register(placement: identifier)
                    print("✅ Custom paywall event registered: \(identifier)")
                    lastError = nil
                } catch {
                    let errorMsg = "Failed to register custom event: \(identifier)"
                    lastError = .eventRegistrationFailed(errorMsg)
                    print("❌ \(errorMsg): \(error)")
                }
            }
        #else
            lastError = .notConfigured
            print("⚠️ Superwall SDK not available")
        #endif
    }

    /// Present paywall at end of onboarding
    public func presentOnboardingPaywall() {
        presentPaywall(event: .onboardingComplete)
    }

    /// Present paywall for locked feature
    public func presentFeaturePaywall(feature: PaywallEvent) {
        presentPaywall(event: feature)
    }

    // MARK: - Analytics Events

    private func registerPaywallEvents() {
        #if canImport(SuperwallKit)
            // Register all predefined events
            for event in PaywallEvent.allCases {
                Superwall.shared.register(placement: event.rawValue)
            }
            print("✅ Registered \(PaywallEvent.allCases.count) paywall events")
        #endif
    }

    // MARK: - Observers

    private func setupObservers() {
        #if canImport(SuperwallKit)
            // Listen for paywall presentation events
            paywallPresentedObserver = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("SuperwallPaywallPresented"),
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.isPaywallPresented = true
            }

            // Listen for paywall dismissal events
            paywallDismissedObserver = NotificationCenter.default.addObserver(
                forName: NSNotification.Name("SuperwallPaywallDismissed"),
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.isPaywallPresented = false
            }
        #endif
    }

    deinit {
        if let observer = paywallPresentedObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = paywallDismissedObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

// MARK: - Superwall Delegate

#if canImport(SuperwallKit)
    extension SuperwallManager: SuperwallDelegate {
        public func didDismissPaywall(withInfo info: PaywallInfo) {
            isPaywallPresented = false
            print("Paywall dismissed: \(info.placementId)")

            // Emit analytics event
            emitAnalyticsEvent("paywall_dismissed", properties: [
                "paywall_id": info.placementId,
                "paywall_name": info.placementId,
            ])
        }

        public func didPresentPaywall(withInfo info: PaywallInfo) {
            isPaywallPresented = true
            print("Paywall presented: \(info.placementId)")

            // Emit analytics event
            emitAnalyticsEvent("paywall_presented", properties: [
                "paywall_id": info.placementId,
                "paywall_name": info.placementId,
            ])
        }

        public func didPurchase(product: Product, withInfo info: PaywallInfo) {
            print("Purchase completed: \(product.id) from paywall: \(info.placementId)")

            // Emit analytics event
            emitAnalyticsEvent("purchase_completed", properties: [
                "product_id": product.id,
                "paywall_id": info.placementId,
                "price": product.price ?? 0.0,
            ])
        }

        public func didFailToPurchase(product: Product, withInfo info: PaywallInfo, error: Error) {
            print("Purchase failed: \(product.id) from paywall: \(info.placementId), error: \(error)")

            // Emit analytics event
            emitAnalyticsEvent("purchase_failed", properties: [
                "product_id": product.id,
                "paywall_id": info.placementId,
                "error": error.localizedDescription,
            ])
        }
    }
#endif

// MARK: - PaywallAnalyticsDelegate

public protocol PaywallAnalyticsDelegate: AnyObject {
    func trackPaywallEvent(_ event: String, properties: [String: Any])
}

extension SuperwallManager {
    private func emitAnalyticsEvent(_ event: String, properties: [String: Any]) {
        // Send to analytics delegate if available
        analyticsDelegate?.trackPaywallEvent(event, properties: properties)

        // Also log to console for debugging
        print("📊 Analytics Event: \(event)")
        print("📊 Properties: \(properties)")

        // TODO: This will integrate with MOB-16 (Analytics wiring)
        // When AnalyticsManager is implemented, it will conform to PaywallAnalyticsDelegate
    }
}

// MARK: - Environment Integration

private struct SuperwallManagerKey: EnvironmentKey {
    @MainActor static var defaultValue: SuperwallManager { SuperwallManager.shared }
}

public extension EnvironmentValues {
    var superwallManager: SuperwallManager {
        get { self[SuperwallManagerKey.self] }
        set { self[SuperwallManagerKey.self] = newValue }
    }
}

public extension View {
    /// Inject superwall manager into environment
    @MainActor
    func withSuperwallManager() -> some View {
        environmentObject(SuperwallManager.shared)
    }
}
