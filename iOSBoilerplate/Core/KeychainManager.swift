//
//  KeychainManager.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import Foundation
import Security

// MARK: - KeychainError

public enum KeychainError: Error, LocalizedError {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)

    public var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "error.keychain.itemNotFound".localized
        case .duplicateItem:
            return "error.keychain.duplicateItem".localized
        case .invalidItemFormat:
            return "error.keychain.invalidFormat".localized
        case let .unexpectedStatus(status):
            return "error.keychain.unexpected".localized(with: status)
        }
    }
}

// MARK: - KeychainManager
public class KeychainManager {
    // MARK: - Singleton
    public static let shared = KeychainManager()

    // MARK: - Private Properties
    private let serviceName: String

    // MARK: - Initialization
    private init() {
        serviceName = Bundle.main.bundleIdentifier ?? "com.mobirithm.iOSBoilerplate"
    }

    // MARK: - Public Methods

    /// Save data to keychain
    public func save(data: Data, for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]

        // Delete any existing item first
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    /// Save string to keychain
    public func save(string: String, for key: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        try save(data: data, for: key)
    }

    /// Load data from keychain
    public func load(for key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            } else {
                throw KeychainError.unexpectedStatus(status)
            }
        }

        guard let data = result as? Data else {
            throw KeychainError.invalidItemFormat
        }

        return data
    }

    /// Load string from keychain
    public func loadString(for key: String) throws -> String {
        let data = try load(for: key)
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        return string
    }

    /// Delete item from keychain
    public func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    /// Check if item exists in keychain
    public func exists(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Clear all keychain items for this service
    public func clearAll() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}

// MARK: KeychainManager.Keys

public extension KeychainManager {
    enum Keys {
        public static let appleUserID = "apple_user_id"
        public static let appleIDToken = "apple_id_token"
        public static let appleAuthCode = "apple_auth_code"
        public static let userEmail = "user_email"
        public static let userFullName = "user_full_name"
    }
}
