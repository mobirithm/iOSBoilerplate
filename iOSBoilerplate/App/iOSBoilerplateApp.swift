//
//  iOSBoilerplateApp.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

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
                .onAppear {
                    #if canImport(RevenueCat)
                        RevenueCatManager.shared.configure()
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
        }
    }
}
