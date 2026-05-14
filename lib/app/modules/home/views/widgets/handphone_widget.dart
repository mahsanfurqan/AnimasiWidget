import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HandphoneWidget extends StatefulWidget {
  const HandphoneWidget({super.key, required this.width});

  static const String _profileAsset = 'assets/icons/child_profile.svg';

  final double width;

  @override
  State<HandphoneWidget> createState() => _HandphoneWidgetState();
}

class _HandphoneWidgetState extends State<HandphoneWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _stateCtrl;

  double get _contentWidth => widget.width;
  double get _contentHeight => _contentWidth * 1.54;

  @override
  void initState() {
    super.initState();
    _stateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _stateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _contentWidth,
      height: _contentHeight,
      child: AnimatedBuilder(
        animation: _stateCtrl,
        builder: (context, _) {
          final t = _stateCtrl.value;
          final dotsOpacity = (1 - ((t - 0.54) / 0.12).clamp(0.0, 1.0)).clamp(
            0.0,
            1.0,
          );
          final checkT = ((t - 0.56) / 0.22).clamp(0.0, 1.0);
          final checkScale =
              0.78 + (Curves.easeOutBack.transform(checkT) * 0.22);
          final checkOpacity = Curves.easeOut.transform(checkT);

          return ClipRRect(
            borderRadius: BorderRadius.circular(_contentWidth * 0.18),
            child: Stack(
              children: [
                Positioned(
                  left: _contentWidth * 0.45,
                  right: _contentWidth * 0.16,
                  top: _contentWidth * 0.40,
                  child: Center(
                    child: SizedBox(
                      width: _contentWidth * 0.42,
                      height: _contentWidth * 0.42,
                      child: ClipOval(
                        child: SvgPicture.asset(
                          HandphoneWidget._profileAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: _contentWidth * 0.12,
                  right: _contentWidth * 0.12,
                  top: _contentHeight * 0.52,
                  bottom: _contentHeight * 0.08,
                  child: Transform.rotate(
                    angle: 0.25,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: dotsOpacity,
                          child: _LoadingDots(
                            size: _contentWidth * 0.092,
                            progress: _stateCtrl.value,
                          ),
                        ),
                        Opacity(
                          opacity: checkOpacity,
                          child: Transform.scale(
                            scale: checkScale,
                            child: _SuccessCheck(size: _contentWidth * 0.30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.size, required this.progress});

  final double size;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final wave =
            math.sin(((progress * math.pi * 2) - (index * 0.72))) * 0.5 + 0.5;
        final scale = 0.82 + (wave * 0.28);
        final opacity = 0.45 + (wave * 0.55);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: size * 0.12),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Color(0xFF5E2E57),
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

class _SuccessCheck extends StatelessWidget {
  const _SuccessCheck({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.92,
            height: size * 0.92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF2FFF4),
              border: Border.all(
                color: const Color(0xFF44A95C),
                width: math.max(2.0, size * 0.082),
              ),
            ),
          ),
          SizedBox(
            width: size * 0.46,
            height: size * 0.36,
            child: CustomPaint(
              painter: _CheckPainter(
                color: const Color(0xFF44A95C),
                strokeWidth: math.max(3.0, size * 0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.56)
      ..lineTo(size.width * 0.40, size.height * 0.76)
      ..lineTo(size.width * 0.78, size.height * 0.26);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
