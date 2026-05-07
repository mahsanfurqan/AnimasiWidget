import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloatingObjectWidget extends StatefulWidget {
  const FloatingObjectWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<FloatingObjectWidget> createState() => _FloatingObjectWidgetState();
}

class _FloatingObjectWidgetState extends State<FloatingObjectWidget>
    with SingleTickerProviderStateMixin {
  static const List<_FloatingSpec> _objects = [
    _FloatingSpec(
      asset: 'assets/icons/toga.svg',
      leftFactor: 0.50,
      topFactor: 0.16,
      widthFactor: 0.08,
      phase: 0.00,
      driftXAmplitude: 2.2,
      rotationAmplitude: 0.10,
      floatAmplitude: 7.0,
      pulseScaleAmplitude: 0.0,
    ),
    _FloatingSpec(
      asset: 'assets/icons/blok square.svg',
      leftFactor: 0.26,
      topFactor: 0.34,
      widthFactor: 0.032,
      phase: 0.16,
      driftXAmplitude: 0.45,
      rotationAmplitude: 0.020,
      floatAmplitude: 1.2,
      pulseScaleAmplitude: 0.12,
    ),
    _FloatingSpec(
      asset: 'assets/icons/balok 123.svg',
      leftFactor: 0.60,
      topFactor: 0.05,
      widthFactor: 0.050,
      phase: 0.78,
      driftXAmplitude: 0.45,
      rotationAmplitude: 0.018,
      floatAmplitude: 1.1,
      pulseScaleAmplitude: 0.12,
    ),
    _FloatingSpec(
      asset: 'assets/icons/shield.svg',
      leftFactor: 0.69,
      topFactor: 0.21,
      widthFactor: 0.065,
      phase: 0.51,
      driftXAmplitude: 2.2,
      rotationAmplitude: 0.11,
      floatAmplitude: 8.0,
      pulseScaleAmplitude: 0.0,
    ),
    _FloatingSpec(
      mathGlyph: _MathGlyphType.minus,
      leftFactor: 0.62,
      topFactor: 0.24,
      widthFactor: 0.035,
      phase: 0.78,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.018,
      floatAmplitude: 1.0,
      pulseScaleAmplitude: 0.12,
    ),
    _FloatingSpec(
      mathGlyph: _MathGlyphType.plus,
      leftFactor: 0.66,
      topFactor: 0.40,
      widthFactor: 0.035,
      phase: 0.33,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.022,
      floatAmplitude: 1.0,
      pulseScaleAmplitude: 0.12,
    ),
    _FloatingSpec(
      mathGlyph: _MathGlyphType.divide,
      leftFactor: 0.73,
      topFactor: 0.10,
      widthFactor: 0.035,
      phase: 0.46,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.020,
      floatAmplitude: 1.0,
      pulseScaleAmplitude: 0.12,
    ),
    _FloatingSpec(
      mathGlyph: _MathGlyphType.multiply,
      leftFactor: 0.79,
      topFactor: 0.23,
      widthFactor: 0.035,
      phase: 0.90,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.022,
      floatAmplitude: 1.0,
      pulseScaleAmplitude: 0.12,
    ),
    _FloatingSpec(
      mathGlyph: _MathGlyphType.fractionPie,
      leftFactor: 0.15,
      topFactor: 0.37,
      widthFactor: 0.045,
      phase: 0.58,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.018,
      floatAmplitude: 1.0,
      pulseScaleAmplitude: 0.12,
    ),
  ];

  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();
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
      child: AnimatedBuilder(
        animation: _floatCtrl,
        builder: (context, _) {
          return Stack(
            children: _objects.map((object) {
              final phase =
                  ((_floatCtrl.value + object.phase) % 1.0) * math.pi * 2;
              final driftX = math.cos(phase) * object.driftXAmplitude;
              final driftY = math.sin(phase) * object.floatAmplitude;
              final rotation = math.sin(phase) * object.rotationAmplitude;
              final pulse = math.sin(phase);
              final scale = pulse >= 0
                  ? 1 + (pulse * object.pulseScaleAmplitude * 0.35)
                  : 1 + (pulse * object.pulseScaleAmplitude);
              final objectWidth = widget.width * object.widthFactor;

              return Positioned(
                left: (widget.width * object.leftFactor) + driftX,
                top: (widget.height * object.topFactor) + driftY,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateZ(rotation),
                  child: Transform.scale(
                    scale: scale,
                    child: object.asset != null
                        ? SvgPicture.asset(
                            object.asset!,
                            width: objectWidth,
                            fit: BoxFit.contain,
                          )
                        : _MathGlyph(
                            type: object.mathGlyph!,
                            size: objectWidth,
                          ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _FloatingSpec {
  const _FloatingSpec({
    this.asset,
    this.mathGlyph,
    required this.leftFactor,
    required this.topFactor,
    required this.widthFactor,
    required this.phase,
    required this.driftXAmplitude,
    required this.rotationAmplitude,
    required this.floatAmplitude,
    required this.pulseScaleAmplitude,
  }) : assert(asset != null || mathGlyph != null);

  final String? asset;
  final _MathGlyphType? mathGlyph;
  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final double phase;
  final double driftXAmplitude;
  final double rotationAmplitude;
  final double floatAmplitude;
  final double pulseScaleAmplitude;
}

enum _MathGlyphType { plus, minus, divide, multiply, fractionPie }

class _MathGlyph extends StatelessWidget {
  const _MathGlyph({required this.type, required this.size});

  final _MathGlyphType type;
  final double size;

  static const Color _strokeColor = Color(0xFF7A4266);
  static const Color _plusFill = Color(0xFFF0A0B2);
  static const Color _minusFill = Color(0xFFF4A393);
  static const Color _multiplyFill = Color(0xFFB58AB5);
  static const Color _divideFill = Color(0xFFD0B1E1);
  static const Color _fractionFill = Color(0xFFF0A0B2);
  static const Color _fractionAccent = Color(0xFFCCB7F1);

  @override
  Widget build(BuildContext context) {
    if (type == _MathGlyphType.fractionPie) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _FractionPiePainter(
            fillColor: _fractionFill,
            accentColor: _fractionAccent,
            strokeColor: _strokeColor,
          ),
          child: Center(
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

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: _strokeColor, width: size * 0.075),
      ),
      child: Center(child: _symbol()),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case _MathGlyphType.plus:
        return _plusFill;
      case _MathGlyphType.minus:
        return _minusFill;
      case _MathGlyphType.multiply:
        return _multiplyFill;
      case _MathGlyphType.divide:
        return _divideFill;
      case _MathGlyphType.fractionPie:
        return _fractionFill;
    }
  }

  Widget _symbol() {
    switch (type) {
      case _MathGlyphType.plus:
        return _plusMinusSymbol(isPlus: true);
      case _MathGlyphType.minus:
        return _plusMinusSymbol(isPlus: false);
      case _MathGlyphType.multiply:
        return _multiplySymbol();
      case _MathGlyphType.divide:
        return _divideSymbol();
      case _MathGlyphType.fractionPie:
        return const SizedBox.shrink();
    }
  }

  Widget _plusMinusSymbol({required bool isPlus}) {
    return CustomPaint(
      size: Size.square(size * 0.74),
      painter: _PlusMinusPainter(isPlus: isPlus, strokeColor: _strokeColor),
    );
  }

  Widget _multiplySymbol() {
    final outerThickness = size * 0.18;
    final innerThickness = outerThickness * 0.62;
    final lineLength = size * 0.52;

    Widget stroke(Color color, double thickness) {
      return Container(
        width: lineLength,
        height: thickness,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(thickness),
        ),
      );
    }

    Widget diagonal(double angle) {
      return Transform.rotate(
        angle: angle,
        child: Stack(
          alignment: Alignment.center,
          children: [
            stroke(_strokeColor, outerThickness),
            stroke(Colors.white, innerThickness),
          ],
        ),
      );
    }

    return SizedBox(
      width: size * 0.72,
      height: size * 0.72,
      child: Stack(
        alignment: Alignment.center,
        children: [diagonal(math.pi / 4), diagonal(-math.pi / 4)],
      ),
    );
  }

  Widget _divideSymbol() {
    final strokeHeight = size * 0.16;
    final dotOuter = size * 0.22;
    final dotInner = dotOuter * 0.64;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _outlinedDot(dotOuter, dotInner),
        SizedBox(height: size * 0.07),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size * 0.54,
              height: strokeHeight,
              decoration: BoxDecoration(
                color: _strokeColor,
                borderRadius: BorderRadius.circular(strokeHeight),
              ),
            ),
            Container(
              width: size * 0.40,
              height: strokeHeight * 0.60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(strokeHeight),
              ),
            ),
          ],
        ),
        SizedBox(height: size * 0.07),
        _outlinedDot(dotOuter, dotInner),
      ],
    );
  }

  Widget _outlinedDot(double outerSize, double innerSize) {
    return Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(color: _strokeColor, shape: BoxShape.circle),
      child: Center(
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _FractionPiePainter extends CustomPainter {
  const _FractionPiePainter({
    required this.fillColor,
    required this.accentColor,
    required this.strokeColor,
  });

  final Color fillColor;
  final Color accentColor;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.36;
    final circleRect = Rect.fromCircle(center: center, radius: radius);
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.052
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

  @override
  bool shouldRepaint(covariant _FractionPiePainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.strokeColor != strokeColor;
  }
}

class _PlusMinusPainter extends CustomPainter {
  const _PlusMinusPainter({required this.isPlus, required this.strokeColor});

  final bool isPlus;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final outerPath = _buildPath(
      size: size,
      thickness: size.height * 0.28,
      length: size.width * 0.82,
      isPlus: isPlus,
    );
    final innerPath = _buildPath(
      size: size,
      thickness: size.height * 0.17,
      length: size.width * 0.64,
      isPlus: isPlus,
    );

    canvas.drawPath(
      outerPath,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      innerPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  Path _buildPath({
    required Size size,
    required double thickness,
    required double length,
    required bool isPlus,
  }) {
    final horizontal = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: length,
            height: thickness,
          ),
          Radius.circular(thickness / 2),
        ),
      );

    if (!isPlus) {
      return horizontal;
    }

    final vertical = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: thickness,
            height: length,
          ),
          Radius.circular(thickness / 2),
        ),
      );

    return Path.combine(PathOperation.union, horizontal, vertical);
  }

  @override
  bool shouldRepaint(covariant _PlusMinusPainter oldDelegate) {
    return oldDelegate.isPlus != isPlus ||
        oldDelegate.strokeColor != strokeColor;
  }
}
