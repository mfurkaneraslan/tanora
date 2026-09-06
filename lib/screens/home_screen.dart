import 'package:flutter/material.dart';

import '../data/progress_store.dart';
import '../models/game_mode.dart';
import '../widgets/tangram_art.dart';
import 'level_select_screen.dart';
import 'level_preview_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.progress});
  final ProgressStore progress;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListenableBuilder(
            listenable: progress,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.change_history_rounded,
                      color: Color(0xFF60DDC2),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'TANORA',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFD879),
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text('${progress.totalStars}'),
                  ],
                ),
                const SizedBox(height: 24),
                const Center(child: TangramArt(size: 180)),
                const Text(
                  'Yedi parça.\nSonsuz olasılık.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Biraz odaklan. Biraz hayal et.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                const Text(
                  'NASIL OYNAMAK İSTERSİN?',
                  style: TextStyle(
                    color: Color(0xFF8995B4),
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                for (final mode in GameMode.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ModeCard(mode: mode, progress: progress),
                  ),
                if (progress.lastMode != null)
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => LevelPreviewScreen(
                          mode: progress.lastMode!,
                          level: progress.lastLevel,
                          progress: progress,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      'Devam et · ${progress.lastMode!.title} · ${progress.lastLevel.toString().padLeft(2, '0')}',
                    ),
                  ),
                if (progress.error != null)
                  Text(
                    progress.error!,
                    style: const TextStyle(color: Colors.orangeAccent),
                  ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.offline_bolt_outlined,
                      size: 14,
                      color: Color(0xFF7785A5),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Sadece sen ve parçalar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7785A5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode, required this.progress});
  final GameMode mode;
  final ProgressStore progress;
  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF161F37),
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => LevelSelectScreen(mode: mode, progress: progress),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: mode.color.withValues(alpha: .16)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 52,
              decoration: BoxDecoration(
                color: mode.color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(mode.icon, color: mode.color, size: 29),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(mode.subtitle, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 10),
                  Text(
                    '${progress.completed(mode)} / 30 bölüm',
                    style: TextStyle(
                      color: mode.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: mode.color, size: 21),
          ],
        ),
      ),
    ),
  );
}
