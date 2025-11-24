# Complete Setup Guide 🚀

This guide will help you set up and run the Kids Character App on your development machine and deploy it to iOS and Android devices.

## Table of Contents
1. [Development Environment Setup](#development-environment-setup)
2. [Project Setup](#project-setup)
3. [Running on Android](#running-on-android)
4. [Running on iOS](#running-on-ios)
5. [AI Integration](#ai-integration)
6. [Testing](#testing)
7. [Building for Production](#building-for-production)
8. [Troubleshooting](#troubleshooting)

---

## Development Environment Setup

### 1. Install Flutter

#### Windows
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin
```

#### macOS
```bash
# Using Homebrew
brew install flutter

# Or download from https://flutter.dev/docs/get-started/install/macos
```

#### Linux
```bash
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
tar xf flutter_linux_3.24.0-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. Verify Flutter Installation
```bash
flutter doctor
```

This will check for:
- Flutter SDK
- Android toolchain
- Xcode (macOS only)
- Connected devices
- IDE plugins

### 3. Install Android Studio

1. Download from: https://developer.android.com/studio
2. Install Android SDK
3. Install Flutter and Dart plugins
4. Configure Android SDK path in Flutter:
   ```bash
   flutter config --android-sdk /path/to/android/sdk
   ```

### 4. Install Xcode (macOS only)

1. Download from Mac App Store
2. Install Command Line Tools:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```
3. Accept license:
   ```bash
   sudo xcodebuild -license accept
   ```
4. Install CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

---

## Project Setup

### 1. Navigate to Project Directory
```bash
cd /path/to/kids_character_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Project
```bash
flutter analyze
```

---

## Running on Android

### 1. Connect Android Device or Start Emulator

**Physical Device:**
- Enable Developer Options
- Enable USB Debugging
- Connect via USB

**Emulator:**
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>
```

### 2. Check Connected Devices
```bash
flutter devices
```

### 3. Run the App
```bash
flutter run
```

Or select device:
```bash
flutter run -d <device_id>
```

### 4. Hot Reload During Development
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

---

## Running on iOS

### 1. Open iOS Project in Xcode
```bash
open ios/Runner.xcworkspace
```

### 2. Configure Signing

1. Select "Runner" project
2. Go to "Signing & Capabilities"
3. Select your Team
4. Change Bundle Identifier if needed

### 3. Install CocoaPods Dependencies
```bash
cd ios
pod install
cd ..
```

### 4. Run on iOS Simulator
```bash
# List available simulators
flutter devices

# Run on simulator
flutter run -d <simulator_id>
```

### 5. Run on Physical iOS Device

1. Connect iPhone/iPad via USB
2. Trust computer on device
3. Run:
   ```bash
   flutter run
   ```

---

## AI Integration

### Option 1: OpenAI GPT

1. Get API key from: https://platform.openai.com/api-keys

2. Update `lib/services/ai_service.dart`:
```dart
static const String _apiBaseUrl = 'https://api.openai.com/v1/chat/completions';
static const String _apiKey = 'YOUR_OPENAI_API_KEY';

// In generateResponse method:
final response = await http.post(
  Uri.parse(_apiBaseUrl),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  },
  body: jsonEncode({
    'model': 'gpt-4',
    'messages': [
      {'role': 'system', 'content': context},
      {'role': 'user', 'content': prompt},
    ],
    'max_tokens': 150,
    'temperature': 0.8,
  }),
);

final data = jsonDecode(response.body);
return data['choices'][0]['message']['content'];
```

### Option 2: Google Gemini

1. Get API key from: https://makersuite.google.com/app/apikey

2. Update service:
```dart
static const String _apiBaseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';
static const String _apiKey = 'YOUR_GEMINI_API_KEY';

final response = await http.post(
  Uri.parse('$_apiBaseUrl?key=$_apiKey'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'contents': [{
      'parts': [{'text': prompt}]
    }],
    'generationConfig': {
      'temperature': 0.8,
      'maxOutputTokens': 150,
    },
  }),
);
```

### Option 3: Local Pattern Matching (Default)

The app uses local pattern matching by default - no API required!

---

## Testing

### 1. Run Unit Tests
```bash
flutter test
```

### 2. Test on Multiple Devices
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# All connected devices
flutter run -d all
```

### 3. Test Permissions

**Android:**
- Microphone access
- Storage access

**iOS:**
- Microphone access
- Speech recognition
- Photo library access

---

## Building for Production

### Android Release Build

1. **Configure signing:**

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=path/to/keystore.jks
```

2. **Build APK:**
```bash
flutter build apk --release
```

3. **Build App Bundle (recommended for Play Store):**
```bash
flutter build appbundle --release
```

4. **Output location:**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### iOS Release Build

1. **Archive in Xcode:**
```bash
flutter build ios --release
open ios/Runner.xcworkspace
```

2. **In Xcode:**
- Product → Archive
- Distribute App
- Choose distribution method

3. **Or build from command line:**
```bash
flutter build ipa --release
```

---

## Troubleshooting

### Common Issues

#### Flutter Doctor Issues
```bash
# Run doctor with verbose output
flutter doctor -v

# Accept Android licenses
flutter doctor --android-licenses
```

#### Dependencies Issues
```bash
# Clean and reinstall
flutter clean
flutter pub get

# For iOS
cd ios && pod install && cd ..
```

#### Build Errors

**Android:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

**iOS:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

#### Speech Recognition Not Working

1. Check permissions in manifest files
2. Test on physical device (some features don't work in simulator)
3. Ensure internet connection

#### Drawing Canvas Issues

1. Clear app data
2. Check device storage
3. Restart app

### Performance Issues

1. **Run in profile mode:**
```bash
flutter run --profile
```

2. **Analyze performance:**
```bash
flutter run --profile --trace-startup
```

3. **Reduce animations** if needed in code

---

## Development Tips

### Hot Reload
```bash
# In running app terminal
r  # Hot reload
R  # Hot restart
q  # Quit
```

### Debug Information
```bash
# Run with verbose logging
flutter run -v

# Run in debug mode
flutter run --debug
```

### Code Generation
```bash
# If you add code generation in future
flutter pub run build_runner build
```

### Update Dependencies
```bash
flutter pub upgrade
flutter pub outdated
```

---

## Next Steps

1. ✅ Set up development environment
2. ✅ Install dependencies
3. ✅ Run on emulator/simulator
4. ✅ Test on physical device
5. ✅ Configure AI integration (optional)
6. ✅ Build for production
7. ✅ Deploy to app stores

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Package Repository](https://pub.dev/)
- [Android Publishing Guide](https://flutter.dev/docs/deployment/android)
- [iOS Publishing Guide](https://flutter.dev/docs/deployment/ios)

---

**Happy Coding! 🎉**

If you encounter any issues not covered here, check the Flutter documentation or the specific package documentation.
