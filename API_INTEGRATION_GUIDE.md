# API Integration Guide 🤖

This guide explains how to integrate various AI APIs into the Kids Character App for more advanced conversational capabilities.

## Current Implementation

By default, the app uses **local pattern-matching** for responses. This means:
- ✅ No API required
- ✅ Works offline
- ✅ No costs
- ✅ Privacy-friendly (no data sent externally)
- ❌ Limited conversation variety
- ❌ Can't handle complex questions

## AI API Integration Options

### Option 1: OpenAI GPT-4 (Recommended)

**Best for:** Most versatile, excellent with kids' content

#### Step 1: Get API Key
1. Visit: https://platform.openai.com/api-keys
2. Create an account
3. Generate new API key
4. Copy the key (starts with `sk-...`)

#### Step 2: Update Code

Open `lib/services/ai_service.dart` and replace the constants:

```dart
static const String _apiBaseUrl = 'https://api.openai.com/v1/chat/completions';
static const String _apiKey = 'sk-YOUR_OPENAI_API_KEY_HERE';
```

Then replace the `generateResponse` method:

```dart
static Future<String> generateResponse({
  required String userInput,
  required CharacterPersonality personality,
  required List<String> conversationHistory,
}) async {
  try {
    final context = _buildPersonalityContext(personality);
    
    final messages = [
      {
        'role': 'system',
        'content': '''You are ${personality.name}, a character in a kids' app for ages 4-12.
$context

Rules:
- Keep responses short (1-3 sentences)
- Be age-appropriate and positive
- Stay in character
- Be encouraging and friendly
- Avoid scary or negative topics'''
      },
      ...conversationHistory.take(6).map((msg) => {
        'role': msg.startsWith('You:') ? 'user' : 'assistant',
        'content': msg.split(': ').last,
      }),
      {'role': 'user', 'content': userInput}
    ];

    final response = await http.post(
      Uri.parse(_apiBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': messages,
        'max_tokens': 150,
        'temperature': 0.8,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return _getFallbackResponse(personality);
    }
  } catch (e) {
    print('Error: $e');
    return _getFallbackResponse(personality);
  }
}
```

#### Cost Estimates:
- GPT-4: ~$0.03 per 1K tokens (~500 words)
- GPT-3.5-Turbo: ~$0.002 per 1K tokens (cheaper alternative)

---

### Option 2: Google Gemini (Free Tier Available)

**Best for:** Free tier, good performance

#### Step 1: Get API Key
1. Visit: https://makersuite.google.com/app/apikey
2. Create API key
3. Copy the key

#### Step 2: Update Code

```dart
static const String _apiBaseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';
static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';

static Future<String> generateResponse({
  required String userInput,
  required CharacterPersonality personality,
  required List<String> conversationHistory,
}) async {
  try {
    final context = _buildPersonalityContext(personality);
    
    final prompt = '''$context

Recent conversation:
${conversationHistory.take(5).join('\n')}

Child says: "$userInput"

Respond as ${personality.name} in 1-3 short sentences:''';

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
          'topP': 0.95,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_ONLY_HIGH'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_ONLY_HIGH'
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return _getFallbackResponse(personality);
    }
  } catch (e) {
    print('Error: $e');
    return _getFallbackResponse(personality);
  }
}
```

#### Cost:
- Free tier: 60 requests per minute
- Perfect for personal use and testing

---

### Option 3: Anthropic Claude

**Best for:** Very safe for kids, excellent content filtering

#### Step 1: Get API Key
1. Visit: https://console.anthropic.com/
2. Create account and get API key

#### Step 2: Update Code

```dart
static const String _apiBaseUrl = 'https://api.anthropic.com/v1/messages';
static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY_HERE';

static Future<String> generateResponse({
  required String userInput,
  required CharacterPersonality personality,
  required List<String> conversationHistory,
}) async {
  try {
    final context = _buildPersonalityContext(personality);
    
    final response = await http.post(
      Uri.parse(_apiBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-haiku-20240307',
        'max_tokens': 150,
        'messages': [
          {
            'role': 'user',
            'content': '''$context

Child says: "$userInput"

Respond as ${personality.name} in 1-3 friendly sentences for a kid aged 4-12.'''
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'][0]['text'];
    } else {
      return _getFallbackResponse(personality);
    }
  } catch (e) {
    return _getFallbackResponse(personality);
  }
}
```

---

## Security Best Practices

### 1. Never Hardcode API Keys

**BAD:**
```dart
static const String _apiKey = 'sk-abc123...'; // Don't do this!
```

**GOOD - Use Environment Variables:**

Create `.env` file (add to .gitignore):
```
OPENAI_API_KEY=sk-your-key-here
GEMINI_API_KEY=your-key-here
```

Add package to `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

Load in code:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(KidsCharacterApp());
}

// In ai_service.dart:
static final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
```

### 2. Use Backend Proxy (Production)

For production apps, create a backend server:

```
Mobile App → Your Backend Server → AI API
```

Benefits:
- Hide API keys
- Add rate limiting
- Content filtering
- Usage monitoring
- Cost control

---

## Content Safety

### Add Content Filtering

```dart
static Future<String> generateResponse({
  required String userInput,
  required CharacterPersonality personality,
  required List<String> conversationHistory,
}) async {
  // Check input safety
  if (!isContentSafe(userInput)) {
    return 'Let\'s talk about something fun and positive! What do you like to do?';
  }
  
  // ... generate response ...
  
  // Check output safety
  if (!isContentSafe(response)) {
    return _getFallbackResponse(personality);
  }
  
  return response;
}
```

### Enhanced Safety Checks

```dart
static bool isContentSafe(String text) {
  final lowerText = text.toLowerCase();
  
  // Block inappropriate content
  final blockedWords = [
    'violence', 'weapon', 'gun', 'knife',
    'hate', 'hurt', 'kill', 'death',
    'scary', 'nightmare', 'monster',
    // Add more as needed
  ];
  
  for (var word in blockedWords) {
    if (lowerText.contains(word)) {
      return false;
    }
  }
  
  return true;
}
```

---

## Rate Limiting

Add rate limiting to avoid excessive API costs:

```dart
class RateLimiter {
  static DateTime? _lastRequestTime;
  static int _requestCount = 0;
  static const int maxRequestsPerMinute = 10;
  
  static Future<bool> canMakeRequest() async {
    final now = DateTime.now();
    
    if (_lastRequestTime == null || 
        now.difference(_lastRequestTime!) > Duration(minutes: 1)) {
      _requestCount = 0;
      _lastRequestTime = now;
    }
    
    if (_requestCount >= maxRequestsPerMinute) {
      return false;
    }
    
    _requestCount++;
    return true;
  }
}

// In generateResponse:
if (!await RateLimiter.canMakeRequest()) {
  return 'Wow, you\'re chatty! Let\'s take a little break. 😊';
}
```

---

## Error Handling

```dart
static Future<String> generateResponse({
  required String userInput,
  required CharacterPersonality personality,
  required List<String> conversationHistory,
}) async {
  try {
    // API call here...
    
  } on SocketException {
    return 'Oops! I can\'t connect right now. Check your internet! 📡';
  } on TimeoutException {
    return 'That took too long! Let\'s try again! ⏰';
  } on HttpException {
    return 'Something went wrong! But I\'m still here! 😊';
  } catch (e) {
    print('Unexpected error: $e');
    return _getFallbackResponse(personality);
  }
}
```

---

## Testing AI Integration

### 1. Test with Mock Responses

```dart
static bool _isTestMode = false; // Set to true for testing

static Future<String> generateResponse(...) async {
  if (_isTestMode) {
    await Future.delayed(Duration(seconds: 1)); // Simulate API delay
    return 'Test response from ${personality.name}!';
  }
  
  // Real API call...
}
```

### 2. Monitor API Usage

Add logging:

```dart
static int _apiCallCount = 0;
static double _totalCost = 0.0;

static void _logAPICall(int tokens) {
  _apiCallCount++;
  _totalCost += (tokens / 1000) * 0.03; // GPT-4 pricing
  print('API Calls: $_apiCallCount, Cost: \$${_totalCost.toStringAsFixed(4)}');
}
```

---

## Recommended Setup for Production

1. **Use Google Gemini** for free tier during development
2. **Switch to OpenAI GPT-3.5-Turbo** for production (cost-effective)
3. **Implement backend proxy** to hide API keys
4. **Add rate limiting** (10 requests/minute per user)
5. **Cache common responses** to reduce API calls
6. **Enable content filtering** on both input and output
7. **Monitor usage and costs** regularly

---

## Cost Optimization

### 1. Cache Common Responses

```dart
static final Map<String, String> _responseCache = {};

static String? _getCachedResponse(String input) {
  final key = input.toLowerCase().trim();
  return _responseCache[key];
}

static void _cacheResponse(String input, String response) {
  final key = input.toLowerCase().trim();
  _responseCache[key] = response;
}
```

### 2. Use Cheaper Models

- GPT-3.5-Turbo: 10x cheaper than GPT-4
- Gemini Pro: Free tier available
- Claude Haiku: Fast and affordable

### 3. Reduce Token Usage

```dart
'max_tokens': 100, // Instead of 150
conversationHistory.take(4), // Instead of 6
```

---

## Need Help?

- OpenAI: https://platform.openai.com/docs
- Google Gemini: https://ai.google.dev/docs
- Anthropic: https://docs.anthropic.com/

---

**Remember:** Start with local responses, add AI when needed! 🚀
