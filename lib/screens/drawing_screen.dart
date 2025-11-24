import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import '../models/drawing_data.dart';
import '../models/character_personality.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/character_selector.dart';
import 'character_screen.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingPoint> drawingPoints = [];
  CharacterPersonality? selectedPersonality;
  final GlobalKey _canvasKey = GlobalKey();
  bool isSelectingPersonality = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🎨 Draw Your Character',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.blue[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Instructions
              if (!isSelectingPersonality) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Draw your character! Use different colors and be creative! 🌈',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Drawing canvas
              if (!isSelectingPersonality)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: RepaintBoundary(
                      key: _canvasKey,
                      child: DrawingCanvas(
                        onDrawingChanged: (points) {
                          setState(() {
                            drawingPoints = points;
                          });
                        },
                        initialPoints: drawingPoints,
                      ),
                    ),
                  ),
                ),

              // Personality selector
              if (isSelectingPersonality)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: CharacterSelector(
                      onPersonalitySelected: (personality) {
                        setState(() {
                          selectedPersonality = personality;
                        });
                      },
                      selectedPersonalityId: selectedPersonality?.id,
                    ),
                  ),
                ),

              // Action buttons
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (isSelectingPersonality) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              isSelectingPersonality = false;
                            });
                          },
                          icon: Icon(Icons.arrow_back),
                          label: Text('Back to Drawing'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: selectedPersonality != null
                              ? _bringCharacterToLife
                              : null,
                          icon: Icon(Icons.play_arrow),
                          label: Text('Bring to Life!'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: drawingPoints.isEmpty
                              ? null
                              : () {
                                  setState(() {
                                    isSelectingPersonality = true;
                                  });
                                },
                          icon: Icon(Icons.psychology),
                          label: Text('Choose Personality'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _bringCharacterToLife() async {
    if (selectedPersonality == null || drawingPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please draw your character and choose a personality!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                '✨ Bringing your character to life! ✨',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Capture the drawing as image
    try {
      final boundary = _canvasKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final imageData = byteData!.buffer.asUint8List();

      // Create drawing data
      final drawingData = DrawingData(
        points: drawingPoints,
        createdAt: DateTime.now(),
      );

      // Navigate to character screen
      Navigator.pop(context); // Close loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterScreen(
            drawingData: drawingData,
            personality: selectedPersonality!,
            characterImage: image,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating character. Please try again!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
