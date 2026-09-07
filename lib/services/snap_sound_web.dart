import 'dart:js_interop';

@JS('Audio')
extension type _Audio._(JSObject _) implements JSObject {
  external factory _Audio(String source);
  external set volume(double value);
  external JSPromise<JSAny?> play();
}

/// Called directly from pointer-up so browser gesture permission is retained.
void playSnapSound() {
  try {
    final audio = _Audio('assets/assets/audio/snap.wav')..volume = 0.45;
    audio.play().toDart.then<void>((_) {}, onError: (Object _) {});
  } catch (_) {
    // Audio availability must never interrupt a successful placement.
  }
}
