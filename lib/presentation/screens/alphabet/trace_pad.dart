import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';

/// Barmoq bilan harf yozish maydoni.
///
/// Harf andozasi (Andika shrifti) xira rangda chiziladi. Bola chizgan iz
/// harfning qanchasini qoplagani ([coverage]) va izning qanchasi harf
/// ustida ekani ([accuracy]) bo'yicha baholanadi. Shu tufayli 5 xil
/// alifboning har bir harfi uchun alohida chizma ma'lumoti kerak emas,
/// tasodifiy chiziqlar esa qabul qilinmaydi.
class TracePad extends StatefulWidget {
  const TracePad({
    super.key,
    required this.glyph,
    required this.color,
    required this.onSuccess,
    this.onStrokeOutside,
    this.size = 280,
  });

  final String glyph;
  final Color color;
  final VoidCallback onSuccess;

  /// Iz harfdan juda ko'p chiqib ketganda (bir marta) chaqiriladi.
  final VoidCallback? onStrokeOutside;
  final double size;

  @override
  State<TracePad> createState() => TracePadState();
}

class TracePadState extends State<TracePad> {
  static const int _res = 80;
  static const double _needCoverage = 0.58;
  static const double _needAccuracy = 0.55;

  List<bool>? _mask;
  int _glyphCells = 0;
  final List<List<Offset>> _strokes = [];
  final Set<int> _covered = {};
  int _onGlyph = 0;
  int _samples = 0;
  bool _done = false;
  bool _warned = false;

  double get coverage => _glyphCells == 0 ? 0 : _covered.length / _glyphCells;

  TextStyle _style(double fontSize) => TextStyle(
        fontFamily: AppFonts.letters,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.0,
      );

  double get _fontSize => widget.size * (widget.glyph.runes.length > 1 ? 0.5 : 0.72);

  @override
  void initState() {
    super.initState();
    _buildMask();
  }

  @override
  void didUpdateWidget(covariant TracePad old) {
    super.didUpdateWidget(old);
    if (old.glyph != widget.glyph || old.size != widget.size) {
      reset();
      _mask = null;
      _buildMask();
    }
  }

  void reset() {
    setState(() {
      _strokes.clear();
      _covered.clear();
      _onGlyph = 0;
      _samples = 0;
      _done = false;
      _warned = false;
    });
  }

  Future<void> _buildMask() async {
    final scale = _res / widget.size;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(scale);
    final tp = TextPainter(
      text: TextSpan(text: widget.glyph, style: _style(_fontSize).copyWith(color: Colors.black)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((widget.size - tp.width) / 2, (widget.size - tp.height) / 2));
    final img = await recorder.endRecording().toImage(_res, _res);
    final data = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
    img.dispose();
    if (data == null || !mounted) return;
    final bytes = data.buffer.asUint8List();
    final mask = List<bool>.generate(_res * _res, (i) => bytes[i * 4 + 3] > 60);
    setState(() {
      _mask = mask;
      _glyphCells = mask.where((b) => b).length;
    });
  }

  bool _isGlyph(int x, int y, {int radius = 2}) {
    final m = _mask;
    if (m == null) return false;
    for (var dy = -radius; dy <= radius; dy++) {
      for (var dx = -radius; dx <= radius; dx++) {
        final xx = x + dx, yy = y + dy;
        if (xx < 0 || yy < 0 || xx >= _res || yy >= _res) continue;
        if (m[yy * _res + xx]) return true;
      }
    }
    return false;
  }

  void _record(Offset p) {
    final m = _mask;
    if (m == null) return;
    final x = (p.dx / widget.size * _res).floor().clamp(0, _res - 1);
    final y = (p.dy / widget.size * _res).floor().clamp(0, _res - 1);
    _samples++;
    if (_isGlyph(x, y)) _onGlyph++;
    // Barmoq izi qalinligi ~ 4 katak
    const r = 4;
    for (var dy = -r; dy <= r; dy++) {
      for (var dx = -r; dx <= r; dx++) {
        if (dx * dx + dy * dy > r * r) continue;
        final xx = x + dx, yy = y + dy;
        if (xx < 0 || yy < 0 || xx >= _res || yy >= _res) continue;
        final idx = yy * _res + xx;
        if (m[idx]) _covered.add(idx);
      }
    }
  }

  void _onStart(DragStartDetails d) {
    if (_done || _mask == null) return;
    setState(() {
      _strokes.add([d.localPosition]);
      _record(d.localPosition);
    });
  }

  void _onUpdate(DragUpdateDetails d) {
    if (_done || _mask == null || _strokes.isEmpty) return;
    final last = _strokes.last.last;
    final next = d.localPosition;
    final steps = max(1, ((next - last).distance / 3).round());
    for (var i = 1; i <= steps; i++) {
      _record(Offset.lerp(last, next, i / steps)!);
    }
    setState(() => _strokes.last.add(next));
  }

  void _onEnd(DragEndDetails _) {
    if (_done || _glyphCells == 0) return;
    final accuracy = _samples == 0 ? 0.0 : _onGlyph / _samples;
    if (coverage >= _needCoverage && accuracy >= _needAccuracy) {
      setState(() => _done = true);
      HapticFeedback.mediumImpact();
      AudioService.instance.play(Sfx.correct);
      widget.onSuccess();
    } else if (_samples > 30 && accuracy < 0.35 && !_warned) {
      _warned = true;
      widget.onStrokeOutside?.call();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final style = _style(_fontSize);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: _done ? AppColors.correct : AppColors.tint(widget.color, 0.55), width: 3),
        boxShadow: [BoxShadow(color: AppColors.tint(widget.color, 0.6), offset: const Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Stack(
          children: [
            // Daftar chiziqlari
            Positioned.fill(child: CustomPaint(painter: _GuidePainter())),
            // Harf andozasi: xira to'ldirish + rangli kontur
            Center(
              child: Text(widget.glyph,
                  style: style.copyWith(color: AppColors.tint(widget.color, _done ? 0.55 : 0.86))),
            ),
            Center(
              child: Text(
                widget.glyph,
                style: style.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2.5
                    ..color = AppColors.tint(widget.color, 0.35),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onPanStart: _onStart,
                onPanUpdate: _onUpdate,
                onPanEnd: _onEnd,
                child: CustomPaint(
                  painter: _InkPainter(
                    strokes: _strokes,
                    color: _done ? AppColors.correct : widget.color,
                    width: size * 0.07,
                  ),
                ),
              ),
            ),
            if (_mask == null) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class _GuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFE9E1D3)
      ..strokeWidth = 1.5;
    for (final f in const [0.2, 0.5, 0.8]) {
      canvas.drawLine(Offset(16, size.height * f), Offset(size.width - 16, size.height * f), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InkPainter extends CustomPainter {
  _InkPainter({required this.strokes, required this.color, required this.width});
  final List<List<Offset>> strokes;
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(s.first, width / 2, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
        continue;
      }
      final path = Path()..moveTo(s.first.dx, s.first.dy);
      for (var i = 1; i < s.length; i++) {
        path.lineTo(s[i].dx, s[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _InkPainter old) => true;
}
