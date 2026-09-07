import 'package:flutter/material.dart';

import 'classic_puzzle.dart';
import 'game_mode.dart';

class PlaySession extends ClassicSession {
  PlaySession(super.level, this.mode) {
    final tray = PieceTray(pieces);
    for (var i = 0; i < pieces.length; i++) {
      positions[i] = tray.centers[i];
    }
    requiredMoves = mode == GameMode.minimalMoves
        ? (2 + (level - 1) ~/ 5).clamp(1, pieces.length)
        : pieces.length;
    if (mode == GameMode.minimalMoves) {
      for (var i = 0; i < pieces.length; i++) {
        if (i < requiredMoves) {
          positions[i] = pieces[i].center + Offset(i.isEven ? -38 : 38, 35);
        } else {
          placed[i] = i;
        }
      }
    }
  }
  final GameMode mode;
  final Map<int, Offset> positions = {};
  late final int requiredMoves;
  int peeks = 0;
  int get score {
    final extra = moves - requiredMoves;
    final moveScore = extra <= 0
        ? 3
        : extra <= 3
        ? 2
        : 1;
    return mode == GameMode.memory
        ? (moveScore - peeks).clamp(1, 3)
        : moveScore;
  }

  @override
  bool drop(int piece, Offset center) {
    final success = super.drop(piece, center);
    if (!success &&
        mode == GameMode.minimalMoves &&
        !placed.containsKey(piece)) {
      final bounds = (Path()..addPolygon(pieces[piece].local, true))
          .getBounds();
      positions[piece] = Offset(
        center.dx.clamp(6 - bounds.left, 354 - bounds.right),
        center.dy.clamp(6 - bounds.top, 354 - bounds.bottom),
      );
    }
    return success;
  }
}
