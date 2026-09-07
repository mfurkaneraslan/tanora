import 'package:flutter/material.dart';

import '../data/progress_store.dart';
import '../models/classic_puzzle.dart';
import '../models/game_mode.dart';
import '../widgets/tangram_play.dart';

class ClassicGameScreen extends StatefulWidget {
  const ClassicGameScreen({
    super.key,
    required this.level,
    required this.progress,
  });
  final int level;
  final ProgressStore progress;
  @override
  State<ClassicGameScreen> createState() => _ClassicGameScreenState();
}

class _ClassicGameScreenState extends State<ClassicGameScreen> {
  late ClassicSession session;
  late PieceTray layout;
  Offset grabOffset = Offset.zero;
  int? active;
  Offset drag = Offset.zero;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    session = ClassicSession(widget.level);
    layout = PieceTray(session.pieces);
  }

  Offset tray(int i) => layout.centers[i];

  Future<void> finish() async {
    setState(() => saving = true);
    final extra = session.moves - session.pieces.length;
    await widget.progress.complete(
      GameMode.classic,
      widget.level,
      extra == 0
          ? 3
          : extra <= 3
          ? 2
          : 1,
    );
    if (mounted) setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const TangramBack(),
      title: Text('Classic · ${widget.level.toString().padLeft(2, '0')}'),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                const Text(
                  'Eve hoş geldin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  session.complete
                      ? 'Bütün parçalar yerini buldu.'
                      : 'Parçayı tut, silüetteki yerine sürükle.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '${session.placed.length} / ${session.pieces.length} parça  ·  ${session.moves} hamle',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final height = layout.height;
                      final availableHeight = constraints.maxHeight;
                      final boardWidth = constraints.maxWidth.clamp(
                        0.0,
                        availableHeight / height * 360,
                      );
                      final scale = boardWidth / 360;
                      return Center(
                        child: Listener(
                          key: const ValueKey('classic-board'),
                          behavior: HitTestBehavior.opaque,
                          onPointerDown: session.complete
                              ? null
                              : (details) {
                                  final p = details.localPosition / scale;
                                  for (
                                    var i = session.pieces.length - 1;
                                    i >= 0;
                                    i--
                                  ) {
                                    if (session.placed.containsKey(i)) continue;
                                    final shape = Path()
                                      ..addPolygon(
                                        session.pieces[i].local
                                            .map((v) => v + tray(i))
                                            .toList(),
                                        true,
                                      );
                                    if (shape.contains(p)) {
                                      setState(() {
                                        active = i;
                                        grabOffset = p - tray(i);
                                        drag = tray(i);
                                      });
                                      break;
                                    }
                                  }
                                },
                          onPointerMove: (details) {
                            if (active != null) {
                              setState(
                                () => drag =
                                    details.localPosition / scale - grabOffset,
                              );
                            }
                          },
                          onPointerUp: (_) {
                            if (active == null) return;
                            setState(() {
                              session.drop(active!, drag);
                              active = null;
                            });
                            if (session.complete) finish();
                          },
                          onPointerCancel: (_) => setState(() => active = null),
                          child: Semantics(
                            label:
                                'Ev silüeti. ${session.pieces.length} sürüklenebilir üçgen.',
                            child: CustomPaint(
                              size: Size(boardWidth, height * scale),
                              painter: _Board(session, active, drag, tray),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!session.complete)
                  const Text(
                    'Parçalar gerçek boyutunda. Yaklaşınca yerine oturur.\nBu başlangıç serisinde döndürmen gerekmiyor.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                if (session.complete) ...[
                  Text(
                    'Bölüm tamamlandı',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: GameMode.classic.color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    saving
                        ? 'Kaydediliyor…'
                        : '${widget.progress.stars(GameMode.classic, widget.level)} / 3 yıldız',
                    textAlign: TextAlign.center,
                  ),
                  if (widget.progress.error != null)
                    Text(widget.progress.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: saving
                        ? null
                        : () async {
                            if (widget.level == 30) {
                              Navigator.of(context).pop();
                              return;
                            }
                            await widget.progress.select(
                              GameMode.classic,
                              widget.level + 1,
                            );
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => ClassicGameScreen(
                                  level: widget.level + 1,
                                  progress: widget.progress,
                                ),
                              ),
                            );
                          },
                    icon: const TangramPlay(color: Color(0xFF0C1226)),
                    label: Text(
                      widget.level == 30
                          ? 'Bölümlere dön'
                          : 'Sonraki bölüm · ${session.pieces.length + 1} parça',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _Board extends CustomPainter {
  _Board(this.session, this.active, this.drag, this.tray);
  final ClassicSession session;
  final int? active;
  final Offset drag;
  final Offset Function(int) tray;
  static const colors = [
    Color(0xFF60DDC2),
    Color(0xFF6B9EFF),
    Color(0xFFFFBD76),
    Color(0xFFB6A1FF),
    Color(0xFFFF8598),
    Color(0xFFFFD879),
  ];
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 360);
    final house = Path()
      ..moveTo(180, 40)
      ..lineTo(260, 120)
      ..lineTo(260, 280)
      ..lineTo(100, 280)
      ..lineTo(100, 120)
      ..close();
    canvas.drawPath(house, Paint()..color = const Color(0xFF25304B));
    canvas.drawPath(
      house,
      Paint()
        ..color = const Color(0xFF54627F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    for (var i = 0; i < session.pieces.length; i++) {
      if (i == active) continue;
      final target = session.placed[i];
      drawPiece(
        canvas,
        i,
        target == null ? tray(i) : session.pieces[target].center,
        1,
      );
    }
    if (active != null) drawPiece(canvas, active!, drag, 1);
  }

  void drawPiece(Canvas canvas, int i, Offset center, double scale) {
    final path = Path()
      ..addPolygon(
        session.pieces[i].local.map((p) => center + p * scale).toList(),
        true,
      );
    canvas.drawPath(path, Paint()..color = colors[i % colors.length]);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF0C1226)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
  }

  @override
  bool shouldRepaint(covariant _Board oldDelegate) => true;
}
