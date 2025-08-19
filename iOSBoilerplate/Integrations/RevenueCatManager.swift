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
            guard let rcKey = key, !rcKey.isEmpty else { return }
            Purchases.logLevel = .warn
            Purchases.configure(withAPIKey: rcKey)
            isConfigured = true
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
            Purchases.shared.getOfferings { [weak self] offerings, _ in
                guard let self else { return }
                self.isLoading = false
                self.availablePackages = []
                self.packageIdToPackage = [:]
                if let current = offerings?.current {
                    let pkgs = current.availablePackages
                    self.availablePackages = pkgs.map { pkg in
                        self.packageIdToPackage[pkg.identifier] = pkg
                        return PaywallPackage(
                            id: pkg.identifier,
                            title: pkg.storeProduct.localizedTitle,
                            price: pkg.storeProduct.localizedPriceString
                        )
                    }
                }
            }
            updateEntitlement()
        #endif
    }

    public func purchase(packageId: String, completion: ((Bool) -> Void)? = nil) {
        #if canImport(RevenueCat)
            guard let pkg = packageIdToPackage[packageId] else { completion?(false); return }
            isLoading = true
            Purchases.shared.purchase(package: pkg) { [weak self] _, _, _, _ in
                self?.isLoading = false
                self?.updateEntitlement()
                completion?(self?.isPro ?? false)
            }
        #else
            completion?(false)
        #endif
    }

    public func restore(completion: ((Bool) -> Void)? = nil) {
        #if canImport(RevenueCat)
            isLoading = true
            Purchases.shared.restorePurchases { [weak self] _, _ in
                self?.isLoading = false
                self?.updateEntitlement()
                completion?(self?.isPro ?? false)
            }
        #else
            completion?(false)
        #endif
    }

    // MARK: - Private
    private func updateEntitlement() {
        #if canImport(RevenueCat)
            Purchases.shared.getCustomerInfo { [weak self] info, _ in
                guard let self else { return }
                let proActive = info?.entitlements.active.values.contains(where: { _ in true }) ?? false
                self.isPro = proActive
            }
        #endif
    }
}

// MARK: - View helper
public extension View {
    func withRevenueCatManager() -> some View {
        environmentObject(RevenueCatManager.shared)
    }
}
