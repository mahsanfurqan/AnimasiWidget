import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloatingTwoWidget extends StatefulWidget {
  const FloatingTwoWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<FloatingTwoWidget> createState() => _FloatingTwoWidgetState();
}

class _FloatingTwoWidgetState extends State<FloatingTwoWidget>
    with SingleTickerProviderStateMixin {
  static const List<_FloatingTwoSpec> _objects = [
    _FloatingTwoSpec(
      shapeGlyph: _ShapeGlyphType.circle,
      leftFactor: 0.13,
      topFactor: 0.34,
      widthFactor: 0.030,
      pulseScaleAmplitude: 0.085,
      phase: 0.02,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingTwoSpec(
      shapeGlyph: _ShapeGlyphType.square,
      leftFactor: 0.30,
      topFactor: 0.14,
      widthFactor: 0.030,
      pulseScaleAmplitude: 0.085,
      phase: 0.16,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/blok square.svg',
      leftFactor: 0.19,
      topFactor: 0.05,
      widthFactor: 0.035,
      pulseScaleAmplitude: 0.085,
      phase: 0.16,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/compass.svg',
      leftFactor: 0.21,
      topFactor: 0.40,
      widthFactor: 0.030,
      pulseScaleAmplitude: 0.085,
      phase: 0.34,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.020,
    ),
    _FloatingTwoSpec(
      shapeGlyph: _ShapeGlyphType.triangle,
      leftFactor: 0.30,
      topFactor: 0.38,
      widthFactor: 0.030,
      pulseScaleAmplitude: 0.085,
      phase: 0.52,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.020,
    ),
    _FloatingTwoSpec(
      shapeGlyph: _ShapeGlyphType.fractionPie,
      leftFactor: 0.85,
      topFactor: 0.60,
      widthFactor: 0.065,
      pulseScaleAmplitude: 0.085,
      phase: 0.62,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingTwoSpec(
      shapeGlyph: _ShapeGlyphType.protractor,
      leftFactor: 0.42,
      topFactor: 0.01,
      widthFactor: 0.060,
      pulseScaleAmplitude: 0.085,
      phase: 0.80,
      driftXAmplitude: 0.20,
      floatAmplitude: 0.6,
      rotationAmplitude: 0.0,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/lamp.svg',
      leftFactor: 0.70,
      topFactor: 0.02,
      widthFactor: 0.033,
      pulseScaleAmplitude: 0.050,
      flipX: true,
      phase: 0.30,
      driftXAmplitude: 0.28,
      floatAmplitude: 0.7,
      rotationAmplitude: 0.012,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/telescope.svg',
      leftFactor: 0.52,
      topFactor: 0.30,
      widthFactor: 0.06,
      flipX: true,
      pulseScaleAmplitude: 0.060,
      phase: 0.10,
      driftXAmplitude: 1.4,
      floatAmplitude: 4.0,
      rotationAmplitude: 0.035,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/shield2.svg',
      leftFactor: 0.77,
      topFactor: 0.15,
      widthFactor: 0.075,
      pulseScaleAmplitude: 0.060,
      phase: 0.42,
      driftXAmplitude: 1.6,
      floatAmplitude: 4.8,
      rotationAmplitude: 0.040,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/key.svg',
      leftFactor: 0.75,
      topFactor: 0.51,
      widthFactor: 0.034,
      baseRotation: math.pi / 2,
      pulseScaleAmplitude: 0.060,
      flipY: true,
      phase: 0.74,
      driftXAmplitude: 1.0,
      floatAmplitude: 3.0,
      rotationAmplitude: 0.028,
    ),
  ];

  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _floatCtrl,
          builder: (context, _) {
            return Stack(
              children: _objects.map((object) {
                final phase =
                    ((_floatCtrl.value + object.phase) % 1.0) * math.pi * 2;
                final driftX = math.cos(phase) * object.driftXAmplitude;
                final driftY = math.sin(phase) * object.floatAmplitude;
                final rotation =
                    object.baseRotation +
                    (math.sin(phase) * object.rotationAmplitude);
                final scale =
                    1.0 + (math.sin(phase) * object.pulseScaleAmplitude);
                final objectWidth = widget.width * object.widthFactor;
                final left = (widget.width * object.leftFactor) + driftX;
                final top = (widget.height * object.topFactor) + driftY;

                return Positioned(
                  left: left,
                  top: top,
                  child: Transform.rotate(
                    angle: rotation,
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: object.asset != null
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.diagonal3Values(
                                object.flipX ? -1.0 : 1.0,
                                object.flipY ? -1.0 : 1.0,
                                1.0,
                              ),
                              child: SvgPicture.asset(
                                object.asset!,
                                width: objectWidth,
                                fit: BoxFit.contain,
                              ),
                            )
                          : _MathGlyph(
                              type: object.shapeGlyph!,
                              size: objectWidth,
                            ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _FloatingTwoSpec {
  const _FloatingTwoSpec({
    this.asset,
    this.shapeGlyph,
    required this.leftFactor,
    required this.topFactor,
    required this.widthFactor,
    this.baseRotation = 0,
    this.pulseScaleAmplitude = 0,
    this.flipX = false,
    this.flipY = false,
    required this.phase,
    required this.driftXAmplitude,
    required this.floatAmplitude,
    required this.rotationAmplitude,
  }) : assert(asset != null || shapeGlyph != null);

  final String? asset;
  final _ShapeGlyphType? shapeGlyph;
  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final double baseRotation;
  final double pulseScaleAmplitude;
  final bool flipX;
  final bool flipY;
  final double phase;
  final double driftXAmplitude;
  final double floatAmplitude;
  final double rotationAmplitude;
}

enum _ShapeGlyphType {
  circle,
  square,
  hexagon,
  triangle,
  fractionPie,
  protractor,
}

class _MathGlyph extends StatelessWidget {
  const _MathGlyph({required this.type, required this.size});

  final _ShapeGlyphType type;
  final double size;

  static const Color _strokeColor = Color(0xFF7A4266);
  static const Color _circleFill = Color(0xFFF0A0B2);
  static const Color _squareFill = Color(0xFFF0A393);
  static const Color _hexagonFill = Color(0xFFBEA0CF);
  static const Color _triangleFill = Color(0xFFF3B489);
  static const Color _fractionFill = Color(0xFFF0A0B2);
  static const Color _fractionAccent = Color(0xFFCCB7F1);
  static const Color _protractorFill = Color(0xFFF0A0B2);

  @override
  Widget build(BuildContext context) {
    final glyphWidth = size;
    final glyphHeight = type == _ShapeGlyphType.protractor ? size * 0.86 : size;

    return SizedBox(
      width: glyphWidth,
      height: glyphHeight,
      child: CustomPaint(
        painter: _ShapeGlyphPainter(
          type: type,
          fillColor: _backgroundColor,
          accentColor: _accentColor,
          strokeColor: _strokeColor,
        ),
        child: _labelText == null
            ? null
            : Center(
                child: Transform.translate(
                  offset: Offset(-size * 0.10, size * 0.07),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '1',
                        style: TextStyle(
                          color: _strokeColor,
                          fontSize: size * 0.20,
                          fontWeight: FontWeight.w700,
                          height: 0.9,
                        ),
                      ),
                      Container(
                        width: size * 0.16,
                        height: size * 0.016,
                        decoration: BoxDecoration(
                          color: _strokeColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Text(
                        '5',
                        style: TextStyle(
                          color: _strokeColor,
                          fontSize: size * 0.20,
                          fontWeight: FontWeight.w700,
                          height: 0.9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case _ShapeGlyphType.circle:
        return _circleFill;
      case _ShapeGlyphType.square:
        return _squareFill;
      case _ShapeGlyphType.hexagon:
        return _hexagonFill;
      case _ShapeGlyphType.triangle:
        return _triangleFill;
      case _ShapeGlyphType.fractionPie:
        return _fractionFill;
      case _ShapeGlyphType.protractor:
        return _protractorFill;
    }
  }

  Color? get _accentColor {
    switch (type) {
      case _ShapeGlyphType.fractionPie:
        return _fractionAccent;
      case _ShapeGlyphType.circle:
      case _ShapeGlyphType.square:
      case _ShapeGlyphType.hexagon:
      case _ShapeGlyphType.triangle:
      case _ShapeGlyphType.protractor:
        return null;
    }
  }

  String? get _labelText {
    switch (type) {
      case _ShapeGlyphType.fractionPie:
        return 'fraction';
      case _ShapeGlyphType.circle:
      case _ShapeGlyphType.square:
      case _ShapeGlyphType.hexagon:
      case _ShapeGlyphType.triangle:
      case _ShapeGlyphType.protractor:
        return null;
    }
  }
}

class _ShapeGlyphPainter extends CustomPainter {
  const _ShapeGlyphPainter({
    required this.type,
    required this.fillColor,
    required this.accentColor,
    required this.strokeColor,
  });

  final _ShapeGlyphType type;
  final Color fillColor;
  final Color? accentColor;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (type == _ShapeGlyphType.fractionPie) {
      _paintFractionPie(canvas, size);
      return;
    }

    if (type == _ShapeGlyphType.protractor) {
      _paintProtractor(canvas, size);
      return;
    }

    final path = _buildPath(size);
    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.07
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintFractionPie(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.36;
    final circleRect = Rect.fromCircle(center: center, radius: radius);
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final accentPaint = Paint()
      ..color = accentColor ?? fillColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, fillPaint);

    final slicePath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx, center.dy - radius)
      ..arcTo(circleRect, -math.pi / 2, math.pi / 2, false)
      ..close();
    canvas.drawPath(slicePath, accentPaint);

    canvas.drawCircle(center, radius, strokePaint);
    canvas.drawLine(center, Offset(center.dx, center.dy - radius), strokePaint);
    canvas.drawLine(center, Offset(center.dx + radius, center.dy), strokePaint);
  }

  void _paintProtractor(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.032;
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final outerPath = Path()
      ..moveTo(size.width * 0.16, size.height * 0.18)
      ..lineTo(size.width * 0.16, size.height * 0.88)
      ..lineTo(size.width * 0.92, size.height * 0.88)
      ..close();

    final innerCutout = Path()
      ..moveTo(size.width * 0.34, size.height * 0.56)
      ..lineTo(size.width * 0.34, size.height * 0.70)
      ..lineTo(size.width * 0.50, size.height * 0.70)
      ..close();

    canvas.saveLayer(null, Paint());
    canvas.drawPath(outerPath, fillPaint);
    canvas.drawPath(
      innerCutout,
      Paint()
        ..blendMode = BlendMode.clear
        ..style = PaintingStyle.fill,
    );
    canvas.restore();

    canvas.drawPath(outerPath, strokePaint);
    canvas.drawPath(innerCutout, strokePaint);

    final bottom = size.height * 0.875;
    final left = size.width * 0.24;
    final right = size.width * 0.78;
    const tickCount = 6;
    final tickPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.85
      ..strokeCap = StrokeCap.round;
    for (var i = 1; i < tickCount; i++) {
      final x = left + ((right - left) * i / tickCount);
      final tickTop = i.isEven ? size.height * 0.76 : size.height * 0.81;
      canvas.drawLine(
        Offset(x, bottom - strokeWidth * 0.12),
        Offset(x, tickTop),
        tickPaint,
      );
    }
  }

  Path _buildPath(Size size) {
    switch (type) {
      case _ShapeGlyphType.circle:
        return Path()..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width * 0.36,
          ),
        );
      case _ShapeGlyphType.square:
        return Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: size.width * 0.72,
              height: size.height * 0.72,
            ),
            Radius.circular(size.width * 0.05),
          ),
        );
      case _ShapeGlyphType.hexagon:
        return _polygonPath(
          size: size,
          sides: 6,
          radius: size.width * 0.38,
          rotation: math.pi / 6,
        );
      case _ShapeGlyphType.triangle:
        return _polygonPath(
          size: size,
          sides: 3,
          radius: size.width * 0.42,
          rotation: -math.pi / 2,
        );
      case _ShapeGlyphType.fractionPie:
      case _ShapeGlyphType.protractor:
        return Path();
    }
  }

  Path _polygonPath({
    required Size size,
    required int sides,
    required double radius,
    required double rotation,
  }) {
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final angle = rotation + ((math.pi * 2) * i / sides);
      final point = Offset(
        center.dx + (math.cos(angle) * radius),
        center.dy + (math.sin(angle) * radius),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant _ShapeGlyphPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.strokeColor != strokeColor;
  }
}
