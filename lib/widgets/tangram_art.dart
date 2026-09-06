import 'package:flutter/material.dart';

class TangramArt extends StatelessWidget {
  const TangramArt({super.key, this.size = 180});
  final double size;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Yedi renkli tangram parçası',
    image: true,
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _TangramPainter()),
    ),
  );
}

class _TangramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.12);
    canvas.scale(size.width / 260);
    canvas.translate(-100, -100);
    final shapes = <List<Offset>>[
      [const Offset(0, 0), const Offset(200, 0), const Offset(100, 100)],
      [const Offset(0, 0), const Offset(100, 100), const Offset(0, 200)],
      [const Offset(200, 100), const Offset(200, 200), const Offset(100, 200)],
      [const Offset(100, 100), const Offset(150, 50), const Offset(150, 150)],
      [const Offset(0, 200), const Offset(50, 150), const Offset(100, 200)],
      [
        const Offset(50, 150),
        const Offset(100, 100),
        const Offset(150, 150),
        const Offset(100, 200),
      ],
      [
        const Offset(150, 50),
        const Offset(200, 0),
        const Offset(200, 100),
        const Offset(150, 150),
      ],
    ];
    const colors = [
      Color(0xFF60DDC2),
      Color(0xFF6B9EFF),
      Color(0xFFFFBF78),
      Color(0xFFB69AFF),
      Color(0xFFFF8598),
      Color(0xFFFFD879),
      Color(0xFF7881EE),
    ];
    for (var i = 0; i < shapes.length; i++) {
      final path = Path()..addPolygon(shapes[i], true);
      canvas.drawPath(path, Paint()..color = colors[i]);
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF0C1226)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
