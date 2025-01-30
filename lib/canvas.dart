import 'package:flutter/material.dart';
import '../models/paint_data.dart';
import '../components/paint_selector.dart';
import '../painters/gradient_painter.dart';
import 'dart:ui' as ui;

class CanvasPage extends StatefulWidget {
  @override
  _CanvasPageState createState() => _CanvasPageState();
}

// canvas_page.dart の修正部分
class _CanvasPageState extends State<CanvasPage> {
  List<List<Offset>> strokes = [];
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
                  strokes.add([details.localPosition]);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  strokes.last.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                // 線の描画終了時の処理（必要に応じて）
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: isGradientMode
                    ? GradientPainter(selectedColors, strokes: strokes, strokeWidth: penSize)
                    : GradientPainter(selectedColors, strokes: strokes, strokeWidth: penSize),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            strokes.clear();
          });
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}

class GradientStrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Color> colors;
  final double penSize;

  GradientStrokePainter(this.strokes, this.colors, this.penSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty || strokes.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = penSize
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (var stroke in strokes) {
      if (stroke.length < 2) continue;

      // 各ストロークのパスを作成
      final path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);

      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }

      // ストロークの長さに基づいてグラデーションを作成
      final pathMetrics = path.computeMetrics().first;
      final gradient = ui.Gradient.linear(
        stroke.first,
        stroke.last,
        colors,
        _createStops(colors.length),
      );

      paint.shader = gradient;
      canvas.drawPath(path, paint);
    }
  }

  List<double> _createStops(int count) {
    List<double> stops = [];
    for (int i = 0; i < count; i++) {
      stops.add(i / (count - 1));
    }
    return stops;
  }

  @override
  bool shouldRepaint(GradientStrokePainter oldDelegate) => true;
}