import 'dart:ui';

class DrawingData {
  final List<DrawingPoint> points;
  final String? imagePath;
  final DateTime createdAt;

  DrawingData({
    required this.points,
    this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((p) => p.toJson()).toList(),
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DrawingData.fromJson(Map<String, dynamic> json) {
    return DrawingData(
      points: (json['points'] as List)
          .map((p) => DrawingPoint.fromJson(p))
          .toList(),
      imagePath: json['imagePath'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class DrawingPoint {
  final Offset? offset;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  DrawingPoint({
    this.offset,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'offset': offset != null
          ? {'dx': offset!.dx, 'dy': offset!.dy}
          : null,
      'color': color.value,
      'strokeWidth': strokeWidth,
      'isEraser': isEraser,
    };
  }

  factory DrawingPoint.fromJson(Map<String, dynamic> json) {
    return DrawingPoint(
      offset: json['offset'] != null
          ? Offset(json['offset']['dx'], json['offset']['dy'])
          : null,
      color: Color(json['color']),
      strokeWidth: json['strokeWidth'],
      isEraser: json['isEraser'] ?? false,
    );
  }
}

class AnimatedCharacter {
  final String id;
  final DrawingData drawing;
  final CharacterExpression currentExpression;
  final String personalityId;
  final DateTime animatedAt;

  AnimatedCharacter({
    required this.id,
    required this.drawing,
    required this.currentExpression,
    required this.personalityId,
    required this.animatedAt,
  });
}

enum CharacterExpression {
  neutral,
  happy,
  excited,
  surprised,
  sad,
  thinking,
  talking,
}

extension CharacterExpressionExtension on CharacterExpression {
  String get name {
    switch (this) {
      case CharacterExpression.neutral:
        return 'Neutral';
      case CharacterExpression.happy:
        return 'Happy';
      case CharacterExpression.excited:
        return 'Excited';
      case CharacterExpression.surprised:
        return 'Surprised';
      case CharacterExpression.sad:
        return 'Sad';
      case CharacterExpression.thinking:
        return 'Thinking';
      case CharacterExpression.talking:
        return 'Talking';
    }
  }

  Map<String, double> get animationOffsets {
    switch (this) {
      case CharacterExpression.happy:
        return {'mouthCurve': 0.2, 'eyeSize': 1.1};
      case CharacterExpression.excited:
        return {'mouthCurve': 0.3, 'eyeSize': 1.3, 'bounce': 0.1};
      case CharacterExpression.surprised:
        return {'mouthCurve': -0.2, 'eyeSize': 1.5};
      case CharacterExpression.sad:
        return {'mouthCurve': -0.15, 'eyeSize': 0.9};
      case CharacterExpression.thinking:
        return {'eyeSize': 0.95, 'tilt': 0.05};
      case CharacterExpression.talking:
        return {'mouthMove': 0.1};
      default:
        return {'mouthCurve': 0, 'eyeSize': 1.0};
    }
  }
}
