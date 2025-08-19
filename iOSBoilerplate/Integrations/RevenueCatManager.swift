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
            guard !isConfigured else {
                print("🔧 RevenueCat: Already configured, skipping")
                return
            }

            let key = apiKey ?? (Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String)
            print("🔧 RevenueCat: Configuring with API key: \(key?.prefix(10) ?? "nil")...")

            guard let rcKey = key, !rcKey.isEmpty else {
                print("❌ RevenueCat: No API key found in Info.plist or parameter")
                print("🔍 RevenueCat: Check that 'REVENUECAT_API_KEY' is set in Info.plist")
                isConfigured = false
                return
            }

            print("🔧 RevenueCat: Setting log level to .warn")
            Purchases.logLevel = .warn

            print("🔧 RevenueCat: Calling Purchases.configure...")
            Purchases.configure(withAPIKey: rcKey)

            isConfigured = true
            print("✅ RevenueCat: Configuration successful")

            print("🔄 RevenueCat: Calling refresh() after configuration")
            refresh()
        #else
            print("⚠️ RevenueCat: Framework not available, setting configured to false")
            isConfigured = false
        #endif
    }

    // MARK: - Public API
    public func refresh() {
        #if canImport(RevenueCat)
            print("🔄 RevenueCat: Starting refresh...")
            guard isConfigured else {
                print("❌ RevenueCat: Not configured, cannot refresh")
                return
            }

            print("🔄 RevenueCat: Setting isLoading to true")
            isLoading = true

            print("🔄 RevenueCat: Calling Purchases.shared.getOfferings...")
            Purchases.shared.getOfferings { [weak self] offerings, error in
                guard let self else {
                    print("❌ RevenueCat: Self is nil in offerings callback")
                    return
                }

                print("🔄 RevenueCat: Offerings callback received")
                self.isLoading = false

                if let error = error {
                    print("❌ RevenueCat: Error fetching offerings: \(error.localizedDescription)")
                } else {
                    print("✅ RevenueCat: No error in offerings callback")
                }

                print("🔄 RevenueCat: Processing offerings...")
                print("🔄 RevenueCat: Offerings object: \(offerings?.description ?? "nil")")

                if let current = offerings?.current {
                    print("✅ RevenueCat: Found current offering: \(current.identifier)")
                    let pkgs = current.availablePackages
                    print("🔄 RevenueCat: Available packages count: \(pkgs.count)")

                    self.availablePackages = pkgs.map { pkg in
                        print("📦 RevenueCat: Processing package: \(pkg.identifier)")
                        print("📦 RevenueCat: Package title: \(pkg.storeProduct.localizedTitle)")
                        print("📦 RevenueCat: Package price: \(pkg.storeProduct.localizedPriceString)")

                        self.packageIdToPackage[pkg.identifier] = pkg
                        return PaywallPackage(
                            id: pkg.identifier,
                            title: pkg.storeProduct.localizedTitle,
                            price: pkg.storeProduct.localizedPriceString
                        )
                    }

                    print("✅ RevenueCat: Processed \(self.availablePackages.count) packages")
                } else {
                    print("⚠️ RevenueCat: No current offering found")
                    print("🔄 RevenueCat: All offerings: \(offerings?.all.values.map { $0.identifier } ?? [])")
                }

                print("🔄 RevenueCat: Calling updateEntitlement...")
                self.updateEntitlement()
            }
        #else
            print("⚠️ RevenueCat: Framework not available, cannot refresh")
        #endif
    }

    public func purchase(packageId: String, completion: ((Bool) -> Void)? = nil) {
        #if canImport(RevenueCat)
            print("💰 RevenueCat: Starting purchase for package: \(packageId)")
            guard let pkg = packageIdToPackage[packageId] else {
                print("❌ RevenueCat: Package not found for ID: \(packageId)")
                print("🔍 RevenueCat: Available package IDs: \(packageIdToPackage.keys.map { $0 })")
                completion?(false)
                return
            }

            print("💰 RevenueCat: Found package: \(pkg.identifier)")
            print("💰 RevenueCat: Package title: \(pkg.storeProduct.localizedTitle)")
            print("💰 RevenueCat: Package price: \(pkg.storeProduct.localizedPriceString)")

            isLoading = true
            print("💰 RevenueCat: Calling Purchases.shared.purchase...")

            Purchases.shared.purchase(package: pkg) { [weak self] _, _, error, userCancelled in
                guard let self else {
                    print("❌ RevenueCat: Self is nil in purchase callback")
                    return
                }

                print("💰 RevenueCat: Purchase callback received")
                self.isLoading = false

                if let error = error {
                    print("❌ RevenueCat: Purchase error: \(error.localizedDescription)")
                } else if userCancelled {
                    print("⚠️ RevenueCat: Purchase was cancelled by user")
                } else {
                    print("✅ RevenueCat: Purchase successful")
                }

                print("🔄 RevenueCat: Calling updateEntitlement after purchase...")
                self.updateEntitlement()
                completion?(self.isPro)
            }
        #else
            print("⚠️ RevenueCat: Framework not available, cannot purchase")
            completion?(false)
        #endif
    }

    public func restore(completion: ((Bool) -> Void)? = nil) {
        #if canImport(RevenueCat)
            print("🔄 RevenueCat: Starting restore purchases...")
            isLoading = true

            print("🔄 RevenueCat: Calling Purchases.shared.restorePurchases...")
            Purchases.shared.restorePurchases { [weak self] _, error in
                guard let self else {
                    print("❌ RevenueCat: Self is nil in restore callback")
                    return
                }

                print("🔄 RevenueCat: Restore callback received")
                self.isLoading = false

                if let error = error {
                    print("❌ RevenueCat: Restore error: \(error.localizedDescription)")
                } else {
                    print("✅ RevenueCat: Restore successful")
                }

                print("🔄 RevenueCat: Calling updateEntitlement after restore...")
                self.updateEntitlement()
                completion?(self.isPro)
            }
        #else
            print("⚠️ RevenueCat: Framework not available, cannot restore")
            completion?(false)
        #endif
    }

    // MARK: - Private
    private func updateEntitlement() {
        #if canImport(RevenueCat)
            print("🔄 RevenueCat: Starting updateEntitlement...")
            Purchases.shared.getCustomerInfo { [weak self] info, _ in
                guard let self else {
                    print("❌ RevenueCat: Self is nil in entitlement callback")
                    return
                }

                print("🔄 RevenueCat: Entitlement callback received")
                let proActive = info?.entitlements.active.values.contains(where: { _ in true }) ?? false
                self.isPro = proActive
                print("✅ RevenueCat: Entitlement updated, isPro: \(self.isPro)")
            }
        #endif
    }
}

// MARK: - View helper
public extension View {
    func withRevenueCatManager() -> some View {
        print("🔧 RevenueCat: Injecting RevenueCatManager into environment")
        print("🔧 RevenueCat: Manager isConfigured: \(RevenueCatManager.shared.isConfigured)")
        print("🔧 RevenueCat: Manager availablePackages count: \(RevenueCatManager.shared.availablePackages.count)")
        return environmentObject(RevenueCatManager.shared)
    }
}
