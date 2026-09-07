import 'package:flutter/material.dart';

import 'classic_shapes.dart';
export 'classic_shapes.dart';

class PuzzlePiece {
  PuzzlePiece(this.vertices);
  final List<Offset> vertices;
  Offset get center =>
      vertices.reduce((a, b) => a + b) / vertices.length.toDouble();
  List<Offset> get local => vertices.map((p) => p - center).toList();
  double get area => polygonArea(vertices).abs();
  double get thickness {
    var perimeter = 0.0;
    for (var i = 0; i < vertices.length; i++) {
      perimeter += (vertices[i] - vertices[(i + 1) % vertices.length]).distance;
    }
    return 2 * area / perimeter;
  }
}

List<PuzzlePiece> classicPieces(int level) {
  if (level < 1 || level > 30) throw RangeError.range(level, 1, 30);
  final pieces = level == 1
      ? [
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
        ]
      : triangulate(classicShapes[level - 1].points);
  // Never subdivide merely to satisfy a count: merge slivers into adjacent pieces.
  if (level > 1) return regularPieces(pieces);

  return pieces;
}

List<PuzzlePiece> regularPieces(List<PuzzlePiece> source) {
  final pieces = source.toList();
  bool good(PuzzlePiece p) => p.area >= 500 && p.thickness >= 12;
  while (pieces.length > 1) {
    final bad = pieces.indexWhere((p) => !good(p));
    if (bad < 0) break;
    PuzzlePiece? best;
    var neighbor = -1;
    var bestScore = -1.0;
    for (var j = 0; j < pieces.length; j++) {
      if (j == bad) continue;
      final merged = mergePieces(pieces[bad], pieces[j]);
      if (merged == null) continue;
      final score = merged.thickness;
      if (score > bestScore) {
        best = merged;
        neighbor = j;
        bestScore = score;
      }
    }
    if (best == null) throw StateError('İnce parça birleştirilemedi');
    pieces[bad] = best;
    pieces.removeAt(neighbor);
  }
  return pieces;
}

PuzzlePiece? mergePieces(PuzzlePiece a, PuzzlePiece b) {
  // Both boundaries have the same winding. Remove opposite shared edges.
  final edges = <List<Offset>>[];
  for (final piece in [a, b]) {
    for (var i = 0; i < piece.vertices.length; i++) {
      final x = piece.vertices[i],
          y = piece.vertices[(i + 1) % piece.vertices.length];
      final shared = edges.indexWhere((e) => e[0] == y && e[1] == x);
      if (shared >= 0) {
        edges.removeAt(shared);
      } else {
        edges.add([x, y]);
      }
    }
  }
  if (edges.length == a.vertices.length + b.vertices.length) return null;
  final outline = <Offset>[edges.first[0]];
  var end = edges.removeAt(0)[1];
  while (edges.isNotEmpty) {
    outline.add(end);
    final next = edges.indexWhere((e) => e[0] == end);
    if (next < 0) return null;
    end = edges.removeAt(next)[1];
  }
  if (end != outline.first || outline.toSet().length != outline.length) {
    return null;
  }
  return PuzzlePiece(outline);
}

class ClassicSession {
  ClassicSession(this.level) : pieces = classicPieces(level);
  final int level;
  ClassicShape get shape => classicShapes[level - 1];
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
      if (a.length == b.length &&
          a.every((p) => b.any((q) => (p - q).distance < .01))) {
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
