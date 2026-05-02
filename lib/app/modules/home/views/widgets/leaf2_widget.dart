import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Leaf2Widget extends StatefulWidget {
  const Leaf2Widget({
    super.key,
    required this.width,
    required this.height,
  });

  static const String _leafAsset = 'assets/icons/leaf2.svg';

  final double width;
  final double height;

  @override
  State<Leaf2Widget> createState() => _Leaf2WidgetState();
}

class _Leaf2WidgetState extends State<Leaf2Widget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _leafCtrl;

  @override
  void initState() {
    super.initState();
    _leafCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
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
          final phase = _leafCtrl.value * math.pi * 2;
          final sway = math.sin(phase) * 0.045;
          final floatY = math.sin(phase) * 2.0;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.rotate(
              angle: sway,
              alignment: const Alignment(0.45, 0.95),
              child: child,
            ),
          );
        },
        child: SvgPicture.asset(Leaf2Widget._leafAsset, fit: BoxFit.contain),
      ),
    );
  }
}
