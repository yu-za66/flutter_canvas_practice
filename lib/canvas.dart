import 'package:flutter/material.dart';
import '../models/paint_data.dart';
import '../components/paint_selector.dart';
import '../painters/gradient_painter.dart';
import 'dart:ui' as ui;

class CanvasPage extends StatefulWidget {
  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  List<Offset> points = [];
  List<Color> selectedColors = [];
  bool isGradientMode = true;
  double penSize = 5.0;

  void onPaintSelected(PaintData paint) {
    setState(() {
      selectedColors = paint.colors.map((color) {
        return Color(int.parse(color.colorCode.substring(1, 7), radix: 16) + 0xFF000000);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('キャンバス')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PaintSelector(onPaintSelected: onPaintSelected),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGradientMode = true;
                  });
                },
                child: Text("グラデーション"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGradientMode = false;
                  });
                },
                child: Text("手書き"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ペンサイズ: "),
              Slider(
                value: penSize,
                min: 1.0,
                max: 20.0,
                divisions: 19,
                label: penSize.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    penSize = value;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  points.add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  points.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(Offset.infinite); // 線の区切りとしてinfiniteを追加
                });
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: isGradientMode
                    ? GradientPainter(selectedColors)
                    : GradientDrawingPainter(points, selectedColors, penSize),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            points.clear();
          });
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}

class GradientDrawingPainter extends CustomPainter {
  final List<Offset> points;
  final List<Color> colors;
  final double penSize;

  GradientDrawingPainter(this.points, this.colors, this.penSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty || points.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = penSize
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        // グラデーションの色を変化させる
        final colorIndex = i % colors.length;
        paint.color = colors[colorIndex];

        // 2点間を線で結ぶ
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(GradientDrawingPainter oldDelegate) => true;
}