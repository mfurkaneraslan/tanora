import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanora/data/progress_store.dart';
import 'package:tanora/models/classic_puzzle.dart';
import 'package:tanora/models/game_mode.dart';
import 'package:tanora/screens/classic_game_screen.dart';

import 'app_test.dart' show MemoryPreferences;

void main() {
  test(
    'All 30 partitions preserve the silhouette area and increase piece count',
    () {
      var previousMax = double.infinity;
      for (var level = 1; level <= 30; level++) {
        final pieces = classicPieces(level);
        expect(pieces.length, level + 2);
        expect(pieces.fold(0.0, (sum, p) => sum + p.area), closeTo(32000, .01));
        final largest = pieces
            .map((p) => p.area)
            .reduce((a, b) => a > b ? a : b);
        expect(largest <= previousMax, isTrue);
        previousMax = largest;
        final session = ClassicSession(level);
        for (var i = 0; i < pieces.length; i++) {
          expect(session.drop(i, pieces[i].center), isTrue);
        }
        expect(session.complete, isTrue);
      }
    },
  );
  test(
    'Incorrect drops do not complete and snapped pieces cannot score twice',
    () {
      final session = ClassicSession(1);
      expect(session.drop(0, Offset.zero), isFalse);
      expect(session.complete, isFalse);
      expect(session.drop(0, session.pieces[0].center), isTrue);
      expect(session.drop(0, session.pieces[0].center), isFalse);
      expect(session.moves, 2);
    },
  );
  testWidgets(
    'Dragging all three pieces saves completion and opens the four-piece level',
    (tester) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final prefs = MemoryPreferences();
      final store = ProgressStore(preferences: prefs);
      await tester.pumpWidget(
        MaterialApp(home: ClassicGameScreen(level: 1, progress: store)),
      );
      final board = find.byKey(const ValueKey('classic-board'));
      final origin = tester.getTopLeft(board);
      final scale = tester.getSize(board).width / 360;
      final pieces = classicPieces(1);
      for (var i = 0; i < 3; i++) {
        final start = origin + PieceTray(pieces).centers[i] * scale;
        final gesture = await tester.startGesture(start);
        await gesture.moveBy(const Offset(0, -20));
        await tester.pump();
        await gesture.moveTo(origin + pieces[i].center * scale);
        await tester.pump();
        await gesture.up();
        await tester.pumpAndSettle();
      }
      expect(find.text('Bölüm tamamlandı'), findsOneWidget);
      expect(store.stars(GameMode.classic, 1), 3);
      final restored = ProgressStore(preferences: prefs);
      await restored.load();
      expect(restored.unlocked(GameMode.classic, 2), isTrue);
      await tester.scrollUntilVisible(find.text('Sonraki bölüm · 4 parça'), 150);
      await tester.tap(find.text('Sonraki bölüm · 4 parça'));
      await tester.pumpAndSettle();
      expect(find.text('0 / 4 parça  ·  0 hamle'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
