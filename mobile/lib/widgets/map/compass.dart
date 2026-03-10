import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// A compass widget for flutter_map that rotates with the map.
///
/// Usage:
/// ```dart
/// Positioned(
///   top: 70,
///   left: 30,
///   child: CompassWidget(mapController: mapController),
/// )
/// ```
class CompassWidget extends StatefulWidget {
  final MapController mapController;

  /// Size of the compass widget (default: 60)
  final double size;

  /// Called when user taps the compass to reset north
  final VoidCallback? onTap;

  const CompassWidget({
    super.key,
    required this.mapController,
    this.size = 60,
    this.onTap,
  });

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    // Listen to map events for rotation changes
    widget.mapController.mapEventStream.listen((event) {
      if (mounted) {
        setState(() {
          _rotation = widget.mapController.camera.rotation;
        });
      }
    });
  }

  void _resetNorth() {
    widget.mapController.rotate(0);
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetNorth,
      child: AnimatedRotation(
        turns: _rotation / 360,
        duration: const Duration(milliseconds: 150),
        child: _CompassPainterWidget(size: widget.size),
      ),
    );
  }
}

class _CompassPainterWidget extends StatelessWidget {
  final double size;

  const _CompassPainterWidget({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _CompassDialPainter(),
        child: Center(
          child: CustomPaint(
            size: Size(size * 0.55, size * 0.55),
            painter: _CompassNeedlePainter(),
          ),
        ),
      ),
    );
  }
}

/// Draws the outer compass dial with N/S/E/W labels
class _CompassDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer ring
    final ringPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 2, ringPaint);

    // Tick marks
    final tickPaint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 36; i++) {
      final angle = (i * 10) * math.pi / 180;
      final isCardinal = i % 9 == 0;
      final isMajor = i % 3 == 0;

      final tickLength = isCardinal
          ? 0.0
          : (isMajor ? radius * 0.10 : radius * 0.06);
      if (isCardinal) continue;

      final outerPoint = Offset(
        center.dx + (radius - 4) * math.sin(angle),
        center.dy - (radius - 4) * math.cos(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 4 - tickLength) * math.sin(angle),
        center.dy - (radius - 4 - tickLength) * math.cos(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // Cardinal direction labels
    _drawCardinalLabel(
      canvas,
      size,
      'Хойд',
      0,
      const Color(0xFFD32F2F),
      bold: true,
    );
    _drawCardinalLabel(canvas, size, 'Ө', math.pi, const Color(0xFF424242));
    _drawCardinalLabel(canvas, size, 'Б', math.pi / 2, const Color(0xFF424242));
    _drawCardinalLabel(
      canvas,
      size,
      'З',
      -math.pi / 2,
      const Color(0xFF424242),
    );
  }

  void _drawCardinalLabel(
    Canvas canvas,
    Size size,
    String label,
    double angle,
    Color color, {
    bool bold = false,
  }) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final labelRadius = radius - radius * 0.22;

    final pos = Offset(
      center.dx + labelRadius * math.sin(angle),
      center.dy - labelRadius * math.cos(angle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.18,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      pos - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Draws the compass needle (red = north, white = south)
class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final halfH = size.height / 2;
    final halfW = size.width * 0.18;

    // North needle (red)
    final northPath = Path()
      ..moveTo(center.dx, center.dy - halfH)
      ..lineTo(center.dx - halfW, center.dy)
      ..lineTo(center.dx, center.dy - halfH * 0.15)
      ..lineTo(center.dx + halfW, center.dy)
      ..close();

    canvas.drawPath(northPath, Paint()..color = const Color(0xFFD32F2F));
    canvas.drawPath(
      northPath,
      Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // South needle (light grey)
    final southPath = Path()
      ..moveTo(center.dx, center.dy + halfH)
      ..lineTo(center.dx - halfW, center.dy)
      ..lineTo(center.dx, center.dy + halfH * 0.15)
      ..lineTo(center.dx + halfW, center.dy)
      ..close();

    canvas.drawPath(southPath, Paint()..color = const Color(0xFFEEEEEE));
    canvas.drawPath(
      southPath,
      Paint()
        ..color = Colors.black.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Center dot
    canvas.drawCircle(center, size.width * 0.10, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      size.width * 0.07,
      Paint()..color = const Color(0xFF616161),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
