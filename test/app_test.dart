import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanora/app.dart';
import 'package:tanora/data/progress_store.dart';
import 'package:tanora/models/game_mode.dart';
import 'package:tanora/screens/home_screen.dart';

class MemoryPreferences implements SharedPreferencesAsync {
  final Map<String, Object?> state = {};
  String? get value => state['value'] as String?;
  set value(String? value) => state['value'] = value;
  bool get fail => state['fail'] == true;
  set fail(bool value) => state['fail'] = value;
  @override
  Future<String?> getString(String key) async => value;
  @override
  Future<void> setString(String key, String value) async {
    if (fail) throw StateError('Disk unavailable');
    this.value = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'Progress persists, modes stay separate and best stars never decrease',
    () async {
      final prefs = MemoryPreferences();
      final store = ProgressStore(preferences: prefs);
      await store.complete(GameMode.classic, 1, 3);
      await store.complete(GameMode.classic, 1, 1);
      await store.select(GameMode.classic, 2);
      final restored = ProgressStore(preferences: prefs);
      await restored.load();
      expect(restored.stars(GameMode.classic, 1), 3);
      expect(restored.unlocked(GameMode.classic, 2), isTrue);
      expect(restored.unlocked(GameMode.memory, 2), isFalse);
      expect(restored.lastLevel, 2);
      expect(restored.lastMode, GameMode.classic);
      await expectLater(restored.select(GameMode.classic, 3), throwsStateError);
    },
  );
  test('Corrupt and unwritable storage does not crash the app', () async {
    final prefs = MemoryPreferences()..value = 'invalid json';
    final store = ProgressStore(preferences: prefs);
    await store.load();
    expect(store.error, isNotNull);
    expect(store.unlocked(GameMode.classic, 1), isTrue);
    prefs.fail = true;
    await store.select(GameMode.memory, 1);
    expect(store.error, contains('kaydedilemedi'));
  });
  for (final mode in GameMode.values) {
    testWidgets('${mode.title}: menu → levels → preview → back', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final store = ProgressStore(preferences: MemoryPreferences());
      await tester.pumpWidget(TanoraApp(progress: store));
      await tester.ensureVisible(find.text(mode.title));
      await tester.tap(find.text(mode.title));
      await tester.pumpAndSettle();
      expect(find.text('BAŞLANGIÇ'), findsOneWidget);
      await tester.tap(find.text('01'));
      await tester.pumpAndSettle();
      expect(
        find.text(mode == GameMode.classic ? 'Ev' : 'Oyun alanı önizlemesi'),
        findsOneWidget,
      );
      expect(store.lastMode, mode);
      await tester.tap(find.byTooltip('Geri dön'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Geri dön'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Narrow phone with enlarged text remains usable', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      TanoraApp(progress: ProgressStore(preferences: MemoryPreferences())),
    );
    await tester.scrollUntilVisible(find.text('Memory'), 200);
    await tester.tap(find.text('Memory'));
    await tester.pumpAndSettle();
    expect(find.text('BAŞLANGIÇ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
