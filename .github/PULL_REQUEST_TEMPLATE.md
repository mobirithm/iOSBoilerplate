## 📋 Pull Request Checklist

### Linear Issue
- [ ] Links to Linear issue: **MOB-X** (replace with actual issue number)
- [ ] Issue acceptance criteria met

### Code Quality
- [ ] Code follows Swift style guide
- [ ] SwiftLint passes without warnings
- [ ] SwiftFormat applied consistently
- [ ] No hardcoded strings (use localization)
- [ ] No magic numbers or hardcoded values
- [ ] Proper error handling implemented

### Testing
- [ ] Unit tests added/updated for new functionality
- [ ] UI tests added for critical user flows
- [ ] Manual testing completed on multiple devices
- [ ] Edge cases and error scenarios tested
- [ ] Performance impact considered

### Accessibility
- [ ] Accessibility labels added to interactive elements
- [ ] VoiceOver navigation tested
- [ ] Dynamic Type support verified
- [ ] Color contrast meets WCAG guidelines
- [ ] Accessibility identifiers added for UI tests

### Localization
- [ ] All user-facing strings use `NSLocalizedString` or `.localized`
- [ ] Strings added to `Localizable.strings` files
- [ ] RTL layout tested (if applicable)
- [ ] Pluralization rules implemented correctly

### Documentation
- [ ] Code comments added for complex logic
- [ ] README updated (if needed)
- [ ] API documentation updated
- [ ] Inline documentation for public interfaces

### Security & Privacy
- [ ] No sensitive data hardcoded
- [ ] Proper data validation implemented
- [ ] Privacy-sensitive features respect user preferences
- [ ] Security best practices followed

### Integration & Dependencies
- [ ] New dependencies justified and documented
- [ ] Third-party SDK integration tested
- [ ] Analytics events implemented (if applicable)
- [ ] Remote config flags considered

### App Store Compliance
- [ ] App Store guidelines compliance verified
- [ ] Age rating considerations reviewed
- [ ] Content policy compliance checked
- [ ] Subscription/purchase flows tested (if applicable)

## 📝 Description

### What does this PR do?
<!-- Provide a clear description of the changes -->

### How to test?
<!-- Step-by-step instructions for testing the changes -->

### Screenshots/Videos
<!-- Add screenshots or screen recordings for UI changes -->

### Breaking Changes
<!-- List any breaking changes and migration steps -->

## 🔗 Related Issues
<!-- Link to related Linear issues, GitHub issues, or documentation -->

## 📱 Testing Devices
<!-- List devices/simulators used for testing -->
- [ ] iPhone 16 Pro (iOS 18.x)
- [ ] iPhone SE (iOS 16.x)
- [ ] iPad (iOS 17.x)

## 🌍 Localization Testing
<!-- Check tested locales -->
- [ ] English (en)
- [ ] Turkish (tr)
- [ ] RTL languages (if applicable)

## 🎨 Design Review
- [ ] Matches design specifications
- [ ] Dark/light mode support
- [ ] Responsive layout on different screen sizes
- [ ] Animation and interaction feedback

---

### Reviewer Notes
<!-- Any specific areas you'd like reviewers to focus on -->

### Deployment Notes
<!-- Any special deployment considerations or configuration changes -->
