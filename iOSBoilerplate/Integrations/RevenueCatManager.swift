import Foundation
import SwiftUI

#if canImport(RevenueCat)
    import RevenueCat
#endif

// MARK: - RevenueCatManager

public final class RevenueCatManager: ObservableObject {
    public static let shared = RevenueCatManager()

    @Published public private(set) var isPro: Bool = false
    @Published public private(set) var availablePackages: [PaywallPackage] = []
    @Published public private(set) var isConfigured: Bool = false
    @Published public private(set) var isLoading: Bool = false

    #if canImport(RevenueCat)
        private var packageIdToPackage: [String: Package] = [:]
    #endif

    private init() {}

    public struct PaywallPackage: Identifiable, Equatable {
        public let id: String
        public let title: String
        public let price: String
    }

    // MARK: - Configuration
    public func configure(apiKey: String? = nil) {
        #if canImport(RevenueCat)
            guard !isConfigured else { return }

            let key = apiKey ?? (Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String)

            guard let rcKey = key, !rcKey.isEmpty else {
                isConfigured = false
                return
            }

            Purchases.logLevel = .warn
            Purchases.configure(withAPIKey: rcKey)

            isConfigured = true

            // Automatically check current entitlement status after configuration
            checkCurrentEntitlement()
            refresh()
        #else
            isConfigured = false
        #endif
    }

    // MARK: - Public API
    public func refresh() {
        #if canImport(RevenueCat)
            guard isConfigured else { return }

            isLoading = true

            Purchases.shared.getOfferings { [weak self] offerings, error in
                guard let self else { return }

                self.isLoading = false

                if let error = error {
                    print("RevenueCat: Error fetching offerings: \(error.localizedDescription)")
                    return
                }

                self.availablePackages = []
                self.packageIdToPackage = [:]

                if let current = offerings?.current {
                    let pkgs = current.availablePackages

                    self.availablePackages = pkgs.map { pkg in
                        // Use a fallback title if the localized title is empty
                        let title = pkg.storeProduct.localizedTitle.isEmpty
                            ? pkg.storeProduct.productIdentifier
                            : pkg.storeProduct.localizedTitle

                        self.packageIdToPackage[pkg.identifier] = pkg
                        return PaywallPackage(
                            id: pkg.identifier,
                            title: title,
                            price: pkg.storeProduct.localizedPriceString
                        )
                    }
                }

                // Check entitlement status after fetching offerings
                self.checkCurrentEntitlement()
            }
        #endif
    }

    public func purchase(packageId: String, completion: ((Bool) -> Void)? = nil) {
        #if canImport(RevenueCat)
            guard let pkg = packageIdToPackage[packageId] else {
                completion?(false)
                return
            }

            isLoading = true

            Purchases.shared.purchase(package: pkg) { [weak self] _, _, error, userCancelled in
                guard let self else { return }

                self.isLoading = false

                if let error = error {
                    print("RevenueCat: Purchase error: \(error.localizedDescription)")
                } else if userCancelled {
                    print("RevenueCat: Purchase was cancelled by user")
                } else {
                    print("RevenueCat: Purchase successful")
                }

                self.checkCurrentEntitlement()
                completion?(self.isPro)
            }
        #else
            completion?(false)
        #endif
    }

    public func restore(completion: ((Bool) -> Void)? = nil) {
        #if canImport(RevenueCat)
            isLoading = true

            Purchases.shared.restorePurchases { [weak self] _, error in
                guard let self else { return }

                self.isLoading = false

                if let error = error {
                    print("RevenueCat: Restore error: \(error.localizedDescription)")
                } else {
                    print("RevenueCat: Restore successful")
                }

                self.checkCurrentEntitlement()
                completion?(self.isPro)
            }
        #else
            completion?(false)
        #endif
    }

    // MARK: - Private
    public func checkCurrentEntitlement() {
        #if canImport(RevenueCat)
            Purchases.shared.getCustomerInfo { [weak self] info, error in
                guard let self else { return }

                if let error = error {
                    print("RevenueCat: Error getting customer info: \(error.localizedDescription)")
                    return
                }

                // Check for specific "Premium" entitlement
                let premiumEntitlementActive = info?.entitlements.active["Premium"] != nil

                // Also check if any entitlement with "Premium" in the name is active
                let anyPremiumEntitlementActive = info?.entitlements.active.keys.contains { key in
                    key.lowercased().contains("premium")
                } ?? false

                // Also check if any entitlement is active as fallback
                let anyEntitlementActive = info?.entitlements.active.values.contains(where: { _ in true }) ?? false

                // Use Premium entitlement if available, otherwise fall back to any entitlement
                let finalProStatus = premiumEntitlementActive || anyPremiumEntitlementActive || anyEntitlementActive

                DispatchQueue.main.async {
                    self.isPro = finalProStatus
                }
            }
        #endif
    }
}

// MARK: - View helper
public extension View {
    func withRevenueCatManager() -> some View {
        return environmentObject(RevenueCatManager.shared)
    }
}
