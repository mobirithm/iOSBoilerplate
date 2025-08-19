# iOS Boilerplate (SwiftUI)

[![iOS CI](https://github.com/mobirithm/iOSBoilerplate/actions/workflows/ios-ci.yml/badge.svg)](https://github.com/mobirithm/iOSBoilerplate/actions/workflows/ios-ci.yml)
[![Swift Version](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![iOS Version](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A production-ready iOS boilerplate built in SwiftUI for rapid consumer app development. This template includes authentication, monetization, analytics, notifications, and internationalization features out of the box.

## 🎯 Project Goals

- **Speed**: Launch new apps in weeks, not months
- **Consistency**: Standardized architecture and integrations
- **Monetization-first**: Built-in paywalls and subscription management
- **Growth-ready**: Analytics, A/B testing, and push notifications
- **Scalable**: Easy to extend for different app concepts

## 📱 Features

### Core Features
- ✅ **Project Structure**: Modular architecture with clean separation
- 🔐 **Authentication**: Apple Sign-In + Google Sign-In + Guest mode
- 💰 **Monetization**: RevenueCat subscriptions + Superwall paywalls
- 📊 **Analytics**: Mixpanel + Firebase Analytics with privacy controls
- 🔔 **Notifications**: Push notifications with deep linking
- 🎨 **Design System**: Dark/light theme + reusable components
- 🌍 **Internationalization**: Multi-language support with RTL
- 🔗 **Deep Links**: Universal Links routing

### Demo App
- 📝 **Wellness Tracker**: Sample app demonstrating premium features
- 🏆 **Habit Tracking**: Create habits, track streaks, set reminders
- 💎 **Premium Gating**: Unlimited habits and insights behind paywall

## 🛠 Prerequisites

- **Xcode 15.0+**
- **iOS 16.0+** deployment target
- **macOS 13.0+** for development
- **Apple Developer Account** (for device testing and App Store)

## 🚀 Getting Started

### 1. Clone and Setup
```bash
git clone <repository-url>
cd ios-template
```

### 2. Open in Xcode
```bash
open iOSBoilerplate.xcodeproj
```

### 3. Build and Run
1. Select your target device or simulator
2. Press `Cmd + R` to build and run
3. The app should launch showing the home screen with version info

### 4. Development Team Setup
1. In Xcode, select the project in the navigator
2. Under "Signing & Capabilities", select your development team
3. Update the bundle identifier if needed: `com.yourcompany.iOSBoilerplate`

## 📁 Project Structure

```
iOSBoilerplate/
├── App/                    # App entry point and main views
│   ├── iOSBoilerplateApp.swift
│   └── ContentView.swift
├── Core/                   # Core utilities and managers
├── Features/               # Feature modules (Auth, Wellness, etc.)
├── DesignSystem/          # Design tokens and reusable components
├── Integrations/          # Third-party service integrations
├── Resources/             # Assets, localizations, configurations
└── Tests/                 # Unit and UI tests
```

## 🔧 Configuration

### Bundle Identifier
Update the bundle identifier in the Xcode project settings:
- Current: `com.mobirithm.iOSBoilerplate`
- Change to: `com.yourcompany.yourapp`

### App Information
Update app metadata in the project settings:
- **Display Name**: Your app name
- **Version**: Semantic versioning (1.0.0)
- **Build Number**: Increment for each build

## 📋 Development Roadmap

The project follows a structured development plan with 11 main tasks:

1. ✅ **MOB-5**: Project skeleton and folder structure
2. **MOB-6**: Code quality tools (SwiftLint, pre-commit hooks)
3. **MOB-7**: CI/CD pipeline (GitHub Actions)
4. **MOB-8**: Design tokens and theming system
5. **MOB-9**: Reusable UI components
6. **MOB-10**: Internationalization framework
7. **MOB-11**: Apple Sign-In integration
8. **MOB-12**: Google Sign-In integration
9. **MOB-13**: RevenueCat monetization
10. **MOB-14**: Superwall paywall system
11. **MOB-15-23**: Analytics, notifications, demo app, and compliance

## 🤝 Contributing

See `CONTRIBUTING.md` for development guidelines, coding standards, and pull request process.

## 📄 License

This project is proprietary to Mobirithm. All rights reserved.

---

**Built with ❤️ by the Mobirithm Dev Team**
