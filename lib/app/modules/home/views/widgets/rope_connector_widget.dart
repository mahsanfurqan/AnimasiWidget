import 'package:flutter/material.dart';

class RopeConnectorWidget extends StatelessWidget {
  const RopeConnectorWidget({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
    required this.start,
    required this.controlOne,
    required this.controlTwo,
    required this.end,
    this.shadowWidth = 6,
    this.strokeWidth = 4.5,
    this.shadowColor = const Color(0x332742A7),
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF4E42D8),
        Color(0xFF4A2CC8),
      ],
    ),
  });

  final double width;
  final double height;
  final double progress;
  final Offset start;
  final Offset controlOne;
  final Offset controlTwo;
  final Offset end;
  final double shadowWidth;
  final double strokeWidth;
  final Color shadowColor;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: IgnorePointer(
        child: CustomPaint(
          painter: _RopeConnectorPainter(
            progress: progress,
            start: start,
            controlOne: controlOne,
            controlTwo: controlTwo,
            end: end,
            shadowWidth: shadowWidth,
            strokeWidth: strokeWidth,
            shadowColor: shadowColor,
            gradient: gradient,
          ),
        ),
      ),
    );
  }
}

class _RopeConnectorPainter extends CustomPainter {
  const _RopeConnectorPainter({
    required this.progress,
    required this.start,
    required this.controlOne,
    required this.controlTwo,
    required this.end,
    required this.shadowWidth,
    required this.strokeWidth,
    required this.shadowColor,
    required this.gradient,
  });

  final double progress;
  final Offset start;
  final Offset controlOne;
  final Offset controlTwo;
  final Offset end;
  final double shadowWidth;
  final double strokeWidth;
  final Color shadowColor;
  final LinearGradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final basePath = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        controlOne.dx,
        controlOne.dy,
        controlTwo.dx,
        controlTwo.dy,
        end.dx,
        end.dy,
      );

    final visiblePath = Path();
    for (final metric in basePath.computeMetrics()) {
      visiblePath.addPath(
        metric.extractPath(0, metric.length * progress),
        Offset.zero,
      );
    }

    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = shadowWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final ropePaint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(start, end))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(visiblePath, shadowPaint);
    canvas.drawPath(visiblePath, ropePaint);
  }

  @override
  bool shouldRepaint(covariant _RopeConnectorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.start != start ||
        oldDelegate.controlOne != controlOne ||
        oldDelegate.controlTwo != controlTwo ||
        oldDelegate.end != end ||
        oldDelegate.shadowWidth != shadowWidth ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.gradient != gradient;
  }
}
