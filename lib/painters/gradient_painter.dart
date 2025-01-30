// gradient_painter.dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GradientPainter extends CustomPainter {
  final List<Color> colors;
  final List<List<Offset>> strokes;
  final double strokeWidth;

  GradientPainter(this.colors, {this.strokes = const [], this.strokeWidth = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    // 描画用の設定
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // ストロークの描画
    for (var stroke in strokes) {
      if (stroke.length < 2) continue;

      // パスの作成
      final path = Path();

      // 滑らかな曲線を作成
      path.moveTo(stroke[0].dx, stroke[0].dy);

      for (int i = 1; i < stroke.length - 1; i++) {
        final p0 = stroke[i];
        final p1 = stroke[i + 1];

        // 制御点を計算して、滑らかな曲線を描く
        final controlPoint = Offset(
          (p0.dx + p1.dx) / 2,
          (p0.dy + p1.dy) / 2,
        );

        path.quadraticBezierTo(
          p0.dx,
          p0.dy,
          controlPoint.dx,
          controlPoint.dy,
        );
      }

      // 最後の点を追加
      if (stroke.length >= 2) {
        path.lineTo(stroke.last.dx, stroke.last.dy);
      }

      // グラデーションの作成
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
    return List.generate(count, (index) => index / (count - 1));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}