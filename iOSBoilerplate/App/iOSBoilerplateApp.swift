//
//  iOSBoilerplateApp.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI
#if canImport(GoogleSignIn)
    import GoogleSignIn
#endif
#if canImport(SuperwallKit)
    import SuperwallKit
#endif

// MARK: - IOSBoilerplateApp

@main
struct IOSBoilerplateApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            AuthenticatedView()
                .withThemeManager()
                .withLocalizationManager()
                .withAuthManager()
                .withRevenueCatManager()
                .withSuperwallManager()
                .onAppear {
                    #if canImport(RevenueCat)
                        RevenueCatManager.shared.configure()
                    #endif

                    #if canImport(GoogleSignIn)
                        // Configure Google Sign-In
                        var clientID: String?

                        // First try to get from GoogleService-Info.plist
                        if
                            let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
                            let plist = NSDictionary(contentsOfFile: path),
                            let googleClientID = plist["CLIENT_ID"] as? String
                        {
                            clientID = googleClientID
                        }
                        // Fallback to Info.plist
                        else if
                            let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
                            let plist = NSDictionary(contentsOfFile: path),
                            let infoClientID = plist["GIDClientID"] as? String
                        {
                            clientID = infoClientID
                        }

                        guard let finalClientID = clientID else {
                            print("Warning: GIDClientID not found in GoogleService-Info.plist or Info.plist")
                            return
                        }

                        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: finalClientID)
                    #endif

                    #if canImport(SuperwallKit)
                        // Configure Superwall
                        SuperwallManager.shared.configure()

                        // Connect RevenueCat manager to Superwall
                        SuperwallManager.shared.revenueCatManager = RevenueCatManager.shared
                    #endif
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        #if canImport(RevenueCat)
                            // Check entitlements when app becomes active
                            RevenueCatManager.shared.checkCurrentEntitlement()
                        #endif
                    }
                }
                .onOpenURL { url in
                    #if canImport(GoogleSignIn)
                        // Handle Google Sign-In URL
                        GIDSignIn.sharedInstance.handle(url)
                    #endif
                }
        }
    }
}
