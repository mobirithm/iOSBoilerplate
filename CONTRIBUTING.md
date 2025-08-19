# Contributing to iOS Boilerplate

Welcome to the iOS Boilerplate project! This guide will help you contribute effectively to our production-ready SwiftUI template.

## 🎯 Project Vision

This boilerplate is designed for **rapid consumer app development** with a focus on:
- **Speed**: Launch apps in weeks, not months
- **Consistency**: Standardized architecture and integrations
- **Monetization**: Built-in paywalls and subscription management
- **Growth**: Analytics, A/B testing, and push notifications
- **Quality**: Maintainable, testable, and scalable code

## 🛠 Development Setup

### Prerequisites
- **Xcode 15.0+**
- **macOS 13.0+**
- **Swift 5.0+**
- **Homebrew** (for development tools)

### Required Tools
```bash
# Install code quality tools
brew install swiftlint swiftformat

# Install XcodeGen (for project management)
brew install xcodegen
```

### Initial Setup
1. Clone the repository:
   ```bash
   git clone git@github.com:mobirithm/iOSBoilerplate.git
   cd iOSBoilerplate
   ```

2. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```

3. Open in Xcode:
   ```bash
   open iOSBoilerplate.xcodeproj
   ```

4. Set your development team in Xcode project settings

## 📋 Development Workflow

### Branch Strategy
- **`main`**: Production-ready code
- **Feature branches**: `feature/mob-X-description`
- **Hotfix branches**: `hotfix/issue-description`

### Making Changes

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/mob-X-your-feature
   ```

2. **Make your changes** following our coding standards

3. **Test your changes:**
   ```bash
   # Build and test
   xcodebuild -project iOSBoilerplate.xcodeproj -scheme iOSBoilerplate -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
   
   # Run linting manually
   swiftlint
   swiftformat --lint .
   ```

4. **Commit with descriptive messages:**
   ```bash
   git add .
   git commit -m "MOB-X: Brief description
   
   - Detailed change 1
   - Detailed change 2
   
   Closes MOB-X"
   ```

5. **Push and create PR:**
   ```bash
   git push origin feature/mob-X-your-feature
   ```

## 📝 Coding Standards

### Swift Style Guide

We follow a mobile-first approach with these key principles:

#### File Organization
```swift
// File header (required)
//
//  FileName.swift
//  iOSBoilerplate
//
//  Created by [Name] on [Date].
//

// Imports (organized)
import SwiftUI
import Foundation

// MARK: - Main Type
struct ContentView: View {
    // MARK: - Properties
    @State private var isLoading = false
    
    // MARK: - Body
    var body: some View {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func handleAction() {
        // Implementation
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
```

#### Naming Conventions
- **Types**: PascalCase (`UserManager`, `PaywallView`)
- **Variables/Functions**: camelCase (`isLoading`, `handleUserAction`)
- **Constants**: camelCase (`maxRetryCount`, `defaultTimeout`)
- **Enums**: PascalCase with camelCase cases (`NetworkError.invalidResponse`)

#### Code Organization
- **MARK comments** for section organization
- **Private** by default, expose only what's needed
- **Extensions** for protocol conformance
- **Single responsibility** per file/type

### SwiftUI Best Practices

#### State Management
```swift
// ✅ Good: Clear state ownership
@State private var username = ""
@StateObject private var viewModel = AuthViewModel()

// ❌ Avoid: Unclear state ownership
@State var data: [String] = []
```

#### View Composition
```swift
// ✅ Good: Small, focused views
struct LoginForm: View {
    var body: some View {
        VStack {
            UsernameField()
            PasswordField()
            LoginButton()
        }
    }
}

// ❌ Avoid: Massive view bodies
struct LoginView: View {
    var body: some View {
        // 100+ lines of view code
    }
}
```

#### Accessibility
```swift
// ✅ Always include accessibility
Button("Sign In") {
    signIn()
}
.accessibilityIdentifier("signInButton")
.accessibilityHint("Signs you into your account")
```

### Localization
```swift
// ✅ Use localized strings
Text("welcome_message")

// ❌ Avoid hardcoded strings
Text("Welcome to our app!")
```

## 🧪 Testing Guidelines

### Unit Tests
- Test business logic in `Core/` modules
- Mock external dependencies
- Test edge cases and error conditions

### UI Tests
- Test critical user flows (auth, paywall, onboarding)
- Test accessibility features
- Test different device sizes and orientations

### Manual Testing
- Test on multiple iOS versions (16.0+)
- Test dark/light mode
- Test different locales
- Test offline scenarios

## 🔍 Code Quality

### Automated Checks
Our pre-commit hook automatically runs:
- **SwiftLint**: Code style and best practices
- **SwiftFormat**: Consistent code formatting

### Manual Review Checklist
- [ ] Code follows Swift style guide
- [ ] New features include tests
- [ ] UI changes tested on multiple devices
- [ ] Accessibility labels added
- [ ] Strings are localized
- [ ] No hardcoded values or magic numbers
- [ ] Error handling implemented
- [ ] Documentation updated

## 📱 Architecture Guidelines

### Folder Structure
- **`App/`**: App entry point, main navigation, global state
- **`Core/`**: Shared utilities, managers, network layer
- **`Features/`**: Feature modules (Auth/, Wellness/, Settings/)
- **`DesignSystem/`**: Tokens, components, themes
- **`Integrations/`**: Third-party SDKs (Firebase, RevenueCat, etc.)
- **`Resources/`**: Assets, localizations, configurations
- **`Tests/`**: Unit tests, UI tests, test utilities

### Dependency Management
- **Swift Package Manager** preferred
- **CocoaPods** for packages not available in SPM
- Keep dependencies minimal and well-maintained

### Feature Module Structure
```
Features/Auth/
├── Views/
│   ├── LoginView.swift
│   └── SignUpView.swift
├── ViewModels/
│   └── AuthViewModel.swift
├── Models/
│   └── User.swift
└── Services/
    └── AuthService.swift
```

## 🚀 Release Process

### Version Management
- **Semantic versioning**: MAJOR.MINOR.PATCH
- **Build numbers**: Increment for each build
- **Release notes**: Document all changes

### App Store Preparation
- Update app metadata in `store/ios/`
- Generate screenshots using `fastlane snapshot`
- Test on multiple devices and iOS versions
- Verify all integrations work in production

## 🔒 Security & Privacy

### Data Protection
- Use Keychain for sensitive data
- Implement proper session management
- Follow Apple's privacy guidelines
- Include privacy controls in settings

### API Security
- Use HTTPS for all network requests
- Implement certificate pinning
- Handle authentication tokens securely
- Validate all user inputs

## 📊 Analytics & Monitoring

### Event Tracking
- Follow the analytics specification in `analytics_spec.md`
- Track user journeys, not just actions
- Respect user privacy preferences
- Test analytics in debug mode

### Performance Monitoring
- Monitor app launch time
- Track memory usage
- Monitor network performance
- Use Instruments for profiling

## 🐛 Bug Reports & Issues

### Reporting Bugs
1. Check if the issue already exists in Linear
2. Provide detailed reproduction steps
3. Include device/iOS version information
4. Add screenshots or screen recordings
5. Label with appropriate priority

### Issue Labels
- **bug**: Something is broken
- **enhancement**: New feature request
- **documentation**: Docs improvements
- **performance**: Performance improvements
- **security**: Security-related issues

## 📚 Resources

### Documentation
- [Swift Style Guide](https://google.github.io/swift/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)

### Tools
- [SwiftLint](https://github.com/realm/SwiftLint)
- [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## 🤝 Getting Help

- **Code questions**: Ask in team Slack #ios-development
- **Architecture decisions**: Discuss in Linear comments
- **Urgent issues**: Contact project lead directly

---

**Happy coding! 🚀**
