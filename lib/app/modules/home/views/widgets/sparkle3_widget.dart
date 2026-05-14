import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Sparkle3Widget extends StatefulWidget {
  const Sparkle3Widget({super.key, required this.width, required this.height});

  static const List<_Sparkle3Spec> _sparkles = [
    _Sparkle3Spec(
      leftFactor: 0.02,
      topFactor: 0.28,
      sizeFactor: 0.018,
      shift: 0.00,
    ),
    _Sparkle3Spec(
      leftFactor: 0.08,
      topFactor: 0.55,
      sizeFactor: 0.038,
      shift: 0.22,
    ),
    _Sparkle3Spec(
      leftFactor: 0.11,
      topFactor: 0.63,
      sizeFactor: 0.024,
      shift: 0.44,
    ),
    _Sparkle3Spec(
      leftFactor: 0.20,
      topFactor: 0.43,
      sizeFactor: 0.022,
      shift: 0.66,
    ),
    _Sparkle3Spec(
      leftFactor: 0.18,
      topFactor: 0.36,
      sizeFactor: 0.030,
      shift: 0.84,
    ),
  ];

  final double width;
  final double height;

  @override
  State<Sparkle3Widget> createState() => _Sparkle3WidgetState();
}

class _Sparkle3WidgetState extends State<Sparkle3Widget>
    with SingleTickerProviderStateMixin {
  static const String _sparkleAsset = 'assets/icons/sparkle.svg';

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3900),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Stack(
              children: Sparkle3Widget._sparkles.map((sparkle) {
                final phase = (_ctrl.value + sparkle.shift) % 1.0;
                final pulse = _pulse(phase);
                final size = widget.width * sparkle.sizeFactor;

                return Positioned(
                  left: widget.width * sparkle.leftFactor,
                  top: widget.height * sparkle.topFactor,
                  child: Opacity(
                    opacity: 0.68 + (pulse * 0.15),
                    child: Transform.scale(
                      scale: 0.90 + (pulse * 0.10),
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
      ),
    );
  }

  double _pulse(double phase) {
    final value = (math.sin(phase * math.pi) + 1) / 2;
    return Curves.easeInOut.transform(value);
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

class _Sparkle3Spec {
  const _Sparkle3Spec({
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
