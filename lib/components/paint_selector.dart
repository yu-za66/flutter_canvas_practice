import 'package:flutter/material.dart';
import '../models/paint_data.dart';

class PaintSelector extends StatefulWidget {
  final Function(PaintData) onPaintSelected; // 選択時のコールバック

  PaintSelector({required this.onPaintSelected});

  @override
  _PaintSelectorState createState() => _PaintSelectorState();
}

class _PaintSelectorState extends State<PaintSelector> {
  PaintData? selectedPaint;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<PaintData>(
      hint: Text("塗料を選択"),
      value: selectedPaint,
      items: dummyPaints.map((paint) {
        return DropdownMenuItem(
          value: paint,
          child: Text(paint.name),
        );
      }).toList(),
      onChanged: (paint) {
        setState(() {
          selectedPaint = paint;
        });
        if (paint != null) {
          widget.onPaintSelected(paint);
        }
      },
    );
  }
}
