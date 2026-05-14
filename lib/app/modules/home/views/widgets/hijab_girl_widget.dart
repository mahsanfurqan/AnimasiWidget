import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HijabGirlWidget extends StatefulWidget {
  const HijabGirlWidget({super.key, this.width = 180});

  final double width;

  static const String backAsset =
      'assets/icons/hijab_girl_parts/hijab_girl_back.svg';
  static const String armAsset =
      'assets/icons/hijab_girl_parts/hijab_girl_arm.svg';
  static const String frontAsset =
      'assets/icons/hijab_girl_parts/hijab_girl_front.svg';
  static const double _aspectRatio = 713 / 754;

  @override
  State<HijabGirlWidget> createState() => _HijabGirlWidgetState();
}

class _HijabGirlWidgetState extends State<HijabGirlWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _armCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _armCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = width / HijabGirlWidget._aspectRatio;

    return AnimatedBuilder(
      animation: _armCtrl,
      builder: (context, child) {
        final wave = math.sin(_armCtrl.value * math.pi * 2);
        final settle = math.sin(_armCtrl.value * math.pi * 4) * 0.15;
        final armAngle = (wave * 0.022) + (settle * 0.006);
        final armOffset = Offset(-0.35 + (wave * 0.18), 0.45 - (wave * 0.10));

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  HijabGirlWidget.backAsset,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned.fill(
                child: Transform.translate(
                  offset: armOffset,
                  child: Transform.rotate(
                    angle: armAngle,
                    alignment: const Alignment(0.41, 0.37),
                    child: SvgPicture.asset(
                      HijabGirlWidget.armAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SvgPicture.asset(
                  HijabGirlWidget.frontAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
