# Superwall Setup Guide

This guide explains how to set up Superwall for the iOS Boilerplate project to create paywalls and monetization flows.

## Prerequisites

1. **Superwall Account** with API key
2. **RevenueCat Integration** already working (✅ Complete)
3. **Xcode Project** with proper capabilities

## Step 1: Add Superwall SDK

### Via Swift Package Manager (Recommended)
1. In Xcode: `File` → `Add Package Dependencies...`
2. Enter URL: `https://github.com/superwall-me/Superwall-iOS`
3. Click `Add Package`
4. Select your target `iOSBoilerplate`

### Via CocoaPods (Alternative)
Add to your `Podfile`:
```ruby
pod 'SuperwallKit'
```

## Step 2: Configure Superwall

### Update SuperwallManager.swift
1. Open `iOSBoilerplate/Integrations/SuperwallManager.swift`
2. Replace `"YOUR_SUPERWALL_API_KEY"` with your actual API key:
```swift
Superwall.configure(apiKey: "YOUR_ACTUAL_API_KEY_HERE")
```

### Get Your API Key
1. Go to [Superwall Dashboard](https://superwall.com/dashboard)
2. Navigate to **Settings** → **API Keys**
3. Copy your API key

## Step 3: Configure Paywall Events

The app is pre-configured with these paywall events:

### **Onboarding Flow**
- **Event**: `onboarding_complete`
- **Trigger**: When user completes onboarding
- **Use Case**: First paywall presentation

### **Feature Gating**
- **Event**: `feature_locked_analytics`
- **Event**: `feature_locked_notifications`
- **Event**: `feature_locked_themes`
- **Trigger**: When user tries to access premium features

### **Custom Events**
- **Event**: `custom_demo_event`
- **Trigger**: Manual testing and custom flows

## Step 4: Create Paywall Templates in Superwall Dashboard

### **Template 1: Benefits Grid**
- **Layout**: Grid-based benefits showcase
- **Focus**: Feature comparison and value proposition
- **Best for**: Feature-locked paywalls

### **Template 2: Testimonial-Based**
- **Layout**: Social proof with customer testimonials
- **Focus**: Trust and credibility
- **Best for**: Onboarding completion

### **Template 3: Video Header**
- **Layout**: Video demonstration with CTA
- **Focus**: Product demonstration
- **Best for**: Complex feature explanations

## Step 5: Test the Integration

### **Demo Features**
1. **Run the app** and navigate to "Paywall Demo"
2. **Test Premium Features**:
   - Advanced Analytics (locked)
   - Smart Notifications (locked)
   - Custom Themes (locked)

3. **Test Paywall Triggers**:
   - Simulate Onboarding Complete
   - Trigger Feature Locked Paywall
   - Custom Paywall Event

### **Expected Behavior**
- ✅ Paywalls present when features are locked
- ✅ Analytics events logged to console
- ✅ RevenueCat integration works seamlessly
- ✅ User state properly managed

## Step 6: Customize Paywall Content

### **In Superwall Dashboard**
1. **Design**: Customize colors, fonts, and layouts
2. **Copy**: Update text and messaging
3. **Images**: Add your app's branding
4. **Products**: Connect with RevenueCat offerings

### **Localization**
- Support multiple languages
- RTL layout support
- Cultural adaptations

## Troubleshooting

### Common Issues

1. **"Superwall not configured" warning**
   - Ensure API key is set in SuperwallManager
   - Check that Superwall SDK is properly linked

2. **Paywalls not presenting**
   - Verify event names match Superwall dashboard
   - Check network connectivity
   - Ensure user is not already premium

3. **Analytics not working**
   - Check Xcode console for events
   - Verify delegate methods are called
   - Ensure proper event registration

### Testing Tips

- **Simulator**: Basic functionality works, but real paywalls require device
- **Device**: Full paywall experience with real App Store integration
- **Sandbox**: Test purchases without real money
- **Console**: Monitor all analytics events and errors

## Integration Points

### **With RevenueCat**
- ✅ Entitlement checking
- ✅ Purchase completion
- ✅ Subscription status
- ✅ Restore purchases

### **With Authentication**
- ✅ User identification
- ✅ Purchase attribution
- ✅ Cross-device sync

### **With Analytics** (Future - MOB-16)
- 📋 Paywall impressions
- 📋 Conversion tracking
- 📋 User journey analysis

## Next Steps

After Superwall setup:
1. **Test all paywall flows** thoroughly
2. **Customize paywall designs** in dashboard
3. **Set up A/B testing** for optimization
4. **Move to Analytics** (MOB-15-16) for complete tracking

## Security Notes

- Never commit your Superwall API key to version control
- Use environment variables for production
- Regularly rotate API keys
- Monitor usage and abuse

## Support Resources

- [Superwall Documentation](https://docs.superwall.com/)
- [Superwall Dashboard](https://superwall.com/dashboard)
- [iOS Integration Guide](https://docs.superwall.com/docs/ios)
- [RevenueCat Integration](https://docs.superwall.com/docs/revenuecat)
