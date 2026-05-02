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
    ),
    _FloatingSpec(
      asset: 'assets/icons/blok square.svg',
      leftFactor: 0.56,
      topFactor: 0.07,
      widthFactor: 0.032,
      phase: 0.16,
      driftXAmplitude: 0.45,
      rotationAmplitude: 0.020,
      floatAmplitude: 1.2,
    ),
    _FloatingSpec(
      asset: 'assets/icons/balok 123.svg',
      leftFactor: 0.64,
      topFactor: 0.14,
      widthFactor: 0.034,
      phase: 0.78,
      driftXAmplitude: 0.45,
      rotationAmplitude: 0.018,
      floatAmplitude: 1.1,
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
    ),
    _FloatingSpec(
      asset: 'assets/icons/pengurangan.svg',
      leftFactor: 0.63,
      topFactor: 0.27,
      widthFactor: 0.029,
      phase: 0.78,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.018,
      floatAmplitude: 1.0,
    ),
    _FloatingSpec(
      asset: 'assets/icons/penjumlahan.svg',
      leftFactor: 0.66,
      topFactor: 0.40,
      widthFactor: 0.029,
      phase: 0.33,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.022,
      floatAmplitude: 1.0,
    ),
    _FloatingSpec(
      asset: 'assets/icons/pembagian.svg',
      leftFactor: 0.73,
      topFactor: 0.10,
      widthFactor: 0.028,
      phase: 0.46,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.020,
      floatAmplitude: 1.0,
    ),
    _FloatingSpec(
      asset: 'assets/icons/perkalian.svg',
      leftFactor: 0.79,
      topFactor: 0.23,
      widthFactor: 0.028,
      phase: 0.90,
      driftXAmplitude: 0.35,
      rotationAmplitude: 0.022,
      floatAmplitude: 1.0,
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
              final objectWidth = widget.width * object.widthFactor;

              return Positioned(
                left: (widget.width * object.leftFactor) + driftX,
                top: (widget.height * object.topFactor) + driftY,
                child: Transform.rotate(
                  angle: rotation,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    object.asset,
                    width: objectWidth,
                    fit: BoxFit.contain,
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
    required this.asset,
    required this.leftFactor,
    required this.topFactor,
    required this.widthFactor,
    required this.phase,
    required this.driftXAmplitude,
    required this.rotationAmplitude,
    required this.floatAmplitude,
  });

  final String asset;
  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final double phase;
  final double driftXAmplitude;
  final double rotationAmplitude;
  final double floatAmplitude;
}
