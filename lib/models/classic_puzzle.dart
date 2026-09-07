import 'package:flutter/material.dart';

class PuzzlePiece {
  PuzzlePiece(this.vertices);
  final List<Offset> vertices;
  Offset get center => vertices.reduce((a, b) => a + b) / 3;
  List<Offset> get local => vertices.map((p) => p - center).toList();
  double get area =>
      ((vertices[1].dx - vertices[0].dx) * (vertices[2].dy - vertices[0].dy) -
              (vertices[1].dy - vertices[0].dy) *
                  (vertices[2].dx - vertices[0].dx))
          .abs() /
      2;
}

/// A house partitioned into progressively smaller triangles, with no gaps.
List<PuzzlePiece> classicPieces(int level) {
  if (level < 1 || level > 30) throw RangeError.range(level, 1, 30);
  final pieces = [
    PuzzlePiece([
      const Offset(180, 40),
      const Offset(100, 120),
      const Offset(260, 120),
    ]),
    PuzzlePiece([
      const Offset(100, 120),
      const Offset(260, 120),
      const Offset(100, 280),
    ]),
    PuzzlePiece([
      const Offset(260, 120),
      const Offset(260, 280),
      const Offset(100, 280),
    ]),
  ];
  while (pieces.length < level + 2) {
    pieces.sort((a, b) => b.area.compareTo(a.area));
    final triangle = pieces.removeAt(0).vertices;
    var longest = 0;
    for (var i = 1; i < 3; i++) {
      if ((triangle[i] - triangle[(i + 1) % 3]).distanceSquared >
          (triangle[longest] - triangle[(longest + 1) % 3]).distanceSquared) {
        longest = i;
      }
    }
    final a = triangle[longest],
        b = triangle[(longest + 1) % 3],
        c = triangle[(longest + 2) % 3];
    final mid = (a + b) / 2;
    pieces.addAll([
      PuzzlePiece([a, mid, c]),
      PuzzlePiece([mid, b, c]),
    ]);
  }
  return pieces;
}

class ClassicSession {
  ClassicSession(int level) : pieces = classicPieces(level);
  final List<PuzzlePiece> pieces;
  final Map<int, int> placed = {};
  int moves = 0;
  bool get complete => placed.length == pieces.length;
  bool drop(int piece, Offset center) {
    if (placed.containsKey(piece)) return false;
    moves++;
    for (var target = 0; target < pieces.length; target++) {
      if (placed.containsValue(target) ||
          (center - pieces[target].center).distance > 22) {
        continue;
      }
      final a = pieces[piece].local, b = pieces[target].local;
      if (a.every((p) => b.any((q) => (p - q).distance < .01))) {
        placed[piece] = target;
        return true;
      }
    }
    return false;
  }
}

/// Shelf packing preserves each piece's exact target dimensions.
class PieceTray {
  PieceTray(List<PuzzlePiece> pieces) {
    if (pieces.length == 3) {
      centers.addAll([
        const Offset(85, 380),
        const Offset(180, 390),
        const Offset(275, 390),
      ]);
      height = 460;
      return;
    }
    var x = 12.0, y = 320.0, rowHeight = 0.0;
    for (final piece in pieces) {
      final bounds = (Path()..addPolygon(piece.local, true)).getBounds();
      if (x + bounds.width > 348) {
        x = 12;
        y += rowHeight + 16;
        rowHeight = 0;
      }
      centers.add(Offset(x - bounds.left, y - bounds.top));
      x += bounds.width + 16;
      if (bounds.height > rowHeight) rowHeight = bounds.height;
    }
    height = y + rowHeight + 16;
  }
  final List<Offset> centers = [];
  late final double height;
}
