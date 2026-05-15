import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PotLeafWidget extends StatefulWidget {
  const PotLeafWidget({super.key, required this.width, required this.height});

  static const String baseAsset =
      'assets/icons/pot_leaf_parts/pot_leaf_base.svg';
  static const String leafAsset =
      'assets/icons/pot_leaf_parts/pot_leaf_leaf3.svg';
  static const double _leaf3LeftFactor = 74 / 1330;
  static const double _leaf3TopFactor = 183 / 1670;
  static const double _leaf3WidthFactor = 655 / 1330;
  static const double _leaf3HeightFactor = 877 / 1670;

  final double width;
  final double height;

  @override
  State<PotLeafWidget> createState() => _PotLeafWidgetState();
}

class _PotLeafWidgetState extends State<PotLeafWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _leafCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat();

  @override
  void dispose() {
    _leafCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaf3Left = widget.width * PotLeafWidget._leaf3LeftFactor;
    final leaf3Top = widget.height * PotLeafWidget._leaf3TopFactor;
    final leaf3Width = widget.width * PotLeafWidget._leaf3WidthFactor;
    final leaf3Height = widget.height * PotLeafWidget._leaf3HeightFactor;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              PotLeafWidget.baseAsset,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: leaf3Left,
            top: leaf3Top,
            width: leaf3Width,
            height: leaf3Height,
            child: AnimatedBuilder(
              animation: _leafCtrl,
              builder: (context, child) {
                final phase = _leafCtrl.value * math.pi;
                final sway = -math.sin(phase) * 0.095;

                return Transform.rotate(
                  angle: sway,
                  alignment: const Alignment(0.98, 0.98),
                  child: child,
                );
              },
              child: SvgPicture.asset(
                PotLeafWidget.leafAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
