import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeafWidget extends StatefulWidget {
  const LeafWidget({
    super.key,
    required this.width,
    required this.height,
  });

  static const String _leafAsset = 'assets/icons/tangkai.svg';

  final double width;
  final double height;

  @override
  State<LeafWidget> createState() => _LeafWidgetState();
}

class _LeafWidgetState extends State<LeafWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _leafCtrl;

  @override
  void initState() {
    super.initState();
    _leafCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
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
          final sway = math.sin(_leafCtrl.value * math.pi * 2) * 0.05;
          final floatY = math.sin(_leafCtrl.value * math.pi * 2) * 2.2;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.rotate(
              angle: sway,
              alignment: const Alignment(0.45, 0.95),
              child: child,
            ),
          );
        },
        child: SvgPicture.asset(LeafWidget._leafAsset, fit: BoxFit.contain),
      ),
    );
  }
}
