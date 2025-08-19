//
//  iOSBoilerplateApp.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

@main
struct IOSBoilerplateApp: App {
    var body: some Scene {
        WindowGroup {
            AuthenticatedView()
                .withThemeManager()
                .withLocalizationManager()
                .withAuthManager()
        }
    }
}
