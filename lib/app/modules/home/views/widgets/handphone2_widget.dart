import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Handphone2Widget extends StatefulWidget {
  const Handphone2Widget({super.key, required this.width});

  static const String _handAsset = 'assets/icons/hand_handphone.svg';

  final double width;

  @override
  State<Handphone2Widget> createState() => _Handphone2WidgetState();
}

class _Handphone2WidgetState extends State<Handphone2Widget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2300),
  )..repeat();

  double get _contentWidth => widget.width;
  double get _contentHeight => _contentWidth * 1.86;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _contentWidth,
      height: _contentHeight,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = _ctrl.value;
          final handWave = math.sin(t * math.pi * 2) * 0.12;
          final livePulse = (math.sin(t * math.pi * 2) * 0.5) + 0.5;
          final miniIconPulse = math.sin((t * math.pi * 2) + 0.9) * 0.5 + 0.5;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: _contentWidth * 0.180,
                top: _contentHeight * 0.125,
                child: Transform.rotate(
                  angle: 0.03,
                  child: _LiveDot(
                    size: _contentWidth * 0.042,
                    progress: livePulse,
                  ),
                ),
              ),
              Positioned(
                right: _contentWidth * 0.25,
                top: _contentHeight * 0.07,
                child: Transform.rotate(
                  angle: 0.03,
                  child: _LoadingDots(width: _contentWidth * 0.18, progress: t),
                ),
              ),
              Positioned(
                left: _contentWidth * 0.35,
                top: _contentHeight * 0.80,
                child: Transform.rotate(
                  angle: handWave,
                  alignment: const Alignment(0.15, 0.85),
                  child: SvgPicture.asset(
                    Handphone2Widget._handAsset,
                    width: _contentWidth * 0.150,
                    height: _contentWidth * 0.150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                left: _contentWidth * 0.075,
                top: _contentHeight * 0.810,
                child: Transform.rotate(
                  angle: 0.03,
                  alignment: Alignment.center,
                  child: _MiniActionIcon(
                    size: _contentWidth * 0.095,
                    progress: miniIconPulse,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniActionIcon extends StatelessWidget {
  const _MiniActionIcon({required this.size, required this.progress});

  final double size;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final scale = 0.90 + (progress * 0.12);
    final translateY = (0.5 - progress) * size * 0.08;
    final emojiSize = size * 0.78;

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              '😊',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: emojiSize, height: 1.0),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot({required this.size, required this.progress});

  final double size;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final scale = 0.88 + (progress * 0.18);
    final opacity = 0.55 + (progress * 0.45);

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE65D63),
            boxShadow: [
              BoxShadow(
                color: const Color(0x66E65D63),
                blurRadius: size * 0.55,
                spreadRadius: size * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.width, required this.progress});

  final double width;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final wave =
            math.sin((progress * math.pi * 2) - (index * 0.76)) * 0.5 + 0.5;
        final scale = 0.82 + (wave * 0.26);
        final opacity = 0.40 + (wave * 0.60);
        final dotSize = width * 0.19;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: const BoxDecoration(
                  color: Color(0xFF8C8A96),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
