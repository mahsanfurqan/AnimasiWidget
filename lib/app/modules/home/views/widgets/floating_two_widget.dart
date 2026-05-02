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
      asset: 'assets/icons/telescope.svg',
      leftFactor: 0.52,
      topFactor: 0.30,
      widthFactor: 0.06,
      phase: 0.10,
      driftXAmplitude: 1.4,
      floatAmplitude: 4.0,
      rotationAmplitude: 0.035,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/shield2.svg',
      leftFactor: 0.77,
      topFactor: 0.15,
      widthFactor: 0.07,
      phase: 0.42,
      driftXAmplitude: 1.6,
      floatAmplitude: 4.8,
      rotationAmplitude: 0.040,
    ),
    _FloatingTwoSpec(
      asset: 'assets/icons/key.svg',
      leftFactor: 0.75,
      topFactor: 0.51,
      widthFactor: 0.03,
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
                final rotation = math.sin(phase) * object.rotationAmplitude;
                final objectWidth = widget.width * object.widthFactor;
                final left = (widget.width * object.leftFactor) + driftX;
                final top = (widget.height * object.topFactor) + driftY;

                return Positioned(
                  left: left,
                  top: top,
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
      ),
    );
  }
}

class _FloatingTwoSpec {
  const _FloatingTwoSpec({
    required this.asset,
    required this.leftFactor,
    required this.topFactor,
    required this.widthFactor,
    required this.phase,
    required this.driftXAmplitude,
    required this.floatAmplitude,
    required this.rotationAmplitude,
  });

  final String asset;
  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final double phase;
  final double driftXAmplitude;
  final double floatAmplitude;
  final double rotationAmplitude;
}
