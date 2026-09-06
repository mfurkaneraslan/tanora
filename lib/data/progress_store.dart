import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_mode.dart';

/// Versioned local storage. Only the future puzzle engine may award completion.
class ProgressStore extends ChangeNotifier {
  ProgressStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();
  final SharedPreferencesAsync _preferences;
  static const storageKey = 'tangram.progress.v1';
  Map<String, int> _stars = {};
  GameMode? lastMode;
  int lastLevel = 1;
  String? error;
  int stars(GameMode mode, int level) => _stars['${mode.name}:$level'] ?? 0;
  bool unlocked(GameMode mode, int level) =>
      level >= 1 &&
      level <= GameMode.levelCount &&
      (level == 1 || stars(mode, level - 1) > 0);
  int completed(GameMode mode) => List.generate(
    GameMode.levelCount,
    (i) => stars(mode, i + 1),
  ).where((s) => s > 0).length;
  int get totalStars => _stars.values.fold(0, (a, b) => a + b);
  Future<void> load() async {
    try {
      final raw = await _preferences.getString(storageKey);
      if (raw == null) return;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final saved = data['stars'] as Map<String, dynamic>;
      final parsed = <String, int>{};
      for (final mode in GameMode.values) {
        for (var level = 1; level <= GameMode.levelCount; level++) {
          final key = '${mode.name}:$level';
          final value = saved[key];
          if (value is int && value >= 1 && value <= 3) parsed[key] = value;
        }
      }
      _stars = parsed;
      for (final mode in GameMode.values) {
        if (mode.name == data['lastMode']) lastMode = mode;
      }
      final level = data['lastLevel'];
      lastLevel = level is int && lastMode != null && unlocked(lastMode!, level)
          ? level
          : 1;
    } catch (_) {
      error = 'Yerel kayıt okunamadı. Yeni oturumla devam edebilirsin.';
    }
    notifyListeners();
  }

  Future<void> select(GameMode mode, int level) async {
    if (!unlocked(mode, level)) throw StateError('Bölüm kilitli');
    lastMode = mode;
    lastLevel = level;
    await _save();
  }

  Future<void> complete(GameMode mode, int level, int score) async {
    if (!unlocked(mode, level) || score < 1 || score > 3) {
      throw ArgumentError('Geçersiz sonuç');
    }
    final key = '${mode.name}:$level';
    if (score > stars(mode, level)) _stars[key] = score;
    await _save();
  }

  Future<void> _save() async {
    try {
      await _preferences.setString(
        storageKey,
        jsonEncode({
          'stars': _stars,
          'lastMode': lastMode?.name,
          'lastLevel': lastLevel,
        }),
      );
      error = null;
    } catch (_) {
      error = 'İlerleme cihazına kaydedilemedi. Bu oturumda devam edebilirsin.';
    }
    notifyListeners();
  }
}
