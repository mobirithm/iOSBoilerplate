//
//  iOSBoilerplateTests.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import XCTest
@testable import iOSBoilerplate

final class IOSBoilerplateTests: XCTestCase {
    func testAppVersionIsValid() {
        // Test that app version can be retrieved from bundle
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        XCTAssertNotNil(version, "App version should be available")
        XCTAssertFalse(version?.isEmpty ?? true, "App version should not be empty")
    }

    func testBuildNumberIsValid() {
        // Test that build number can be retrieved from bundle
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        XCTAssertNotNil(buildNumber, "Build number should be available")
        XCTAssertFalse(buildNumber?.isEmpty ?? true, "Build number should not be empty")
    }

    func testBundleIdentifierIsValid() {
        // Test that bundle identifier is correctly set
        let bundleId = Bundle.main.bundleIdentifier
        XCTAssertEqual(bundleId, "com.mobirithm.iOSBoilerplate", "Bundle identifier should match expected value")
    }

    func testAppNameIsSet() {
        // Test that app name is available
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ??
            Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        XCTAssertNotNil(appName, "App name should be available in bundle")
    }
}
