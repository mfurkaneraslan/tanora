import 'package:flutter/material.dart';

enum GameMode {
  classic(
    'Classic',
    'Her parça yerini bulur.',
    'Silüeti 7 parçayla tamamla. Kendi hızında, adım adım.',
    Color(0xFF60DDC2),
    Icons.category_outlined,
  ),
  minimalMoves(
    'Minimal Moves',
    'Az hamle. Büyük fikir.',
    'Yanlış yerleşmiş parçaları en az hamlede düzelt.',
    Color(0xFFFFBD76),
    Icons.alt_route_rounded,
  ),
  memory(
    'Memory',
    'Bak. Hatırla. Tamamla.',
    'Silüeti 3 saniye incele, sonra hafızandan oluştur.',
    Color(0xFFB6A1FF),
    Icons.psychology_outlined,
  );

  const GameMode(
    this.title,
    this.subtitle,
    this.description,
    this.color,
    this.icon,
  );
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final IconData icon;
  static const levelCount = 30;
}
