import 'package:flutter/material.dart';

class GradientPainter extends CustomPainter {
  final List<Color> colors;

  GradientPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
