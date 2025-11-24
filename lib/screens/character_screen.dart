import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/drawing_data.dart';
import '../models/character_personality.dart';
import '../services/speech_service.dart';
import '../services/ai_service.dart';
import '../services/animation_service.dart';

class CharacterScreen extends StatefulWidget {
  final DrawingData drawingData;
  final CharacterPersonality personality;
  final ui.Image characterImage;

  const CharacterScreen({
    Key? key,
    required this.drawingData,
    required this.personality,
    required this.characterImage,
  }) : super(key: key);

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _talkingController;
  late Animation<double> _bounceAnimation;

  CharacterExpression currentExpression = CharacterExpression.happy;
  List<String> conversationHistory = [];
  TextEditingController messageController = TextEditingController();
  bool isListening = false;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSpeech();
    _greetUser();
  }

  void _initializeAnimations() {
    _bounceController = AnimationService.createBounceAnimation(this);
    _talkingController = AnimationService.createTalkingAnimation(this);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _bounceController.forward();
  }

  void _initializeSpeech() async {
    await SpeechService.initialize();
  }

  void _greetUser() async {
    await Future.delayed(Duration(seconds: 1));
    final greeting =
        'Hello! I\'m ${widget.personality.name}! ${widget.personality.catchphrases[0]} Thanks for creating me! What\'s your name?';

    setState(() {
      conversationHistory.add('${widget.personality.name}: $greeting');
      currentExpression = CharacterExpression.excited;
    });

    await _speakMessage(greeting);

    // Return to happy expression
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      currentExpression = CharacterExpression.happy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.personality.name),
            SizedBox(width: 8),
            Text(
              _getPersonalityEmoji(widget.personality.id),
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        backgroundColor: _parseColor(widget.personality.colorScheme),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _parseColor(widget.personality.colorScheme).withOpacity(0.2),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Character display with animation
            Expanded(
              flex: 2,
              child: Center(
                child: AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_bounceAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CustomPaint(
                        painter: CharacterPainter(
                          image: widget.characterImage,
                          expression: currentExpression,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Expression indicator
            _buildExpressionIndicator(),

            // Conversation history
            Expanded(
              flex: 1,
              child: _buildConversationView(),
            ),

            // Input area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpressionIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _parseColor(widget.personality.colorScheme).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Feeling: ${currentExpression.name} ${_getExpressionEmoji(currentExpression)}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _parseColor(widget.personality.colorScheme),
        ),
      ),
    );
  }

  Widget _buildConversationView() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: conversationHistory.isEmpty
          ? Center(
              child: Text(
                'Start chatting with ${widget.personality.name}! 💬',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              itemCount: conversationHistory.length,
              itemBuilder: (context, index) {
                final message = conversationHistory[index];
                final isCharacter = message.startsWith(widget.personality.name);

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Align(
                    alignment:
                        isCharacter ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCharacter
                            ? _parseColor(widget.personality.colorScheme)
                                .withOpacity(0.2)
                            : Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Microphone button
          IconButton(
            onPressed: isListening ? null : _startListening,
            icon: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: isListening ? Colors.red : Colors.blue,
              size: 32,
            ),
          ),

          // Text input
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (text) => _sendMessage(text),
            ),
          ),

          SizedBox(width: 8),

          // Send button
          IconButton(
            onPressed: () => _sendMessage(messageController.text),
            icon: Icon(Icons.send, color: Colors.blue, size: 32),
          ),
        ],
      ),
    );
  }

  Future<void> _startListening() async {
    setState(() {
      isListening = true;
      currentExpression = CharacterExpression.thinking;
    });

    final recognizedText = await SpeechService.listen();

    setState(() {
      isListening = false;
    });

    if (recognizedText != null && recognizedText.isNotEmpty) {
      await _sendMessage(recognizedText);
    } else {
      setState(() {
        currentExpression = CharacterExpression.happy;
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    setState(() {
      conversationHistory.add('You: $message');
      currentExpression = CharacterExpression.thinking;
    });

    messageController.clear();

    // Generate AI response
    final response = await AIService.generateResponse(
      userInput: message,
      personality: widget.personality,
      conversationHistory: conversationHistory,
    );

    // Add character response
    setState(() {
      conversationHistory.add('${widget.personality.name}: $response');
      currentExpression = CharacterExpression.talking;
    });

    // Speak the response
    await _speakMessage(response);

    // Return to happy expression
    setState(() {
      currentExpression = CharacterExpression.happy;
    });
  }

  Future<void> _speakMessage(String message) async {
    setState(() {
      isSpeaking = true;
      currentExpression = CharacterExpression.talking;
      _talkingController.repeat();
    });

    await SpeechService.speak(
      text: message,
      personality: widget.personality,
    );

    setState(() {
      isSpeaking = false;
      _talkingController.stop();
    });
  }

  String _getExpressionEmoji(CharacterExpression expression) {
    switch (expression) {
      case CharacterExpression.happy:
        return '😊';
      case CharacterExpression.excited:
        return '🤩';
      case CharacterExpression.surprised:
        return '😲';
      case CharacterExpression.sad:
        return '😢';
      case CharacterExpression.thinking:
        return '🤔';
      case CharacterExpression.talking:
        return '💬';
      default:
        return '😐';
    }
  }

  String _getPersonalityEmoji(String personalityId) {
    switch (personalityId) {
      case 'playful_pup':
        return '🐕';
      case 'happy_piggy':
        return '🐷';
      case 'magical_friend':
        return '✨';
      case 'rescue_hero':
        return '🦸';
      case 'curious_explorer':
        return '🔍';
      case 'gentle_friend':
        return '🤗';
      default:
        return '😊';
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _talkingController.dispose();
    messageController.dispose();
    SpeechService.stop();
    super.dispose();
  }
}

class CharacterPainter extends CustomPainter {
  final ui.Image image;
  final CharacterExpression expression;

  CharacterPainter({required this.image, required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw character image
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    // Add expression overlay (simple facial features)
    _drawExpression(canvas, size);
  }

  void _drawExpression(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw simple expression indicators
    switch (expression) {
      case CharacterExpression.happy:
      case CharacterExpression.excited:
        // Happy sparkles
        paint.color = Colors.yellow.withOpacity(0.7);
        _drawStar(canvas, Offset(centerX - 60, centerY - 60), 15, paint);
        _drawStar(canvas, Offset(centerX + 60, centerY - 60), 15, paint);
        break;
      case CharacterExpression.talking:
        // Speech bubble indicator
        paint.color = Colors.white.withOpacity(0.8);
        canvas.drawCircle(Offset(centerX + 70, centerY - 70), 20, paint);
        paint.color = Colors.black;
        paint.style = PaintingStyle.stroke;
        canvas.drawCircle(Offset(centerX + 70, centerY - 70), 20, paint);
        break;
      default:
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159) / 5 - 3.14159 / 2;
      final x = center.dx + size * (i % 2 == 0 ? 1 : 0.5) * cos(angle);
      final y = center.dy + size * (i % 2 == 0 ? 1 : 0.5) * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CharacterPainter oldDelegate) {
    return oldDelegate.expression != expression;
  }

  double cos(double angle) => (angle * 180 / 3.14159).toRadians().cos();
  double sin(double angle) => (angle * 180 / 3.14159).toRadians().sin();
}

extension on double {
  double toRadians() => this * 3.14159 / 180;
  double cos() {
    return this; // Simplified
  }

  double sin() {
    return this; // Simplified
  }
}
