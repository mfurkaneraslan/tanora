import 'package:flutter/material.dart';

import 'classic_puzzle.dart' show PuzzlePiece;

class ClassicShape {
  ClassicShape(this.name, List<List<int>> coordinates)
    : points = coordinates
          .map((p) => Offset(60 + p[0] * 20.0, 40 + p[1] * 20.0))
          .toList();
  final String name;
  final List<Offset> points;
  Path get path => Path()..addPolygon(points, true);
}

final classicShapes = <ClassicShape>[
  ClassicShape('Ev', [
    [6, 0],
    [10, 4],
    [10, 12],
    [2, 12],
    [2, 4],
  ]),
  ClassicShape('Yelkenli', [
    [5, 0],
    [5, 8],
    [12, 8],
    [10, 11],
    [2, 11],
    [0, 8],
  ]),
  ClassicShape('Balık', [
    [0, 3],
    [4, 5],
    [8, 2],
    [12, 6],
    [8, 10],
    [4, 7],
    [0, 9],
  ]),
  ClassicShape('Dağ', [
    [0, 11],
    [4, 2],
    [7, 7],
    [9, 4],
    [12, 11],
  ]),
  ClassicShape('Uçurtma', [
    [6, 0],
    [10, 4],
    [6, 9],
    [8, 11],
    [6, 12],
    [5, 10],
    [2, 4],
  ]),
  ClassicShape('Ağaç', [
    [6, 0],
    [10, 5],
    [8, 5],
    [12, 9],
    [7, 9],
    [7, 12],
    [5, 12],
    [5, 9],
    [0, 9],
    [4, 5],
    [2, 5],
  ]),
  ClassicShape('Roket', [
    [6, 0],
    [9, 4],
    [9, 8],
    [12, 11],
    [8, 10],
    [7, 12],
    [5, 12],
    [4, 10],
    [0, 11],
    [3, 8],
    [3, 4],
  ]),
  ClassicShape('Kalp', [
    [6, 3],
    [8, 1],
    [11, 1],
    [12, 4],
    [6, 11],
    [0, 4],
    [1, 1],
    [4, 1],
  ]),
  ClassicShape('Yıldız', [
    [6, 0],
    [8, 4],
    [12, 4],
    [9, 7],
    [10, 12],
    [6, 9],
    [2, 12],
    [3, 7],
    [0, 4],
    [4, 4],
  ]),
  ClassicShape('Kedi', [
    [3, 0],
    [6, 2],
    [9, 0],
    [9, 5],
    [8, 7],
    [10, 10],
    [12, 7],
    [12, 11],
    [9, 12],
    [2, 12],
    [4, 7],
    [3, 5],
  ]),
  ClassicShape('Tavşan', [
    [3, 0],
    [5, 0],
    [6, 4],
    [7, 0],
    [9, 1],
    [8, 6],
    [10, 9],
    [9, 12],
    [2, 12],
    [1, 9],
    [4, 6],
  ]),
  ClassicShape('Kuş', [
    [0, 2],
    [5, 5],
    [8, 2],
    [9, 4],
    [12, 5],
    [9, 6],
    [7, 10],
    [3, 8],
    [1, 10],
    [2, 6],
  ]),
  ClassicShape('Kelebek', [
    [6, 5],
    [9, 1],
    [12, 2],
    [11, 6],
    [8, 7],
    [11, 9],
    [10, 12],
    [6, 9],
    [2, 12],
    [1, 9],
    [4, 7],
    [1, 6],
    [0, 2],
    [3, 1],
  ]),
  ClassicShape('Mum', [
    [6, 0],
    [8, 3],
    [7, 5],
    [9, 5],
    [9, 11],
    [11, 11],
    [11, 12],
    [1, 12],
    [1, 11],
    [3, 11],
    [3, 5],
    [5, 5],
    [4, 3],
  ]),
  ClassicShape('Kupa', [
    [1, 2],
    [11, 2],
    [12, 4],
    [12, 7],
    [9, 9],
    [7, 9],
    [6, 11],
    [2, 11],
    [1, 8],
  ]),
  ClassicShape('Şemsiye', [
    [6, 0],
    [10, 2],
    [12, 6],
    [7, 6],
    [7, 10],
    [6, 12],
    [3, 12],
    [2, 10],
    [4, 10],
    [5, 11],
    [5, 6],
    [0, 6],
    [2, 2],
  ]),
  ClassicShape('Taç', [
    [0, 3],
    [3, 6],
    [6, 0],
    [9, 6],
    [12, 3],
    [10, 11],
    [2, 11],
  ]),
  ClassicShape('Şimşek', [
    [6, 0],
    [11, 0],
    [7, 5],
    [10, 5],
    [3, 12],
    [5, 7],
    [1, 7],
  ]),
  ClassicShape('Bayrak', [
    [2, 0],
    [11, 0],
    [9, 3],
    [11, 6],
    [3, 6],
    [3, 12],
    [1, 12],
    [1, 0],
  ]),
  ClassicShape('Elmas', [
    [3, 1],
    [9, 1],
    [12, 4],
    [6, 12],
    [0, 4],
  ]),
  ClassicShape('Anahtar', [
    [2, 1],
    [6, 1],
    [8, 3],
    [7, 6],
    [12, 10],
    [10, 12],
    [8, 10],
    [9, 9],
    [6, 7],
    [3, 8],
    [0, 5],
    [0, 3],
  ]),
  ClassicShape('Çekiç', [
    [0, 1],
    [9, 1],
    [12, 3],
    [9, 5],
    [7, 5],
    [7, 12],
    [4, 12],
    [4, 5],
    [0, 5],
  ]),
  ClassicShape('Uçak', [
    [6, 0],
    [7, 4],
    [12, 7],
    [12, 9],
    [7, 7],
    [7, 10],
    [9, 11],
    [9, 12],
    [6, 11],
    [3, 12],
    [3, 11],
    [5, 10],
    [5, 7],
    [0, 9],
    [0, 7],
    [5, 4],
  ]),
  ClassicShape('Köprü', [
    [0, 5],
    [2, 5],
    [2, 2],
    [3, 2],
    [3, 5],
    [9, 5],
    [9, 2],
    [10, 2],
    [10, 5],
    [12, 5],
    [12, 11],
    [9, 11],
    [9, 8],
    [3, 8],
    [3, 11],
    [0, 11],
  ]),
  ClassicShape('Kale', [
    [0, 1],
    [2, 1],
    [2, 3],
    [4, 3],
    [4, 1],
    [6, 1],
    [6, 3],
    [8, 3],
    [8, 1],
    [10, 1],
    [10, 3],
    [12, 3],
    [12, 12],
    [7, 12],
    [7, 9],
    [5, 9],
    [5, 12],
    [0, 12],
  ]),
  ClassicShape('Mantar', [
    [0, 7],
    [1, 4],
    [4, 1],
    [8, 1],
    [11, 4],
    [12, 7],
    [8, 7],
    [9, 12],
    [3, 12],
    [4, 7],
  ]),
  ClassicShape('Lale', [
    [2, 0],
    [5, 3],
    [6, 0],
    [7, 3],
    [10, 0],
    [10, 5],
    [7, 7],
    [7, 9],
    [10, 8],
    [9, 11],
    [6, 12],
    [3, 11],
    [2, 8],
    [5, 9],
    [5, 7],
    [2, 5],
  ]),
  ClassicShape('Zarf', [
    [0, 3],
    [6, 0],
    [12, 3],
    [12, 11],
    [0, 11],
  ]),
  ClassicShape('Gemi', [
    [0, 7],
    [2, 7],
    [2, 4],
    [5, 4],
    [5, 1],
    [7, 1],
    [7, 4],
    [10, 4],
    [10, 7],
    [12, 7],
    [10, 11],
    [2, 11],
  ]),
  ClassicShape('Robot', [
    [4, 0],
    [8, 0],
    [8, 2],
    [10, 2],
    [10, 5],
    [9, 5],
    [9, 6],
    [12, 6],
    [12, 10],
    [10, 10],
    [10, 8],
    [9, 8],
    [9, 12],
    [7, 12],
    [7, 10],
    [5, 10],
    [5, 12],
    [3, 12],
    [3, 8],
    [2, 8],
    [2, 10],
    [0, 10],
    [0, 6],
    [3, 6],
    [3, 5],
    [2, 5],
    [2, 2],
    [4, 2],
  ]),
];

double polygonArea(List<Offset> p) {
  var area = 0.0;
  for (var i = 0; i < p.length; i++) {
    final a = p[i], b = p[(i + 1) % p.length];
    area += a.dx * b.dy - b.dx * a.dy;
  }
  return area / 2;
}

double _cross(Offset a, Offset b, Offset c) =>
    (b.dx - a.dx) * (c.dy - a.dy) - (b.dy - a.dy) * (c.dx - a.dx);

/// Ear clipping supports concave silhouettes without triangles outside the outline.
List<PuzzlePiece> triangulate(List<Offset> outline) {
  final points = polygonArea(outline) > 0
      ? outline.toList()
      : outline.reversed.toList();
  final result = <PuzzlePiece>[];
  while (points.length > 3) {
    var clipped = false;
    for (var i = 0; i < points.length; i++) {
      final a = points[(i + points.length - 1) % points.length],
          b = points[i],
          c = points[(i + 1) % points.length];
      if (_cross(a, b, c) <= .001) continue;
      final contains = points.any(
        (p) =>
            p != a &&
            p != b &&
            p != c &&
            _cross(a, b, p) >= -.001 &&
            _cross(b, c, p) >= -.001 &&
            _cross(c, a, p) >= -.001,
      );
      if (contains) continue;
      result.add(PuzzlePiece([a, b, c]));
      points.removeAt(i);
      clipped = true;
      break;
    }
    if (!clipped) throw StateError('Silüet üçgenlere ayrılamadı');
  }
  result.add(PuzzlePiece(points.toList()));
  return result;
}
