//
//  AuthManager.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import AuthenticationServices
import CryptoKit
import SwiftUI

// MARK: - User

public struct User: Codable, Equatable {
    public let id: String
    public let email: String?
    public let fullName: String?
    public let isEmailVerified: Bool

    public init(id: String, email: String?, fullName: String?, isEmailVerified: Bool = false) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.isEmailVerified = isEmailVerified
    }
}

// MARK: - AuthState

public enum AuthState: Equatable {
    case loading
    case signedOut
    case signedIn(User)
    case error(Error)

    public static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.signedOut, .signedOut):
            return true
        case let (.signedIn(lhsUser), .signedIn(rhsUser)):
            return lhsUser == rhsUser
        case (.error, .error):
            return true // For animation purposes, treat all errors as equal
        default:
            return false
        }
    }
}

// MARK: - AuthError

public enum AuthError: Error, LocalizedError {
    case cancelled
    case failed
    case invalidCredentials
    case networkError
    case keychainError(KeychainError)
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .cancelled:
            return "auth.error.cancelled".localized
        case .failed:
            return "auth.error.failed".localized
        case .invalidCredentials:
            return "auth.error.invalidCredentials".localized
        case .networkError:
            return "auth.error.network".localized
        case let .keychainError(keychainError):
            return keychainError.localizedDescription
        case let .unknown(error):
            return error.localizedDescription
        }
    }
}

// MARK: - AuthManager
@MainActor
public class AuthManager: NSObject, ObservableObject {
    // MARK: - Singleton
    public static let shared = AuthManager()

    // MARK: - Published Properties
    @Published public var authState: AuthState = .loading
    @Published public var isSignedIn: Bool = false
    @Published public var currentUser: User?

    // MARK: - Private Properties
    public let keychainManager = KeychainManager.shared
    private var authorizationControllerRef: ASAuthorizationController?

    // MARK: - Initialization
    override init() {
        super.init()
        checkAuthenticationState()
    }

    // MARK: - Public Methods

    /// Check current authentication state
    public func checkAuthenticationState() {
        print("🔐 AuthManager: Checking authentication state...")
        authState = .loading

        Task {
            await MainActor.run {
                do {
                    // Check if we have stored credentials
                    let hasUserID = keychainManager.exists(for: KeychainManager.Keys.appleUserID)
                    print("🔐 AuthManager: Has stored Apple User ID: \(hasUserID)")

                    if hasUserID {
                        print("🔐 AuthManager: Found stored Apple User ID in keychain")
                        let userID = try keychainManager.loadString(for: KeychainManager.Keys.appleUserID)
                        let email = try? keychainManager.loadString(for: KeychainManager.Keys.userEmail)
                        let fullName = try? keychainManager.loadString(for: KeychainManager.Keys.userFullName)

                        print("🔐 AuthManager: Loaded from keychain:")
                        print("   - User ID: \(userID)")
                        print("   - Email: \(email ?? "nil")")
                        print("   - Full Name: \(fullName ?? "nil")")

                        let user = User(id: userID, email: email, fullName: fullName, isEmailVerified: email != nil)
                        print("🔐 AuthManager: Created user object, setting signed in state...")
                        setSignedInState(user: user)
                    } else {
                        print("🔐 AuthManager: No stored credentials found, setting signed out state")
                        setSignedOutState()
                    }
                } catch {
                    print("❌ AuthManager: Error checking authentication state: \(error)")
                    setErrorState(error: .keychainError(error as? KeychainError ?? .invalidItemFormat))
                }
            }
        }
    }

    /// Sign in with Apple
    public func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        // Generate nonce for security
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationControllerRef = authorizationController // retain to ensure callbacks
        authorizationController.performRequests()
    }

    /// Sign out
    public func signOut() {
        Task {
            await MainActor.run {
                do {
                    // Clear keychain
                    try keychainManager.clearAll()
                    setSignedOutState()
                } catch {
                    setErrorState(error: .keychainError(error as? KeychainError ?? .invalidItemFormat))
                }
            }
        }
    }

    /// Delete account
    public func deleteAccount() {
        // In a real app, you would call your backend API to delete the account
        // For this demo, we'll just sign out
        signOut()
    }

    // MARK: - Private Methods

    public func setSignedInState(user: User) {
        print("🔐 AuthManager: Setting signed in state for user:")
        print("   - ID: \(user.id)")
        print("   - Email: \(user.email ?? "nil")")
        print("   - Full Name: \(user.fullName ?? "nil")")
        print("   - Is Email Verified: \(user.isEmailVerified)")

        currentUser = user
        isSignedIn = true
        authState = .signedIn(user)

        print("🔐 AuthManager: State updated - isSignedIn: \(isSignedIn), authState: \(authState)")
    }

    private func setSignedOutState() {
        currentUser = nil
        isSignedIn = false
        authState = .signedOut
    }

    public func setErrorState(error: AuthError) {
        currentUser = nil
        isSignedIn = false
        authState = .error(error)
    }

    private func saveUserCredentials(userID: String, email: String?, fullName: String?, idToken: String?) {
        do {
            try keychainManager.save(string: userID, for: KeychainManager.Keys.appleUserID)

            if let email = email {
                try keychainManager.save(string: email, for: KeychainManager.Keys.userEmail)
            }

            if let fullName = fullName {
                try keychainManager.save(string: fullName, for: KeychainManager.Keys.userFullName)
            }

            if let idToken = idToken {
                try keychainManager.save(string: idToken, for: KeychainManager.Keys.appleIDToken)
            }
        } catch {
            // Intentionally ignore; user state will still be updated
        }
    }

    // MARK: - Nonce Generation
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            for random in randoms {
                if remainingLength == 0 {
                    continue
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

// MARK: ASAuthorizationControllerDelegate

extension AuthManager: ASAuthorizationControllerDelegate {
    public func authorizationController(
        controller _: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName
            let idToken = appleIDCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }

            // Create user object
            let displayName = [fullName?.givenName, fullName?.familyName]
                .compactMap { $0 }
                .joined(separator: " ")

            let user = User(
                id: userID,
                email: email,
                fullName: displayName.isEmpty ? nil : displayName,
                isEmailVerified: email != nil
            )

            // Save to keychain
            saveUserCredentials(userID: userID, email: email, fullName: displayName, idToken: idToken)

            // Update state
            setSignedInState(user: user)
        }
    }

    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                setErrorState(error: .cancelled)
            case .failed:
                setErrorState(error: .failed)
            case .invalidResponse:
                setErrorState(error: .invalidCredentials)
            case .notHandled:
                setErrorState(error: .failed)
            case .unknown:
                setErrorState(error: .unknown(error))
            @unknown default:
                setErrorState(error: .unknown(error))
            }
        } else {
            setErrorState(error: .unknown(error))
        }
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding

extension AuthManager: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        // Use modern UIWindowScene approach for iOS 15+
        if
            let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })
        {
            if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                return keyWindow
            }

            if let window = windowScene.windows.first {
                return window
            }
        }

        // Last resort: create a new window
        return UIWindow()
    }
}

// MARK: - AuthManagerKey

private struct AuthManagerKey: EnvironmentKey {
    @MainActor static var defaultValue: AuthManager { AuthManager.shared }
}

public extension EnvironmentValues {
    var authManager: AuthManager {
        get { self[AuthManagerKey.self] }
        set { self[AuthManagerKey.self] = newValue }
    }
}

// MARK: - View Extensions
public extension View {
    /// Inject auth manager into environment
    @MainActor
    func withAuthManager() -> some View {
        environmentObject(AuthManager.shared)
    }
}
