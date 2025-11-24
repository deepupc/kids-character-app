import 'package:flutter/material.dart';
import '../models/drawing_data.dart';

class DrawingCanvas extends StatefulWidget {
  final Function(List<DrawingPoint>) onDrawingChanged;
  final List<DrawingPoint> initialPoints;

  const DrawingCanvas({
    Key? key,
    required this.onDrawingChanged,
    this.initialPoints = const [],
  }) : super(key: key);

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<DrawingPoint> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  bool isEraser = false;

  @override
  void initState() {
    super.initState();
    points = List.from(widget.initialPoints);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drawing tools
        _buildToolbar(),
        
        // Canvas
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  points.add(
                    DrawingPoint(
                      offset: details.localPosition,
                      color: isEraser ? Colors.white : selectedColor,
                      strokeWidth: strokeWidth,
                      isEraser: isEraser,
                    ),
                  );
                });
                widget.onDrawingChanged(points);
              },
              onPanUpdate: (details) {
                setState(() {
                  points.add(
                    DrawingPoint(
                      offset: details.localPosition,
                      color: isEraser ? Colors.white : selectedColor,
                      strokeWidth: strokeWidth,
                      isEraser: isEraser,
                    ),
                  );
                });
                widget.onDrawingChanged(points);
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(
                    DrawingPoint(
                      offset: null,
                      color: selectedColor,
                      strokeWidth: strokeWidth,
                    ),
                  );
                });
                widget.onDrawingChanged(points);
              },
              child: CustomPaint(
                painter: DrawingPainter(points: points),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Color palette
            _buildColorButton(Colors.black),
            _buildColorButton(Colors.red),
            _buildColorButton(Colors.blue),
            _buildColorButton(Colors.green),
            _buildColorButton(Colors.yellow),
            _buildColorButton(Colors.orange),
            _buildColorButton(Colors.purple),
            _buildColorButton(Colors.pink),
            _buildColorButton(Colors.brown),
            
            SizedBox(width: 16),
            
            // Brush size
            _buildBrushSizeButton(3.0, 'Small'),
            _buildBrushSizeButton(5.0, 'Medium'),
            _buildBrushSizeButton(8.0, 'Large'),
            
            SizedBox(width: 16),
            
            // Eraser
            _buildEraserButton(),
            
            SizedBox(width: 16),
            
            // Clear button
            _buildClearButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isSelected = selectedColor == color && !isEraser;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          isEraser = false;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildBrushSizeButton(double size, String label) {
    final isSelected = strokeWidth == size && !isEraser;
    return GestureDetector(
      onTap: () {
        setState(() {
          strokeWidth = size;
          isEraser = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEraserButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEraser = !isEraser;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isEraser ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cleaning_services,
              color: isEraser ? Colors.white : Colors.red,
            ),
            SizedBox(width: 4),
            Text(
              'Eraser',
              style: TextStyle(
                color: isEraser ? Colors.white : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          points.clear();
        });
        widget.onDrawingChanged(points);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 4),
            Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != null && points[i + 1].offset != null) {
        final paint = Paint()
          ..color = points[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i].strokeWidth;

        canvas.drawLine(
          points[i].offset!,
          points[i + 1].offset!,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
