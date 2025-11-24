import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/drawing_data.dart';

class AnimationService {
  /// Generate facial expressions overlay for the character
  static Widget generateExpression({
    required ui.Image characterImage,
    required CharacterExpression expression,
    required Size canvasSize,
  }) {
    return CustomPaint(
      size: canvasSize,
      painter: ExpressionOverlayPainter(
        characterImage: characterImage,
        expression: expression,
      ),
    );
  }

  /// Animate character with bounce effect
  static AnimationController createBounceAnimation(
    TickerProvider vsync,
  ) {
    return AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: vsync,
    )..repeat(reverse: true);
  }

  /// Create talking animation (mouth movement)
  static AnimationController createTalkingAnimation(
    TickerProvider vsync,
  ) {
    return AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: vsync,
    )..repeat(reverse: true);
  }

  /// Create blink animation
  static AnimationController createBlinkAnimation(
    TickerProvider vsync,
  ) {
    return AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: vsync,
    );
  }

  /// Trigger blink at random intervals
  static Future<void> scheduleBlinks(
    AnimationController blinkController,
  ) async {
    while (true) {
      await Future.delayed(Duration(seconds: 3 + (DateTime.now().second % 4)));
      await blinkController.forward();
      await blinkController.reverse();
    }
  }

  /// Get expression duration
  static Duration getExpressionDuration(CharacterExpression expression) {
    switch (expression) {
      case CharacterExpression.excited:
        return Duration(seconds: 3);
      case CharacterExpression.surprised:
        return Duration(seconds: 2);
      case CharacterExpression.talking:
        return Duration(seconds: 5);
      default:
        return Duration(seconds: 2);
    }
  }

  /// Animate transition between expressions
  static Animation<double> createExpressionTransition({
    required AnimationController controller,
    required CharacterExpression from,
    required CharacterExpression to,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }
}

/// Custom painter for expression overlay
class ExpressionOverlayPainter extends CustomPainter {
  final ui.Image characterImage;
  final CharacterExpression expression;

  ExpressionOverlayPainter({
    required this.characterImage,
    required this.expression,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the base character
    canvas.drawImage(characterImage, Offset.zero, Paint());

    // Get expression offsets
    final offsets = expression.animationOffsets;

    // Apply simple visual effects based on expression
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0;

    // Center point (approximate face location)
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw simple facial features overlay
    switch (expression) {
      case CharacterExpression.happy:
        _drawHappyFace(canvas, centerX, centerY, paint);
        break;
      case CharacterExpression.excited:
        _drawExcitedFace(canvas, centerX, centerY, paint);
        break;
      case CharacterExpression.surprised:
        _drawSurprisedFace(canvas, centerX, centerY, paint);
        break;
      case CharacterExpression.sad:
        _drawSadFace(canvas, centerX, centerY, paint);
        break;
      case CharacterExpression.thinking:
        _drawThinkingFace(canvas, centerX, centerY, paint);
        break;
      case CharacterExpression.talking:
        _drawTalkingFace(canvas, centerX, centerY, paint);
        break;
      default:
        break;
    }
  }

  void _drawHappyFace(Canvas canvas, double x, double y, Paint paint) {
    // Eyes
    paint.color = Colors.black;
    canvas.drawCircle(Offset(x - 20, y - 20), 5, paint);
    canvas.drawCircle(Offset(x + 20, y - 20), 5, paint);

    // Smile
    paint.color = Colors.red;
    paint.style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(x, y + 10), width: 50, height: 30),
      0,
      3.14,
      false,
      paint,
    );
  }

  void _drawExcitedFace(Canvas canvas, double x, double y, Paint paint) {
    // Wide eyes
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x - 20, y - 20), 7, paint);
    canvas.drawCircle(Offset(x + 20, y - 20), 7, paint);

    // Big smile
    paint.color = Colors.red;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(x, y + 15), width: 60, height: 40),
      0,
      3.14,
      false,
      paint,
    );
  }

  void _drawSurprisedFace(Canvas canvas, double x, double y, Paint paint) {
    // Wide eyes
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x - 20, y - 20), 8, paint);
    canvas.drawCircle(Offset(x + 20, y - 20), 8, paint);

    // Open mouth (O shape)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    canvas.drawCircle(Offset(x, y + 20), 12, paint);
  }

  void _drawSadFace(Canvas canvas, double x, double y, Paint paint) {
    // Eyes
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x - 20, y - 20), 4, paint);
    canvas.drawCircle(Offset(x + 20, y - 20), 4, paint);

    // Frown
    paint.color = Colors.red;
    paint.style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(x, y + 25), width: 50, height: 30),
      3.14,
      3.14,
      false,
      paint,
    );
  }

  void _drawThinkingFace(Canvas canvas, double x, double y, Paint paint) {
    // Eyes looking up
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x - 20, y - 25), 4, paint);
    canvas.drawCircle(Offset(x + 20, y - 25), 4, paint);

    // Thoughtful expression
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(Offset(x - 15, y + 15), Offset(x + 15, y + 15), paint);
  }

  void _drawTalkingFace(Canvas canvas, double x, double y, Paint paint) {
    // Eyes
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x - 20, y - 20), 5, paint);
    canvas.drawCircle(Offset(x + 20, y - 20), 5, paint);

    // Moving mouth
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y + 15), width: 30, height: 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ExpressionOverlayPainter oldDelegate) {
    return oldDelegate.expression != expression;
  }
}
