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
    this.bendStart,
    this.bendEnd,
    this.mid,
    this.controlThree,
    this.controlFour,
    this.shadowWidth = 6,
    this.strokeWidth = 4.5,
    this.shadowColor = const Color(0x332742A7),
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4E42D8), Color(0xFF4A2CC8)],
    ),
  });

  final double width;
  final double height;
  final double progress;
  final Offset start;
  final Offset controlOne;
  final Offset controlTwo;
  final Offset end;
  final Offset? bendStart;
  final Offset? bendEnd;
  final Offset? mid;
  final Offset? controlThree;
  final Offset? controlFour;
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
            bendStart: bendStart,
            bendEnd: bendEnd,
            mid: mid,
            controlThree: controlThree,
            controlFour: controlFour,
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
    required this.bendStart,
    required this.bendEnd,
    required this.mid,
    required this.controlThree,
    required this.controlFour,
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
  final Offset? bendStart;
  final Offset? bendEnd;
  final Offset? mid;
  final Offset? controlThree;
  final Offset? controlFour;
  final double shadowWidth;
  final double strokeWidth;
  final Color shadowColor;
  final LinearGradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final basePath = Path()..moveTo(start.dx, start.dy);

    if (bendStart != null && bendEnd != null) {
      final horizontalSpan = end.dx - bendStart!.dx;
      final rise = bendStart!.dy - end.dy;
      final controlOne = Offset(
        bendStart!.dx + (horizontalSpan * 0.90),
        bendStart!.dy,
      );
      final controlTwo = Offset(
        end.dx - (horizontalSpan * 0.010),
        end.dy + (rise * 0.90),
      );

      basePath
        ..lineTo(bendStart!.dx, bendStart!.dy)
        ..cubicTo(
          controlOne.dx,
          controlOne.dy,
          controlTwo.dx,
          controlTwo.dy,
          end.dx,
          end.dy,
        );
    } else if (mid != null && controlThree != null && controlFour != null) {
      basePath
        ..cubicTo(
          controlOne.dx,
          controlOne.dy,
          controlTwo.dx,
          controlTwo.dy,
          mid!.dx,
          mid!.dy,
        )
        ..cubicTo(
          controlThree!.dx,
          controlThree!.dy,
          controlFour!.dx,
          controlFour!.dy,
          end.dx,
          end.dy,
        );
    } else {
      basePath.cubicTo(
        controlOne.dx,
        controlOne.dy,
        controlTwo.dx,
        controlTwo.dy,
        end.dx,
        end.dy,
      );
    }

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
        oldDelegate.bendStart != bendStart ||
        oldDelegate.bendEnd != bendEnd ||
        oldDelegate.mid != mid ||
        oldDelegate.controlThree != controlThree ||
        oldDelegate.controlFour != controlFour ||
        oldDelegate.end != end ||
        oldDelegate.shadowWidth != shadowWidth ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.gradient != gradient;
  }
}
