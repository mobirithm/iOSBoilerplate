# Google Sign-In Setup Guide

This guide explains how to set up Google Sign-In for the iOS Boilerplate project.

## Prerequisites

1. **Google Cloud Console Project** with Google Sign-In API enabled
2. **iOS App Configuration** in Google Cloud Console
3. **Xcode Project** with proper capabilities

## Step 1: Google Cloud Console Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the **Google Sign-In API**
4. Go to **Credentials** → **Create Credentials** → **OAuth 2.0 Client IDs**
5. Select **iOS** as application type
6. Enter your Bundle ID (e.g., `com.mobirithm.iOSBoilerplate`)
7. Download the `GoogleService-Info.plist` file

## Step 2: Add Google Sign-In SDK

### Via Swift Package Manager (Recommended)
1. In Xcode: `File` → `Add Package Dependencies...`
2. Enter URL: `https://github.com/google/GoogleSignIn-iOS`
3. Click `Add Package`
4. Select your target `iOSBoilerplate`

### Via CocoaPods (Alternative)
Add to your `Podfile`:
```ruby
pod 'GoogleSignIn'
```

## Step 3: Configure Info.plist

Add these keys to your `Info.plist`:

```xml
<key>GIDClientID</key>
<string>YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com</string>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.mobirithm.iOSBoilerplate</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.mobirithm.iOSBoilerplate</string>
        </array>
    </dict>
</array>
```

**Note:** Replace `YOUR_GOOGLE_CLIENT_ID` with the actual client ID from Google Cloud Console.

## Step 4: Update Entitlements

Your `iOSBoilerplate.entitlements` should already include:
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

## Step 5: Build and Test

1. Clean build folder: `Product` → `Clean Build Folder`
2. Build the project
3. Run on device or simulator

## Troubleshooting

### Common Issues

1. **"GIDClientID not found" warning**
   - Ensure `GIDClientID` is correctly added to `Info.plist`
   - Check that the client ID matches your Google Cloud Console

2. **Build errors with GoogleSignIn**
   - Clean build folder and rebuild
   - Ensure minimum iOS deployment target is 16.0+
   - Check that GoogleSignIn package is properly linked

3. **Sign-in not working on device**
   - Verify Bundle ID matches Google Cloud Console configuration
   - Check that URL scheme is properly configured
   - Ensure device has internet connection

### Testing

- **Simulator**: Google Sign-In may not work properly in simulator
- **Device**: Test on physical device for full functionality
- **Debug**: Check Xcode console for any error messages

## Security Notes

- Never commit your actual `GoogleService-Info.plist` to version control
- Use environment variables or secure configuration management for production
- Regularly rotate your OAuth client secrets

## Next Steps

After successful setup:
1. Test both Apple and Google Sign-In flows
2. Verify user data is properly stored in keychain
3. Check that sign-out works for both providers
4. Test the auth provider display in ProfileView
