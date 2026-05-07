import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Sparkle2Widget extends StatefulWidget {
  const Sparkle2Widget({super.key, required this.width, required this.height});

  static const List<_Sparkle2Spec> _sparkles = [
    _Sparkle2Spec(
      leftFactor: 0.17,
      topFactor: 0.40,
      sizeFactor: 0.038,
      shift: 0.00,
    ),
    _Sparkle2Spec(
      leftFactor: 0.24,
      topFactor: 0.37,
      sizeFactor: 0.034,
      shift: 0.34,
    ),
    _Sparkle2Spec(
      leftFactor: 0.25,
      topFactor: 0.03,
      sizeFactor: 0.020,
      shift: 0.22,
    ),
    _Sparkle2Spec(
      leftFactor: 0.79,
      topFactor: 0.68,
      sizeFactor: 0.042,
      shift: 0.48,
    ),
    _Sparkle2Spec(
      leftFactor: 0.88,
      topFactor: 0.76,
      sizeFactor: 0.034,
      shift: 0.70,
    ),
  ];

  final double width;
  final double height;

  @override
  State<Sparkle2Widget> createState() => _Sparkle2WidgetState();
}

class _Sparkle2WidgetState extends State<Sparkle2Widget>
    with SingleTickerProviderStateMixin {
  static const String _sparkleAsset = 'assets/icons/sparkle.svg';

  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
  }

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
              children: Sparkle2Widget._sparkles.map((sparkle) {
                final phase = (_ctrl.value + sparkle.shift) % 1.0;
                final pulse = _pulse(phase);
                final size = widget.width * sparkle.sizeFactor;

                return Positioned(
                  left: widget.width * sparkle.leftFactor,
                  top: widget.height * sparkle.topFactor,
                  child: Opacity(
                    opacity: 0.45 + (pulse * 0.35),
                    child: Transform.scale(
                      scale: 0.88 + (pulse * 0.16),
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
    return Curves.easeInOut.transform((math.sin(phase * math.pi) + 1) / 2);
  }

  Color _sparkleColor(double phase) {
    const warmWhite = Color(0xFFFFF8EE);
    const softGold = Color(0xFFFFDE97);
    const peachGlow = Color(0xFFFFC6A6);

    if (phase < 0.35) {
      final t = Curves.easeInOut.transform(phase / 0.35);
      return Color.lerp(warmWhite, softGold, t) ?? warmWhite;
    }
    if (phase < 0.72) {
      final t = Curves.easeInOut.transform((phase - 0.35) / 0.37);
      return Color.lerp(softGold, peachGlow, t) ?? softGold;
    }
    final t = Curves.easeInOut.transform((phase - 0.72) / 0.28);
    return Color.lerp(peachGlow, warmWhite, t) ?? peachGlow;
  }
}

class _Sparkle2Spec {
  const _Sparkle2Spec({
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
