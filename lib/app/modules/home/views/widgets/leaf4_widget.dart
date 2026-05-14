import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Leaf4Widget extends StatefulWidget {
  const Leaf4Widget({
    super.key,
    required this.width,
    required this.height,
  });

  static const String _leafAsset = 'assets/icons/leaf4.svg';

  final double width;
  final double height;

  @override
  State<Leaf4Widget> createState() => _Leaf4WidgetState();
}

class _Leaf4WidgetState extends State<Leaf4Widget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _leafCtrl;

  @override
  void initState() {
    super.initState();
    _leafCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3900),
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
          final sway = math.sin(phase) * 0.048;
          final floatY = math.sin(phase) * 2.1;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.rotate(
              angle: sway,
              alignment: const Alignment(0.45, 0.95),
              child: child,
            ),
          );
        },
        child: SvgPicture.asset(Leaf4Widget._leafAsset, fit: BoxFit.contain),
      ),
    );
  }
}
