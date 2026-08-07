import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Finger-tracing practice widget (TZ 4.1 "Chizish rejimi" / 4.2 "Yozib
/// ko'rish").
///
/// There are no per-letter SVG stroke paths available for 6 different
/// scripts, so instead of matching exact stroke order this widget renders
/// the target text to an offscreen low-resolution alpha mask and scores
/// the child's drawing by how much of the glyph the strokes cover (and how
/// much of the strokes actually land on the glyph). That's a pragmatic
/// substitute that still rewards "tracing the letter" and rejects random
/// scribbling, without requiring hand-authored vector data per character.
class TraceCanvas extends StatefulWidget {
  final String text;
  final double size;
  final VoidCallback onSuccess;

  const TraceCanvas({
    super.key,
    required this.text,
    required this.onSuccess,
    this.size = 260,
  });

  @override
  State<TraceCanvas> createState() => _TraceCanvasState();
}

class _TraceCanvasState extends State<TraceCanvas> {
  static const int _maskRes = 64;
  static const double _coverageThreshold = 0.42;
  static const double _accuracyThreshold = 0.35;
  static const double _brushRadiusInMaskCells = 2.2;

  List<bool>? _mask;
  int _glyphPixelCount = 0;
  bool _ready = false;
  bool? _lastResultSuccess;

  final List<Offset?> _strokePoints = [];
  final Set<int> _touchedGlyphCells = {};
  int _onGlyphSamples = 0;
  int _totalSamples = 0;
  Offset? _lastPoint;

  @override
  void initState() {
    super.initState();
    _buildMask();
  }

  @override
  void didUpdateWidget(covariant TraceCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _ready = false;
      _mask = null;
      _resetStrokes();
      _buildMask();
    }
  }

  Future<void> _buildMask() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder, Rect.fromLTWH(0, 0, _maskRes.toDouble(), _maskRes.toDouble()));
    final tp = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: TextStyle(
          fontSize: _maskRes * 0.72,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF000000),
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: _maskRes * 2.5);

    final offset = Offset(
      (_maskRes - tp.width) / 2,
      (_maskRes - tp.height) / 2,
    );
    tp.paint(canvas, offset);
    final picture = recorder.endRecording();
    final image = await picture.toImage(_maskRes, _maskRes);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null || !mounted) return;

    final bytes = byteData.buffer.asUint8List();
    final mask = List<bool>.filled(_maskRes * _maskRes, false);
    for (int i = 0; i < mask.length; i++) {
      final alpha = bytes[i * 4 + 3];
      mask[i] = alpha > 40;
    }

    setState(() {
      _mask = mask;
      _glyphPixelCount = mask.where((b) => b).length;
      _ready = true;
    });
  }

  void _resetStrokes() {
    _strokePoints.clear();
    _touchedGlyphCells.clear();
    _onGlyphSamples = 0;
    _totalSamples = 0;
    _lastPoint = null;
    _lastResultSuccess = null;
  }

  (int, int) _toMaskCell(Offset local) {
    final mx = (local.dx / widget.size * _maskRes).floor().clamp(0, _maskRes - 1);
    final my = (local.dy / widget.size * _maskRes).floor().clamp(0, _maskRes - 1);
    return (mx, my);
  }

  bool _isGlyphAt(int mx, int my) {
    final mask = _mask;
    if (mask == null) return false;
    for (int dy = -_brushRadiusInMaskCells.toInt(); dy <= _brushRadiusInMaskCells.toInt(); dy++) {
      for (int dx = -_brushRadiusInMaskCells.toInt(); dx <= _brushRadiusInMaskCells.toInt(); dx++) {
        final x = mx + dx;
        final y = my + dy;
        if (x < 0 || y < 0 || x >= _maskRes || y >= _maskRes) continue;
        if (dx * dx + dy * dy > _brushRadiusInMaskCells * _brushRadiusInMaskCells) continue;
        if (mask[y * _maskRes + x]) return true;
      }
    }
    return false;
  }

  void _markCellsAround(int mx, int my) {
    final r = _brushRadiusInMaskCells.toInt();
    for (int dy = -r; dy <= r; dy++) {
      for (int dx = -r; dx <= r; dx++) {
        final x = mx + dx;
        final y = my + dy;
        if (x < 0 || y < 0 || x >= _maskRes || y >= _maskRes) continue;
        if (dx * dx + dy * dy > _brushRadiusInMaskCells * _brushRadiusInMaskCells) continue;
        if (_mask != null && _mask![y * _maskRes + x]) {
          _touchedGlyphCells.add(y * _maskRes + x);
        }
      }
    }
  }

  void _recordPoint(Offset local) {
    final (mx, my) = _toMaskCell(local);
    _totalSamples++;
    if (_isGlyphAt(mx, my)) _onGlyphSamples++;
    _markCellsAround(mx, my);
  }

  void _onPanStart(DragStartDetails details) {
    if (!_ready) return;
    setState(() {
      _lastResultSuccess = null;
      _strokePoints.add(details.localPosition);
      _lastPoint = details.localPosition;
      _recordPoint(details.localPosition);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_ready) return;
    setState(() {
      // Interpolate so fast swipes don't leave gaps in the coverage check.
      final prev = _lastPoint ?? details.localPosition;
      final next = details.localPosition;
      final dist = (next - prev).distance;
      final steps = max(1, (dist / 4).round());
      for (int i = 1; i <= steps; i++) {
        final p = Offset.lerp(prev, next, i / steps)!;
        _recordPoint(p);
      }
      _strokePoints.add(next);
      _lastPoint = next;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _strokePoints.add(null);
    _lastPoint = null;
    if (_glyphPixelCount == 0) return;
    final coverage = _touchedGlyphCells.length / _glyphPixelCount;
    final accuracy = _totalSamples == 0 ? 0.0 : _onGlyphSamples / _totalSamples;
    final success = coverage >= _coverageThreshold && accuracy >= _accuracyThreshold;
    setState(() => _lastResultSuccess = success);
    if (success) widget.onSuccess();
  }

  void _clear() {
    setState(_resetStrokes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black12, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.size * 0.55,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withValues(alpha: 0.14),
                    ),
                  ),
                ),
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _StrokePainter(
                      points: _strokePoints,
                      color: _lastResultSuccess == true
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                  ),
                ),
                if (!_ready)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _clear,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Tozalash'),
        ),
      ],
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  _StrokePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) => true;
}
