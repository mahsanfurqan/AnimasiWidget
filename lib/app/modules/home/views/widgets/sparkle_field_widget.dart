import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SparkleFieldWidget extends StatefulWidget {
  const SparkleFieldWidget({
    super.key,
    required this.width,
    required this.height,
  });

  static const List<SparkleSpec> sparkles = [
    SparkleSpec(
      leftFactor: 0.02,
      topFactor: 0.28,
      sizeFactor: 0.018,
      shift: 0.00,
    ),
    SparkleSpec(
      leftFactor: 0.07,
      topFactor: 0.66,
      sizeFactor: 0.038,
      shift: 0.22,
    ),
    SparkleSpec(
      leftFactor: 0.11,
      topFactor: 0.72,
      sizeFactor: 0.024,
      shift: 0.44,
    ),
    SparkleSpec(
      leftFactor: 0.26,
      topFactor: 0.43,
      sizeFactor: 0.022,
      shift: 0.66,
    ),
    SparkleSpec(
      leftFactor: 0.22,
      topFactor: 0.38,
      sizeFactor: 0.030,
      shift: 0.84,
    ),
  ];

  final double width;
  final double height;

  @override
  State<SparkleFieldWidget> createState() => _SparkleFieldWidgetState();
}

class _SparkleFieldWidgetState extends State<SparkleFieldWidget>
    with SingleTickerProviderStateMixin {
  static const String _sparkleAsset = 'assets/icons/sparkle.svg';

  late final AnimationController _sparkleCtrl;

  @override
  void initState() {
    super.initState();
    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat();
  }

  @override
  void dispose() {
    _sparkleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _sparkleCtrl,
        builder: (context, _) {
          return Stack(
            children: SparkleFieldWidget.sparkles.map((sparkle) {
              final phase = _sparklePhase(_sparkleCtrl.value, sparkle.shift);
              final twinkle = _twinkleValue(phase);
              final size = widget.width * sparkle.sizeFactor;

              return Positioned(
                left: widget.width * sparkle.leftFactor,
                top: widget.height * sparkle.topFactor,
                child: Opacity(
                  opacity: 0.70 + (twinkle * 0.15),
                  child: Transform.scale(
                    scale: 0.90 + (twinkle * 0.10),
                    child: SvgPicture.asset(
                      _sparkleAsset,
                      width: size,
                      height: size,
                      colorFilter: ColorFilter.mode(
                        _sparkleColor(phase),
                        BlendMode.srcIn,
                      ),
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

  double _sparklePhase(double progress, double shift) {
    return (progress + shift) % 1.0;
  }

  double _twinkleValue(double phase) {
    final pulse = math.sin(phase * math.pi);
    return Curves.easeInOut.transform(pulse);
  }

  Color _sparkleColor(double phase) {
    const softWhite = Color(0xFFFFFCF7);
    const warmWhite = Color(0xFFFFF0D6);
    const warmYellow = Color(0xFFFFD889);

    if (phase < 0.25) {
      final t = Curves.easeInOut.transform(phase / 0.25);
      return Color.lerp(softWhite, warmWhite, t) ?? softWhite;
    }

    if (phase < 0.48) {
      return warmWhite;
    }

    if (phase < 0.73) {
      final t = Curves.easeInOut.transform((phase - 0.48) / 0.25);
      return Color.lerp(warmWhite, warmYellow, t) ?? warmWhite;
    }

    if (phase < 0.90) {
      return warmYellow;
    }

    final t = Curves.easeInOut.transform((phase - 0.90) / 0.10);
    return Color.lerp(warmYellow, softWhite, t) ?? warmYellow;
  }
}

class SparkleSpec {
  const SparkleSpec({
    required this.leftFactor,
    required this.topFactor,
    required this.sizeFactor,
    required this.shift,
  });

  final double leftFactor;
  final double topFactor;
  final double sizeFactor;
  final double shift;
}
