import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chain_widget.dart';

class FloatingThreeWidget extends StatefulWidget {
  const FloatingThreeWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<FloatingThreeWidget> createState() => _FloatingThreeWidgetState();
}

class _FloatingThreeWidgetState extends State<FloatingThreeWidget>
    with SingleTickerProviderStateMixin {
  static const List<_FloatingThreeSpec> _objects = [
    _FloatingThreeSpec(
      asset: 'assets/icons/recycle.svg',
      leftFactor: 0.450,
      topFactor: 0.12,
      widthFactor: 0.055,
      pulseScaleAmplitude: 0.075,
      phase: 0.08,
      driftXAmplitude: 1.2,
      floatAmplitude: 3.6,
      rotationAmplitude: 0.030,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.chain,
      leftFactor: 0.485,
      topFactor: 0.250,
      widthFactor: 0.078,
      pulseScaleAmplitude: 0.075,
      phase: 0.24,
      driftXAmplitude: 1.0,
      floatAmplitude: 3.5,
      rotationAmplitude: 0.028,
    ),
    _FloatingThreeSpec(
      asset: 'assets/icons/shield3.svg',
      leftFactor: 0.560,
      topFactor: 0.15,
      widthFactor: 0.065,
      pulseScaleAmplitude: 0.075,
      phase: 0.46,
      driftXAmplitude: 1.0,
      floatAmplitude: 3.8,
      rotationAmplitude: 0.032,
    ),
    _FloatingThreeSpec(
      asset: 'assets/icons/blok square.svg',
      leftFactor: 0.41,
      topFactor: 0.29,
      widthFactor: 0.034,
      pulseScaleAmplitude: 0.085,
      phase: 0.66,
      driftXAmplitude: 0.45,
      floatAmplitude: 1.2,
      rotationAmplitude: 0.020,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.fractionPie,
      leftFactor: 0.65,
      topFactor: 0.25,
      widthFactor: 0.054,
      pulseScaleAmplitude: 0.085,
      phase: 0.82,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.circle,
      leftFactor: 0.67,
      topFactor: 0.11,
      widthFactor: 0.030,
      pulseScaleAmplitude: 0.085,
      phase: 0.12,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.triangle,
      leftFactor: 0.37,
      topFactor: 0.10,
      widthFactor: 0.030,
      pulseScaleAmplitude: 0.085,
      phase: 0.30,
      driftXAmplitude: 0.35,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.plus,
      leftFactor: 0.52,
      topFactor: 0.06,
      widthFactor: 0.031,
      pulseScaleAmplitude: 0.085,
      phase: 0.54,
      driftXAmplitude: 0.40,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.020,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.minus,
      leftFactor: 0.76,
      topFactor: 0.37,
      widthFactor: 0.031,
      pulseScaleAmplitude: 0.085,
      phase: 0.72,
      driftXAmplitude: 0.40,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.divide,
      leftFactor: 0.30,
      topFactor: 0.05,
      widthFactor: 0.031,
      pulseScaleAmplitude: 0.085,
      phase: 0.18,
      driftXAmplitude: 0.40,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.018,
    ),
    _FloatingThreeSpec(
      kind: _FloatingThreeKind.multiply,
      leftFactor: 0.83,
      topFactor: 0.25,
      widthFactor: 0.031,
      pulseScaleAmplitude: 0.085,
      phase: 0.92,
      driftXAmplitude: 0.40,
      floatAmplitude: 1.0,
      rotationAmplitude: 0.020,
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
                final rotation = math.sin(phase) * object.rotationAmplitude;
                final scale =
                    1.0 + (math.sin(phase) * object.pulseScaleAmplitude);
                final objectWidth = widget.width * object.widthFactor;

                return Positioned(
                  left: (widget.width * object.leftFactor) + driftX,
                  top: (widget.height * object.topFactor) + driftY,
                  child: Transform.rotate(
                    angle: rotation,
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: switch (object.kind) {
                        _FloatingThreeKind.chain => ChainWidget(
                          width: objectWidth,
                        ),
                        _FloatingThreeKind.asset => SvgPicture.asset(
                          object.asset!,
                          width: objectWidth,
                          fit: BoxFit.contain,
                        ),
                        _FloatingThreeKind.circle => _MiniGlyph(
                          type: _MiniGlyphType.circle,
                          size: objectWidth,
                        ),
                        _FloatingThreeKind.triangle => _MiniGlyph(
                          type: _MiniGlyphType.triangle,
                          size: objectWidth,
                        ),
                        _FloatingThreeKind.fractionPie => _MiniGlyph(
                          type: _MiniGlyphType.fractionPie,
                          size: objectWidth,
                        ),
                        _FloatingThreeKind.plus => _MiniGlyph(
                          type: _MiniGlyphType.plus,
                          size: objectWidth,
                        ),
                        _FloatingThreeKind.minus => _MiniGlyph(
                          type: _MiniGlyphType.minus,
                          size: objectWidth,
                        ),
                        _FloatingThreeKind.divide => _MiniGlyph(
                          type: _MiniGlyphType.divide,
                          size: objectWidth,
                        ),
                        _FloatingThreeKind.multiply => _MiniGlyph(
                          type: _MiniGlyphType.multiply,
                          size: objectWidth,
                        ),
                      },
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

class _FloatingThreeSpec {
  const _FloatingThreeSpec({
    this.asset,
    this.kind = _FloatingThreeKind.asset,
    required this.leftFactor,
    required this.topFactor,
    required this.widthFactor,
    required this.pulseScaleAmplitude,
    required this.phase,
    required this.driftXAmplitude,
    required this.floatAmplitude,
    required this.rotationAmplitude,
  });

  final String? asset;
  final _FloatingThreeKind kind;
  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final double pulseScaleAmplitude;
  final double phase;
  final double driftXAmplitude;
  final double floatAmplitude;
  final double rotationAmplitude;
}

enum _FloatingThreeKind {
  asset,
  chain,
  circle,
  triangle,
  fractionPie,
  plus,
  minus,
  divide,
  multiply,
}

enum _MiniGlyphType {
  circle,
  triangle,
  fractionPie,
  plus,
  minus,
  divide,
  multiply,
}

class _MiniGlyph extends StatelessWidget {
  const _MiniGlyph({required this.type, required this.size});

  final _MiniGlyphType type;
  final double size;

  static const Color _strokeColor = Color(0xFF7A4266);
  static const Color _circleFill = Color(0xFFF0A0B2);
  static const Color _triangleFill = Color(0xFFF3B489);
  static const Color _fractionFill = Color(0xFFF0A0B2);
  static const Color _fractionAccent = Color(0xFFCCB7F1);
  static const Color _plusFill = Color(0xFFF0A0B2);
  static const Color _minusFill = Color(0xFFF4A393);
  static const Color _multiplyFill = Color(0xFFB58AB5);
  static const Color _divideFill = Color(0xFFD0B1E1);

  @override
  Widget build(BuildContext context) {
    if (type == _MiniGlyphType.fractionPie) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _MiniFractionPainter(
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

    if (type == _MiniGlyphType.plus ||
        type == _MiniGlyphType.minus ||
        type == _MiniGlyphType.divide ||
        type == _MiniGlyphType.multiply) {
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

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MiniShapePainter(
          type: type,
          fillColor: type == _MiniGlyphType.circle
              ? _circleFill
              : _triangleFill,
          strokeColor: _strokeColor,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case _MiniGlyphType.plus:
        return _plusFill;
      case _MiniGlyphType.minus:
        return _minusFill;
      case _MiniGlyphType.multiply:
        return _multiplyFill;
      case _MiniGlyphType.divide:
        return _divideFill;
      case _MiniGlyphType.circle:
        return _circleFill;
      case _MiniGlyphType.triangle:
        return _triangleFill;
      case _MiniGlyphType.fractionPie:
        return _fractionFill;
    }
  }

  Widget _symbol() {
    switch (type) {
      case _MiniGlyphType.plus:
        return _plusMinusSymbol(isPlus: true);
      case _MiniGlyphType.minus:
        return _plusMinusSymbol(isPlus: false);
      case _MiniGlyphType.multiply:
        return _multiplySymbol();
      case _MiniGlyphType.divide:
        return _divideSymbol();
      case _MiniGlyphType.circle:
      case _MiniGlyphType.triangle:
      case _MiniGlyphType.fractionPie:
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

class _MiniShapePainter extends CustomPainter {
  const _MiniShapePainter({
    required this.type,
    required this.fillColor,
    required this.strokeColor,
  });

  final _MiniGlyphType type;
  final Color fillColor;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = switch (type) {
      _MiniGlyphType.circle =>
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width * 0.36,
          ),
        ),
      _MiniGlyphType.triangle => _polygonPath(
        size: size,
        sides: 3,
        radius: size.width * 0.42,
        rotation: -math.pi / 2,
      ),
      _MiniGlyphType.fractionPie ||
      _MiniGlyphType.plus ||
      _MiniGlyphType.minus ||
      _MiniGlyphType.divide ||
      _MiniGlyphType.multiply => Path(),
    };

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
  bool shouldRepaint(covariant _MiniShapePainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeColor != strokeColor;
  }
}

class _MiniFractionPainter extends CustomPainter {
  const _MiniFractionPainter({
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

  @override
  bool shouldRepaint(covariant _MiniFractionPainter oldDelegate) {
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
