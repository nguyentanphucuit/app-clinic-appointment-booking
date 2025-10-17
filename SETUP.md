# 🛠️ Setup Guide

Complete setup instructions for the Clinic Appointment Booking app.

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. **Flutter SDK** (3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Follow platform-specific installation instructions

2. **Dart SDK** (3.0 or higher)
   - Comes bundled with Flutter

3. **IDE** (Choose one)
   - Visual Studio Code with Flutter extension
   - Android Studio with Flutter plugin
   - Xcode (for iOS development on macOS)

4. **Git**
   - For version control and cloning the repository

### Platform-Specific Requirements

#### For iOS Development
- macOS computer
- Xcode 14.0 or higher
- CocoaPods (for iOS dependencies)
- iOS Simulator or physical iOS device

#### For Android Development
- Android Studio
- Android SDK
- Android Emulator or physical Android device

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd clinic_appointment_booking
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will install all required packages:
- `provider` - State management
- `cached_network_image` - Image caching
- `intl` - Internationalization and formatting
- `flutter_svg` - SVG support
- `google_fonts` - Custom fonts

### 3. Verify Flutter Installation

```bash
flutter doctor
```

Ensure all checks pass. If there are any issues, follow the instructions provided by `flutter doctor`.

### 4. Run the App

#### On iOS Simulator (macOS only)
```bash
flutter run -d ios
```

#### On Android Emulator
```bash
flutter run -d android
```

#### On Physical Device
1. Connect your device via USB
2. Enable Developer Mode and USB Debugging (Android) or trust the computer (iOS)
3. Run:
```bash
flutter run
```

## Project Configuration

### Assets

The app uses remote images for avatars. If you want to use local assets:

1. Create asset directories:
```bash
mkdir -p assets/images
mkdir -p assets/icons
```

2. Add your images to these directories

3. Update image URLs in the provider files:
   - `lib/providers/user_provider.dart`
   - `lib/providers/doctor_provider.dart`

### Customization

#### Colors
Edit `lib/utils/app_colors.dart` to customize the color scheme:
```dart
static const Color primary = Color(0xFF0EA5E9); // Change this
```

#### Sample Data
Modify the sample data in:
- `lib/providers/user_provider.dart` - User profile
- `lib/providers/doctor_provider.dart` - Doctor list
- `lib/providers/appointment_provider.dart` - Appointments

## Troubleshooting

### Common Issues

#### 1. Dependencies Not Installing
```bash
flutter clean
flutter pub get
```

#### 2. iOS Build Issues
```bash
cd ios
pod install
pod update
cd ..
flutter clean
flutter run
```

#### 3. Android Build Issues
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

#### 4. Network Images Not Loading
- Check your internet connection
- Ensure the image URLs are accessible
- Check for any firewall or proxy settings

#### 5. Hot Reload Not Working
- Restart the app with `r` in the terminal
- Full restart with `R`
- Stop and restart the debug session

### Performance Optimization

#### 1. Enable Release Mode
```bash
flutter run --release
```

#### 2. Build APK (Android)
```bash
flutter build apk --release
```

#### 3. Build IPA (iOS)
```bash
flutter build ios --release
```

## Development Tips

### Hot Reload
- Press `r` in the terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

### Debug Tools
- Press `p` to show performance overlay
- Press `o` to toggle platform (iOS/Android)
- Press `w` to dump widget hierarchy

### IDE Setup

#### VS Code
Install these extensions:
- Flutter
- Dart
- Flutter Widget Snippets

#### Android Studio
Install these plugins:
- Flutter
- Dart

## Environment Variables

If you plan to use real APIs, create a `.env` file:

```env
API_BASE_URL=your_api_url
API_KEY=your_api_key
```

Then add to `.gitignore`:
```
.env
```

## Next Steps

1. Read [QUICKSTART.md](QUICKSTART.md) for a quick overview
2. Explore the codebase structure
3. Customize the app for your needs
4. Add real backend integration
5. Deploy to App Store / Play Store

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Cupertino Widgets](https://flutter.dev/docs/development/ui/widgets/cupertino)
- [Provider Package](https://pub.dev/packages/provider)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

## Support

If you encounter any issues:
1. Check the troubleshooting section
2. Search for similar issues in Flutter documentation
3. Create an issue in the repository

---

Happy coding! 🚀

