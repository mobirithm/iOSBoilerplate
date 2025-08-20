# Superwall + RevenueCat Integration Guide

## Overview

This guide explains how to integrate Superwall paywalls with RevenueCat subscriptions for a complete monetization solution.

## How It Works

### 1. **Superwall** handles:
- Paywall presentation and UI
- A/B testing different paywall variants
- Conversion optimization
- Analytics and insights

### 2. **RevenueCat** handles:
- Subscription management
- Entitlement tracking
- Receipt validation
- Cross-platform sync

### 3. **Integration Benefits**:
- Automatic entitlement checking before showing paywalls
- Seamless user experience
- Better conversion rates
- Comprehensive analytics

## Setup

### 1. **Connect RevenueCat to Superwall**

```swift
// In iOSBoilerplateApp.swift
#if canImport(SuperwallKit)
    // Configure Superwall
    SuperwallManager.shared.configure()
    
    // Connect RevenueCat manager to Superwall
    SuperwallManager.shared.revenueCatManager = revenueCat
#endif
```

### 2. **Use Entitlement-Aware Paywall Presentation**

```swift
// Check if user has access
if superwallManager.hasAccessToFeature(.featureLockedAnalytics) {
    // User has access, show feature
    showAnalyticsFeature()
} else {
    // User doesn't have access, show paywall
    superwallManager.presentPaywallWithEntitlementCheck(for: .featureLockedAnalytics)
}
```

## Usage Examples

### 1. **Feature Gating with Paywall**

```swift
struct PremiumFeatureView: View {
    @EnvironmentObject var superwallManager: SuperwallManager
    
    var body: some View {
        Button("Access Premium Feature") {
            superwallManager.presentPaywallWithEntitlementCheck(for: .featureLockedPremium)
        }
    }
}
```

### 2. **Conditional Paywall Display**

```swift
// Only show paywall if user doesn't have access
superwallManager.presentPaywallIfNeeded(for: .featureLockedThemes)
```

### 3. **Custom Placement Keys**

```swift
// Use your exact Superwall placement key
superwallManager.presentPaywall(identifier: "your_custom_placement_key")
```

## Superwall Dashboard Setup

### 1. **Create Placements**
- Go to Superwall Dashboard → Placements
- Create placements matching your PaywallEvent enum:
  - `onboarding_complete`
  - `feature_locked_analytics`
  - `feature_locked_notifications`
  - `feature_locked_themes`
  - `feature_locked_premium`
  - `custom_demo_event`

### 2. **Create Paywalls**
- Design paywalls with your branding
- Set pricing and products
- Connect to RevenueCat products

### 3. **Assign Placements to Paywalls**
- Link each placement to an active paywall
- Set rules (e.g., "Always show paywall" for testing)

## RevenueCat Setup

### 1. **Products Configuration**
```swift
// In RevenueCatManager.swift
let products = [
    "pro_monthly": "Monthly Pro Subscription",
    "pro_yearly": "Yearly Pro Subscription"
]
```

### 2. **Entitlements**
- `pro`: Access to all premium features
- `basic`: Limited access

### 3. **Product Mapping**
- Map RevenueCat products to Superwall paywall products
- Ensure product IDs match between platforms

## Testing

### 1. **Sandbox Testing**
- Use RevenueCat sandbox environment
- Test with sandbox Apple accounts
- Verify paywall presentation

### 2. **Debug Mode**
```swift
// Enable debug logging
print("RevenueCat Pro Status: \(revenueCat.isPro)")
print("Superwall Configured: \(superwallManager.isConfigured)")
```

### 3. **Common Issues**
- **Paywall not showing**: Check placement key matches exactly
- **Entitlement not updating**: Verify RevenueCat webhook setup
- **Products not loading**: Check product IDs match between platforms

## Best Practices

### 1. **User Experience**
- Always check entitlements before showing paywalls
- Provide clear upgrade paths
- Handle edge cases gracefully

### 2. **Analytics**
- Track paywall presentation events
- Monitor conversion rates
- A/B test different paywall variants

### 3. **Error Handling**
- Graceful fallbacks when paywalls fail
- User-friendly error messages
- Retry mechanisms for network issues

## Complete Flow Example

```swift
class FeatureManager: ObservableObject {
    @Published var isPremiumFeatureUnlocked = false
    
    func unlockPremiumFeature() {
        // Check if user already has access
        if superwallManager.hasAccessToFeature(.featureLockedPremium) {
            isPremiumFeatureUnlocked = true
            return
        }
        
        // Show paywall to unlock feature
        superwallManager.presentPaywallWithEntitlementCheck(for: .featureLockedPremium)
    }
}
```

## Troubleshooting

### 1. **Paywall Not Appearing**
- Verify placement key matches exactly
- Check Superwall configuration
- Ensure paywall is active in dashboard

### 2. **Entitlements Not Updating**
- Check RevenueCat webhook configuration
- Verify product mapping
- Test with sandbox accounts

### 3. **Integration Issues**
- Ensure both managers are properly initialized
- Check delegate connections
- Verify API keys are correct

## Next Steps

1. **Create your paywalls** in Superwall dashboard
2. **Set up products** in RevenueCat
3. **Test the integration** with sandbox accounts
4. **Monitor analytics** and optimize conversion rates
5. **A/B test** different paywall variants

This integration provides a powerful foundation for monetizing your app with both subscription management and optimized paywall presentation.
