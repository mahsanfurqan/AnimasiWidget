import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Sparkle4Widget extends StatefulWidget {
  const Sparkle4Widget({super.key, required this.width, required this.height});

  static const List<_Sparkle4Spec> _sparkles = [
    _Sparkle4Spec(
      leftFactor: 0.41,
      topFactor: 0.18,
      sizeFactor: 0.024,
      shift: 0.00,
    ),
    _Sparkle4Spec(
      leftFactor: 0.10,
      topFactor: 0.08,
      sizeFactor: 0.020,
      shift: 0.18,
    ),
    _Sparkle4Spec(
      leftFactor: 0.37,
      topFactor: 0.08,
      sizeFactor: 0.032,
      shift: 0.36,
    ),
    _Sparkle4Spec(
      leftFactor: 0.90,
      topFactor: 0.40,
      sizeFactor: 0.032,
      shift: 0.36,
    ),
    _Sparkle4Spec(
      leftFactor: 0.45,
      topFactor: 0.45,
      sizeFactor: 0.032,
      shift: 0.10,
    ),
    _Sparkle4Spec(
      leftFactor: 0.40,
      topFactor: 0.50,
      sizeFactor: 0.032,
      shift: 0.36,
    ),
  ];

  final double width;
  final double height;

  @override
  State<Sparkle4Widget> createState() => _Sparkle4WidgetState();
}

class _Sparkle4WidgetState extends State<Sparkle4Widget>
    with SingleTickerProviderStateMixin {
  static const String _sparkleAsset = 'assets/icons/sparkle.svg';

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4300),
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
              children: Sparkle4Widget._sparkles.map((sparkle) {
                final phase = (_ctrl.value + sparkle.shift) % 1.0;
                final pulse = _pulse(phase);
                final size = widget.width * sparkle.sizeFactor;

                return Positioned(
                  left: widget.width * sparkle.leftFactor,
                  top: widget.height * sparkle.topFactor,
                  child: Opacity(
                    opacity: 0.48 + (pulse * 0.30),
                    child: Transform.scale(
                      scale: 0.90 + (pulse * 0.14),
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
    const softWhite = Color(0xFFFFFCF6);
    const warmCream = Color(0xFFFFF0D7);
    const warmGold = Color(0xFFFFD88D);

    if (phase < 0.30) {
      final t = Curves.easeInOut.transform(phase / 0.30);
      return Color.lerp(softWhite, warmCream, t) ?? softWhite;
    }
    if (phase < 0.68) {
      final t = Curves.easeInOut.transform((phase - 0.30) / 0.38);
      return Color.lerp(warmCream, warmGold, t) ?? warmCream;
    }
    final t = Curves.easeInOut.transform((phase - 0.68) / 0.32);
    return Color.lerp(warmGold, softWhite, t) ?? warmGold;
  }
}

class _Sparkle4Spec {
  const _Sparkle4Spec({
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
