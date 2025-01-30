class PaintData {
  final int id;
  final String name;
  final List<ColorData> colors; // 1つの塗料が複数の色を持つ

  PaintData({required this.id, required this.name, required this.colors});
}

class ColorData {
  final int id;
  final String name;
  final String colorCode; // HEXカラーコード

  ColorData({required this.id, required this.name, required this.colorCode});
}

// ダミーデータ
List<PaintData> dummyPaints = [
  PaintData(
    id: 1,
    name: "Sunset Gradient",
    colors: [
      ColorData(id: 1, name: "Red", colorCode: "#FF5733"),
      ColorData(id: 2, name: "Orange", colorCode: "#FF8D1A"),
      ColorData(id: 3, name: "Yellow", colorCode: "#FFC300"),
    ],
  ),
  PaintData(
    id: 2,
    name: "Ocean Blue",
    colors: [
      ColorData(id: 4, name: "Blue", colorCode: "#0074D9"),
      ColorData(id: 5, name: "Cyan", colorCode: "#00BFFF"),
      ColorData(id: 6, name: "Light Blue", colorCode: "#87CEFA"),
    ],
  ),
];
