import 'package:flutter/services.dart';

void playSnapSound() {
  SystemSound.play(SystemSoundType.click).catchError((Object _) {});
}
