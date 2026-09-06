import 'package:flutter/material.dart';

import 'app.dart';
import 'data/progress_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progress = ProgressStore();
  await progress.load();
  runApp(TanoraApp(progress: progress));
}
