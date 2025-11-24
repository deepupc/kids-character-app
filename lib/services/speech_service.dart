import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/character_personality.dart';

class SpeechService {
  static final FlutterTts _flutterTts = FlutterTts();
  static final stt.SpeechToText _speechToText = stt.SpeechToText();
  static bool _isInitialized = false;

  /// Initialize speech services
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize TTS
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.4); // Slower for kids
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.2); // Slightly higher pitch for character

      // Initialize Speech Recognition
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) => print('Speech recognition status: $status'),
      );

      print('Speech services initialized: $_isInitialized');
    } catch (e) {
      print('Error initializing speech services: $e');
    }
  }

  /// Text-to-Speech with personality-based voice
  static Future<void> speak({
    required String text,
    required CharacterPersonality personality,
  }) async {
    try {
      // Adjust voice parameters based on personality
      await _configureVoiceForPersonality(personality);
      
      // Speak the text
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  /// Configure TTS voice based on character personality
  static Future<void> _configureVoiceForPersonality(
    CharacterPersonality personality,
  ) async {
    // Adjust speech rate based on personality
    double speechRate = 0.4; // Default for kids
    if (personality.traits['energy'] == 'very high') {
      speechRate = 0.5; // Faster for energetic characters
    } else if (personality.traits['calmness'] == 'very high') {
      speechRate = 0.35; // Slower for calm characters
    }

    // Adjust pitch based on personality
    double pitch = 1.2; // Default slightly high
    if (personality.id == 'happy_piggy') {
      pitch = 1.3; // Higher for pig-like character
    } else if (personality.id == 'rescue_hero') {
      pitch = 1.0; // Lower for heroic character
    } else if (personality.id == 'gentle_friend') {
      pitch = 1.15; // Softer pitch
    }

    await _flutterTts.setSpeechRate(speechRate);
    await _flutterTts.setPitch(pitch);
  }

  /// Stop speaking
  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Speech-to-Text: Listen to child's voice
  static Future<String?> listen() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (!_speechToText.isAvailable) {
        print('Speech recognition not available');
        return null;
      }

      String recognizedText = '';
      
      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 3),
        partialResults: false,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );

      // Wait for recognition to complete
      await Future.delayed(Duration(seconds: 11));

      return recognizedText.isNotEmpty ? recognizedText : null;
    } catch (e) {
      print('Error listening: $e');
      return null;
    }
  }

  /// Check if speech recognition is available
  static Future<bool> isSpeechAvailable() async {
    return await _speechToText.initialize();
  }

  /// Stop listening
  static Future<void> stopListening() async {
    await _speechToText.stop();
  }

  /// Get available languages
  static Future<List<stt.LocaleName>> getAvailableLanguages() async {
    return await _speechToText.locales();
  }

  /// Set TTS language
  static Future<void> setLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
  }

  /// Speak with emotion (using SSML if supported)
  static Future<void> speakWithEmotion({
    required String text,
    required String emotion,
    required CharacterPersonality personality,
  }) async {
    await _configureVoiceForPersonality(personality);

    // Adjust parameters based on emotion
    switch (emotion) {
      case 'excited':
        await _flutterTts.setSpeechRate(0.55);
        await _flutterTts.setPitch(1.4);
        break;
      case 'sad':
        await _flutterTts.setSpeechRate(0.3);
        await _flutterTts.setPitch(0.9);
        break;
      case 'surprised':
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setPitch(1.5);
        break;
      case 'calm':
        await _flutterTts.setSpeechRate(0.35);
        await _flutterTts.setPitch(1.1);
        break;
      default:
        await _configureVoiceForPersonality(personality);
    }

    await _flutterTts.speak(text);
  }

  /// Play character catchphrase
  static Future<void> playCatchphrase(CharacterPersonality personality) async {
    final catchphrase = personality.catchphrases[
      DateTime.now().millisecond % personality.catchphrases.length
    ];
    
    await speakWithEmotion(
      text: catchphrase,
      emotion: 'excited',
      personality: personality,
    );
  }
}
