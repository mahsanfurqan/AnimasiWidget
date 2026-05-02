import 'dart:math' as math;

import 'package:flutter/material.dart';

class NewBadgeWidget extends StatefulWidget {
  const NewBadgeWidget({
    super.key,
    required this.width,
  });

  final double width;

  static const double _widthToHeightRatio = 210 / 68;

  @override
  State<NewBadgeWidget> createState() => _NewBadgeWidgetState();
}

class _NewBadgeWidgetState extends State<NewBadgeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _badgeCtrl;

  double get _height => widget.width / NewBadgeWidget._widthToHeightRatio;

  @override
  void initState() {
    super.initState();
    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: _height,
      child: AnimatedBuilder(
        animation: _badgeCtrl,
        builder: (context, _) {
          final t = (math.sin(_badgeCtrl.value * math.pi * 2) + 1) / 2;
          final fillStart =
              Color.lerp(
                const Color(0xFF84C695),
                const Color(0xFFB8E8C1),
                t,
              ) ??
              const Color(0xFF9ED9AB);
          final fillEnd =
              Color.lerp(
                const Color(0xFFA7D8B1),
                const Color(0xFF77C693),
                t,
              ) ??
              const Color(0xFF8FD1A1);
          final shadow =
              Color.lerp(
                const Color(0x2F76BE8B),
                const Color(0x559EE1AE),
                t,
              ) ??
              const Color(0x4697D9A9);

          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [fillStart, fillEnd],
              ),
              borderRadius: BorderRadius.circular(_height / 2),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 14 + (t * 10),
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'New',
                style: TextStyle(
                  color: const Color(0xFFFFF9F1),
                  fontSize: _height * 0.58,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
