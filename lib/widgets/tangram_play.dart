import 'package:flutter/material.dart';

class TangramPlay extends StatelessWidget {
  const TangramPlay({
    super.key,
    this.color = const Color(0xFF60DDC2),
    this.size = 22,
    this.back = false,
  });
  final Color color;
  final double size;
  final bool back;
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: back ? 3.14159265359 : 0,
    child: CustomPaint(size: Size.square(size), painter: _Triangle(color)),
  );
}

class _Triangle extends CustomPainter {
  _Triangle(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * .18, size.height * .1)
      ..lineTo(size.width * .9, size.height * .5)
      ..lineTo(size.width * .18, size.height * .9)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _Triangle oldDelegate) =>
      oldDelegate.color != color;
}

class TangramBack extends StatelessWidget {
  const TangramBack({super.key});
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Geri dön',
    onPressed: () => Navigator.of(context).maybePop(),
    icon: const TangramPlay(back: true),
  );
}
