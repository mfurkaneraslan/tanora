import 'package:flutter/material.dart';

import 'data/progress_store.dart';
import 'screens/home_screen.dart';

class TanoraApp extends StatelessWidget {
  const TanoraApp({super.key, required this.progress});
  final ProgressStore progress;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TANORA',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0C1226),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF60DDC2),
        brightness: Brightness.dark,
        surface: const Color(0xFF151E36),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0C1226),
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFADB7D0), height: 1.5),
      ),
    ),
    home: HomeScreen(progress: progress),
  );
}
