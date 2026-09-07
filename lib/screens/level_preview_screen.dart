import 'package:flutter/material.dart';

import '../data/progress_store.dart';
import '../models/game_mode.dart';
import 'classic_game_screen.dart';

/// Phase-one destination; no simulated completion or fake score.
class LevelPreviewScreen extends StatelessWidget {
  const LevelPreviewScreen({
    super.key,
    required this.mode,
    required this.level,
    required this.progress,
  });
  final GameMode mode;
  final int level;
  final ProgressStore progress;
  @override
  Widget build(BuildContext context) =>
      ClassicGameScreen(level: level, progress: progress, mode: mode);
}
