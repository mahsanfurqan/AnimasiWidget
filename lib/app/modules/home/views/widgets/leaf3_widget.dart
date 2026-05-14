import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Leaf3Widget extends StatefulWidget {
  const Leaf3Widget({
    super.key,
    required this.width,
    required this.height,
  });

  static const String _leafAsset = 'assets/icons/leaf3.svg';

  final double width;
  final double height;

  @override
  State<Leaf3Widget> createState() => _Leaf3WidgetState();
}

class _Leaf3WidgetState extends State<Leaf3Widget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _leafCtrl;

  @override
  void initState() {
    super.initState();
    _leafCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  @override
  void dispose() {
    _leafCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _leafCtrl,
        builder: (context, child) {
          final phase = _leafCtrl.value * math.pi;
          final sway = -math.sin(phase) * 0.095;
          final floatY = math.sin(phase) * 1.6;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.rotate(
              angle: sway,
              alignment: const Alignment(0.98, 0.98),
              child: child,
            ),
          );
        },
        child: SvgPicture.asset(Leaf3Widget._leafAsset, fit: BoxFit.contain),
      ),
    );
  }
}
