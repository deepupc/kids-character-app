# Kids Character App 🎨✨

An interactive mobile application for kids aged 4-12 where they can draw their own characters, bring them to life, and have conversations with them!

## Features

### 🎨 Creative Drawing
- **Easy-to-use drawing canvas** with touch controls
- **Color palette** with 9 vibrant colors
- **Multiple brush sizes** (Small, Medium, Large)
- **Eraser tool** for corrections
- **Clear canvas** option to start over

### 🎭 Character Personalities
The app includes 6 unique character personalities inspired by popular kids' shows:

1. **Playful Pup** 🐕 - Fun-loving and energetic (Bluey-inspired)
2. **Happy Piggy** 🐷 - Cheerful and enthusiastic (Peppa Pig-inspired)
3. **Magical Friend** ✨ - Creative and crafty (Gabby's Dollhouse-inspired)
4. **Rescue Hero** 🦸 - Brave and helpful (Paw Patrol-inspired)
5. **Curious Explorer** 🔍 - Inquisitive and educational
6. **Gentle Friend** 🤗 - Kind and nurturing

### 💬 Interactive Conversations
- **Voice recognition** - Kids can talk to their characters
- **Text-to-speech** - Characters respond with unique voices
- **AI-powered responses** - Smart, age-appropriate conversations
- **Multiple expressions** - Characters show emotions (happy, excited, surprised, etc.)

### ✨ Character Animation
- **Bouncing animation** - Characters move naturally
- **Facial expressions** - Shows current mood
- **Talking animation** - Mouth moves while speaking
- **Expression transitions** - Smooth emotional changes

## Technical Details

### Built With
- **Flutter 3.24.0** - Cross-platform framework
- **Dart** - Programming language
- **Flutter TTS** - Text-to-speech functionality
- **Speech to Text** - Voice recognition
- **Custom Canvas** - Drawing implementation

### Project Structure
```
lib/
├── models/              # Data models
│   ├── character_personality.dart
│   └── drawing_data.dart
├── screens/             # App screens
│   ├── home_screen.dart
│   ├── drawing_screen.dart
│   └── character_screen.dart
├── widgets/             # Reusable widgets
│   ├── drawing_canvas.dart
│   └── character_selector.dart
├── services/            # Business logic
│   ├── ai_service.dart
│   ├── speech_service.dart
│   └── animation_service.dart
└── main.dart           # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK 3.1.0 or higher
- Dart SDK 3.1.0 or higher
- Android Studio / Xcode (for mobile deployment)
- Physical device or emulator

### Installation

1. **Clone or extract the project**
   ```bash
   cd /path/to/kids_character_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run
   
   # For iOS
   flutter run -d ios
   
   # For specific device
   flutter devices
   flutter run -d <device_id>
   ```

### Permissions Required

#### Android
- `INTERNET` - For AI services (future enhancement)
- `RECORD_AUDIO` - For voice recognition
- `WRITE_EXTERNAL_STORAGE` - For saving drawings
- `READ_EXTERNAL_STORAGE` - For loading drawings

#### iOS
- `NSMicrophoneUsageDescription` - Microphone access
- `NSSpeechRecognitionUsageDescription` - Speech recognition
- `NSPhotoLibraryUsageDescription` - Photo library access
- `NSPhotoLibraryAddUsageDescription` - Saving to photo library

## How to Use

1. **Launch the app** - Tap "Start Drawing" on the home screen
2. **Draw your character** - Use colors and brushes to create
3. **Choose personality** - Select from 6 character types
4. **Bring to life** - Watch your drawing become animated
5. **Chat and play** - Talk with your character using voice or text

## AI Integration (Optional)

The app currently uses local pattern-matching for responses. To integrate real AI:

1. **Update `lib/services/ai_service.dart`**
2. **Add your API credentials**:
   ```dart
   static const String _apiBaseUrl = 'YOUR_API_ENDPOINT';
   static const String _apiKey = 'YOUR_API_KEY';
   ```
3. **Uncomment API call code** in `generateResponse()` method
4. **Add HTTP package configuration** if needed

### Supported AI Services
- OpenAI GPT-4
- Anthropic Claude
- Google Gemini
- Any compatible LLM API

## Safety Features

- **Content filtering** - Blocks inappropriate topics
- **Age-appropriate responses** - Tailored for 4-12 year olds
- **No data storage** - Conversations not saved (initial version)
- **Kid-friendly UI** - Large buttons, simple navigation
- **Parental guidance** - Recommended supervision for younger kids

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS IPA
```bash
flutter build ios --release
```

## Troubleshooting

### Speech Recognition Not Working
- Check microphone permissions
- Ensure device has internet connection
- Try restarting the app

### Drawing Canvas Issues
- Clear app cache
- Restart the app
- Check available storage space

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## Future Enhancements

- [ ] Save and load multiple characters
- [ ] Share characters with friends
- [ ] More personality types
- [ ] Mini-games with characters
- [ ] Parent dashboard
- [ ] Multi-language support
- [ ] Character customization options
- [ ] Story mode with character adventures
- [ ] Background music and sound effects
- [ ] Cloud sync for characters

## Requirements

- **Minimum Android:** Android 6.0 (API 23)
- **Minimum iOS:** iOS 12.0
- **Storage:** 100MB free space
- **RAM:** 2GB minimum

## License

This project is built for educational and entertainment purposes for kids aged 4-12.

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review Flutter documentation
3. Check device compatibility

## Credits

**Developed with ❤️ for kids who love to create and imagine!**

Inspired by popular children's shows:
- Bluey
- Peppa Pig
- Gabby's Dollhouse
- Paw Patrol

---

**Have fun creating and chatting with your characters! 🎨✨💬**
