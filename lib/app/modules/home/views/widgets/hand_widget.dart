import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HandWidget extends StatefulWidget {
  const HandWidget({
    super.key,
    required this.width,
    required this.height,
  });

  static const String _handAsset = 'assets/icons/hand.svg';

  final double width;
  final double height;

  @override
  State<HandWidget> createState() => _HandWidgetState();
}

class _HandWidgetState extends State<HandWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _handCtrl;

  @override
  void initState() {
    super.initState();
    _handCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _handCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _handCtrl,
        builder: (context, child) {
          final press = _pressCurve(_handCtrl.value);
          final swing = math.sin(press * math.pi);
          final offsetY = 0.8 * press;
          final offsetX = -0.6 * press;
          final angle = (-0.05 * press) + (swing * 0.018);
          final scale = 1.0 - (0.008 * press);
          const pivot = Alignment(-0.86, 0.18);

          return Transform.translate(
            offset: Offset(offsetX, offsetY),
            child: Transform.rotate(
              angle: angle,
              alignment: pivot,
              child: Transform.scale(
                scale: scale,
                alignment: pivot,
                child: child,
              ),
            ),
          );
        },
        child: SvgPicture.asset(
          HandWidget._handAsset,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  double _pressCurve(double t) {
    if (t < 0.24) {
      return Curves.easeInOut.transform(t / 0.24);
    }
    if (t < 0.44) {
      return 1.0 - (0.08 * Curves.easeInOut.transform((t - 0.24) / 0.20));
    }
    if (t < 0.72) {
      return 0.92 * (1.0 - Curves.easeInOut.transform((t - 0.44) / 0.28));
    }
    return 0.0;
  }
}
