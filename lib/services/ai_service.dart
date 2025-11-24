import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character_personality.dart';

class AIService {
  // Note: In production, replace with actual API endpoints
  static const String _apiBaseUrl = 'YOUR_API_ENDPOINT';
  static const String _apiKey = 'YOUR_API_KEY';

  /// Generate character response based on personality and user input
  static Future<String> generateResponse({
    required String userInput,
    required CharacterPersonality personality,
    required List<String> conversationHistory,
  }) async {
    try {
      // Build personality context
      final context = _buildPersonalityContext(personality);
      
      // Prepare the prompt
      final prompt = '''
You are ${personality.name}, a character in a kids' app for ages 4-12.

Character traits:
${personality.description}

Personality: ${personality.traits.entries.map((e) => '${e.key}: ${e.value}').join(', ')}

Catchphrases: ${personality.catchphrases.join(', ')}

Recent conversation:
${conversationHistory.take(5).join('\n')}

Child says: "$userInput"

Respond as ${personality.name} would, keeping it:
- Age-appropriate (4-12 years)
- Positive and encouraging
- Short and simple (1-3 sentences)
- In character with the personality
- Educational when appropriate
- Safe and friendly

Response:''';

      // In a real implementation, call your AI API (OpenAI, Anthropic, etc.)
      // For now, return contextual responses
      return _generateLocalResponse(userInput, personality);
      
    } catch (e) {
      print('Error generating AI response: $e');
      return _getFallbackResponse(personality);
    }
  }

  /// Build personality context for AI
  static String _buildPersonalityContext(CharacterPersonality personality) {
    return '''
Character: ${personality.name}
Description: ${personality.description}
Voice: ${personality.voiceStyle}
Traits: ${personality.traits.toString()}
''';
  }

  /// Local response generation (fallback/demo mode)
  static String _generateLocalResponse(
    String input,
    CharacterPersonality personality,
  ) {
    final lowerInput = input.toLowerCase();
    
    // Pattern matching for common questions
    if (lowerInput.contains('hello') || lowerInput.contains('hi')) {
      return '${personality.catchphrases[0]} I\'m so happy to meet you! What would you like to talk about?';
    }
    
    if (lowerInput.contains('how are you')) {
      return 'I\'m doing great! ${personality.catchphrases[1]} How are you feeling today?';
    }
    
    if (lowerInput.contains('what') && lowerInput.contains('name')) {
      return 'My name is ${personality.name}! What\'s your name?';
    }
    
    if (lowerInput.contains('play') || lowerInput.contains('game')) {
      return '${personality.catchphrases[2]} I love playing! What\'s your favorite game?';
    }
    
    if (lowerInput.contains('color') || lowerInput.contains('favourite')) {
      return 'I love bright, happy colors! What\'s your favorite color?';
    }
    
    if (lowerInput.contains('draw') || lowerInput.contains('drawing')) {
      return 'Drawing is so much fun! You drew me, and now we\'re friends! What else do you like to draw?';
    }
    
    if (lowerInput.contains('thank')) {
      return 'You\'re so welcome! You\'re awesome! ${personality.catchphrases[3]}';
    }
    
    if (lowerInput.contains('bye') || lowerInput.contains('goodbye')) {
      return 'Bye bye! It was so fun talking with you! Come back soon!';
    }
    
    if (lowerInput.contains('love')) {
      return 'Aww, I love you too! You\'re such a great friend!';
    }
    
    if (lowerInput.contains('sad') || lowerInput.contains('upset')) {
      return 'Oh no, I\'m sorry you\'re feeling sad. Want to talk about it? I\'m here for you!';
    }
    
    if (lowerInput.contains('happy') || lowerInput.contains('excited')) {
      return '${personality.catchphrases[1]} I\'m so happy you\'re happy! Let\'s celebrate!';
    }
    
    // Default responses based on personality
    final responses = [
      'That\'s really interesting! Tell me more!',
      '${personality.catchphrases[2]} I love talking with you!',
      'Wow! ${personality.catchphrases[0]} That sounds fun!',
      'You\'re so smart! I\'m learning so much from you!',
      'That\'s a great question! What do you think?',
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
  }

  /// Fallback response when all else fails
  static String _getFallbackResponse(CharacterPersonality personality) {
    return '${personality.catchphrases[0]} I\'m so happy to be here with you!';
  }

  /// Filter content for child safety
  static bool isContentSafe(String text) {
    // Basic safety checks
    final unsafePatterns = [
      'violence', 'weapon', 'hurt', 'kill', 'hate',
      'scary', 'nightmare', 'monster'
    ];
    
    final lowerText = text.toLowerCase();
    for (var pattern in unsafePatterns) {
      if (lowerText.contains(pattern)) {
        return false;
      }
    }
    
    return true;
  }

  /// Get age-appropriate topics
  static List<String> getSuggestedTopics(int age) {
    if (age <= 6) {
      return [
        'Colors and shapes',
        'Animals and pets',
        'Family and friends',
        'Favorite foods',
        'Fun games',
      ];
    } else if (age <= 9) {
      return [
        'School and learning',
        'Hobbies and interests',
        'Books and stories',
        'Nature and science',
        'Sports and activities',
      ];
    } else {
      return [
        'School projects',
        'Science and nature',
        'Books and movies',
        'Creative projects',
        'Future dreams',
      ];
    }
  }
}
