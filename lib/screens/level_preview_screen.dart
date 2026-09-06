import 'package:flutter/material.dart';

import '../data/progress_store.dart';
import '../models/game_mode.dart';
import '../widgets/tangram_art.dart';

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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('${mode.title} · ${level.toString().padLeft(2, '0')}'),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(28),
          children: [
            Center(child: Icon(mode.icon, color: mode.color, size: 36)),
            const SizedBox(height: 16),
            const Text(
              'İlk şekle doğru',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(mode.description, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            const Center(child: TangramArt(size: 240)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161F37),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    'Oyun alanı önizlemesi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bu ilk sürümde menü ve bölüm akışı hazır. Parçaları sürükleme, döndürme ve çözüm kontrolü sonraki geliştirme aşamasında eklenecek.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Geri dön'),
            ),
            if (progress.error != null)
              Text(progress.error!, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
