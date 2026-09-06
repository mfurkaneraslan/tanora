import 'package:flutter/material.dart';

import '../data/progress_store.dart';
import '../models/game_mode.dart';
import 'level_preview_screen.dart';
import '../widgets/tangram_play.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({
    super.key,
    required this.mode,
    required this.progress,
  });
  final GameMode mode;
  final ProgressStore progress;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const TangramBack(), title: Text(mode.title)),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListenableBuilder(
          listenable: progress,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Icon(mode.icon, size: 48, color: mode.color),
              const SizedBox(height: 18),
              Text(
                mode.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(mode.description, textAlign: TextAlign.center),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'BAŞLANGIÇ',
                      style: TextStyle(letterSpacing: 2, fontSize: 12),
                    ),
                  ),
                  Text(
                    '${progress.completed(mode)} / 30',
                    style: TextStyle(color: mode.color),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress.completed(mode) / 30,
                color: mode.color,
                minHeight: 4,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: GameMode.levelCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth < 300 ? 3 : 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 84,
                  ),
                  itemBuilder: (context, index) {
                    final level = index + 1;
                    final open = progress.unlocked(mode, level);
                    final stars = progress.stars(mode, level);
                    return Semantics(
                      label:
                          'Bölüm $level${open ? ', açık, $stars yıldız' : ', kilitli'}',
                      button: true,
                      enabled: open,
                      child: Material(
                        color: open
                            ? mode.color.withValues(alpha: .14)
                            : const Color(0xFF141C31),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: !open
                              ? null
                              : () async {
                                  await progress.select(mode, level);
                                  if (!context.mounted) return;
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => LevelPreviewScreen(
                                        mode: mode,
                                        level: level,
                                        progress: progress,
                                      ),
                                    ),
                                  );
                                },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (open)
                                Text(
                                  level.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: mode.color,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFF56617D),
                                  size: 21,
                                ),
                              const SizedBox(height: 6),
                              if (open)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    3,
                                    (i) => Icon(
                                      i < stars
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      size: 12,
                                      color: i < stars
                                          ? mode.color
                                          : const Color(0xFF56617D),
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  '$level',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF56617D),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Her tamamlanan bölüm, bir sonrakini açar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
