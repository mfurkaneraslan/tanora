import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanora/app.dart';
import 'package:tanora/data/progress_store.dart';
import 'package:tanora/models/play_session.dart';
import 'package:tanora/models/game_mode.dart';
import 'package:tanora/screens/classic_game_screen.dart';

import 'app_test.dart' show MemoryPreferences;

void main() {
  test('Every minimal-move level is solvable in its advertised move count', () {
    for (var level = 1; level <= 30; level++) {
      final session = PlaySession(level, GameMode.minimalMoves);
      expect(session.complete, isFalse);
      expect(
        session.placed.length,
        session.pieces.length - session.requiredMoves,
      );
      for (var i = 0; i < session.requiredMoves; i++) {
        expect(
          (session.positions[i]! - session.pieces[i].center).distance,
          greaterThan(22),
        );
        expect(session.drop(i, session.pieces[i].center), isTrue);
      }
      expect(session.complete, isTrue);
      expect(session.moves, session.requiredMoves);
      expect(session.score, 3);
    }
  });
  test('Memory peeks lower stars but never below one', () {
    final session = PlaySession(1, GameMode.memory);
    for (var i = 0; i < session.pieces.length; i++) {
      session.drop(i, session.pieces[i].center);
    }
    expect(session.score, 3);
    session.peeks = 1;
    expect(session.score, 2);
    session.peeks = 5;
    expect(session.score, 1);
  });
  testWidgets(
    'Memory hides at three seconds, peek lasts one second, leaving cancels timers',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final store = ProgressStore(preferences: MemoryPreferences());
      await tester.pumpWidget(
        MaterialApp(
          home: ClassicGameScreen(
            level: 1,
            progress: store,
            mode: GameMode.memory,
          ),
        ),
      );
      expect(find.text('Silüeti incele · 3 saniye'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Ev'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Şekli hatırla'), findsOneWidget);
      await tester.tap(find.textContaining('Tekrar bak'));
      await tester.pump();
      expect(find.text('Ev'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Şekli hatırla'), findsOneWidget);
      await tester.tap(find.textContaining('Tekrar bak'));
      await tester.pumpWidget(TanoraApp(progress: store));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  for (final mode in [GameMode.minimalMoves, GameMode.memory]) {
    testWidgets('Successful ${mode.name} saves only its own progression', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final prefs = MemoryPreferences();
      final store = ProgressStore(preferences: prefs);
      await tester.pumpWidget(
        MaterialApp(
          home: ClassicGameScreen(level: 1, progress: store, mode: mode),
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      final state = PlaySession(1, mode);
      final board = find.byKey(const ValueKey('classic-board'));
      final origin = tester.getTopLeft(board);
      final scale = tester.getSize(board).width / 360;
      for (var i = 0; i < state.requiredMoves; i++) {
        final gesture = await tester.startGesture(
          origin + state.positions[i]! * scale,
        );
        await gesture.moveTo(origin + state.pieces[i].center * scale);
        await gesture.up();
        await tester.pumpAndSettle();
      }
      expect(find.text('Tebrikler!'), findsOneWidget);
      expect(store.stars(mode, 1), 3);
      expect(store.stars(GameMode.classic, 1), 0);
      await tester.tap(find.text('Devam et'));
      await tester.pumpAndSettle();
      expect(find.text('${mode.title} · 02'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
