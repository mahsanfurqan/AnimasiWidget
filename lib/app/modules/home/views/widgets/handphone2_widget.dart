import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Handphone2Widget extends StatefulWidget {
  const Handphone2Widget({super.key, required this.width});

  static const String _backgroundAsset = 'assets/icons/handphone_runtime.png';
  static const String _handAsset = 'assets/icons/hand_handphone.svg';
  static const double _backgroundScale = 1.55;
  static const double _loadingWidthFactor = 0.70;
  static const double _loadingHeightFactor = 0.050;
  static const double _loadingLeftFactor = 0.09;
  static const double _loadingTopFactor = 0.507;
  static const double _loadingRotation = 0.155;

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
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final backgroundCacheWidth = (_contentWidth * devicePixelRatio * 3)
        .round()
        .clamp(1, 4096);

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
          final loadingPulse = (math.sin(t * math.pi * 2) + 1) / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Transform.scale(
                  scale: Handphone2Widget._backgroundScale,
                  alignment: Alignment.center,
                  child: Image.asset(
                    Handphone2Widget._backgroundAsset,
                    fit: BoxFit.contain,
                    cacheWidth: backgroundCacheWidth,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
              Positioned(
                left: _contentWidth * 0.32,
                top: _contentHeight * 0.147,
                child: Transform.rotate(
                  angle: 0.15,
                  child: _LiveDot(
                    size: _contentWidth * 0.042,
                    progress: livePulse,
                  ),
                ),
              ),
              Positioned(
                right: _contentWidth * 0.05,
                top: _contentHeight * 0.15,
                child: Transform.rotate(
                  angle: 0.15,
                  child: _LoadingDots(width: _contentWidth * 0.18, progress: t),
                ),
              ),
              Positioned(
                left: _contentWidth * Handphone2Widget._loadingLeftFactor,
                top: _contentHeight * Handphone2Widget._loadingTopFactor,
                child: Transform.rotate(
                  angle: Handphone2Widget._loadingRotation,
                  child: _StreamLoadingBar(
                    width: _contentWidth * Handphone2Widget._loadingWidthFactor,
                    height:
                        _contentWidth * Handphone2Widget._loadingHeightFactor,
                    progress: t,
                    pulse: loadingPulse,
                  ),
                ),
              ),
              Positioned(
                left: _contentWidth * 0.28,
                top: _contentHeight * 0.86,
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
                left: _contentWidth * -0.010,
                top: _contentHeight * 0.845,
                child: Transform.rotate(
                  angle: 0.30,
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

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _PastelEmojiPainter()),
        ),
      ),
    );
  }
}

class _PastelEmojiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor = const Color(0xFF6D3E69);
    final facePaint = Paint()..color = const Color(0xFFFFD88C);
    final blushPaint = Paint()..color = const Color(0xFFF5A2B3);
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final featurePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    final faceRect = Rect.fromLTWH(
      size.width * 0.10,
      size.height * 0.10,
      size.width * 0.80,
      size.height * 0.80,
    );
    canvas.drawOval(faceRect, facePaint);
    canvas.drawOval(faceRect, strokePaint);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.36, size.height * 0.38),
        width: size.width * 0.085,
        height: size.height * 0.12,
      ),
      featurePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.62, size.height * 0.38),
        width: size.width * 0.085,
        height: size.height * 0.12,
      ),
      featurePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.26, size.height * 0.58),
        width: size.width * 0.14,
        height: size.height * 0.09,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.72, size.height * 0.58),
        width: size.width * 0.14,
        height: size.height * 0.09,
      ),
      blushPaint,
    );

    final smilePath = Path()
      ..moveTo(size.width * 0.31, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.49,
        size.height * 0.74,
        size.width * 0.68,
        size.height * 0.58,
      );
    canvas.drawPath(smilePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

class _StreamLoadingBar extends StatelessWidget {
  const _StreamLoadingBar({
    required this.width,
    required this.height,
    required this.progress,
    required this.pulse,
  });

  final double width;
  final double height;
  final double progress;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    final borderWidth = math.max(1.1, height * 0.16);
    final packetWidthFactor = 0.34;
    final highlightWidthFactor = 0.14;
    final echoWidthFactor = 0.14;
    final startColor =
        Color.lerp(const Color(0xFF84B79A), const Color(0xFF9CC8AD), pulse) ??
        const Color(0xFF9CC8AD);
    final endColor =
        Color.lerp(const Color(0xFF9CC8AD), const Color(0xFFC1E0CB), pulse) ??
        const Color(0xFFC1E0CB);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(height * 0.12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF7),
        borderRadius: BorderRadius.circular(height),
        border: Border.all(color: const Color(0xFF302E43), width: borderWidth),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Stack(
          children: [
            Container(color: const Color(0xFFDCECDF)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    startColor.withValues(alpha: 0.12),
                    endColor.withValues(alpha: 0.12),
                  ],
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final packetWidth = constraints.maxWidth * packetWidthFactor;
                final highlightWidth =
                    constraints.maxWidth * highlightWidthFactor;
                final echoWidth = constraints.maxWidth * echoWidthFactor;

                Widget buildPacket({
                  required double travel,
                  required double opacityScale,
                }) {
                  final packetLeftPx =
                      (-packetWidth) +
                      ((constraints.maxWidth + packetWidth) * travel);
                  final highlightLeft =
                      packetLeftPx + ((packetWidth - highlightWidth) * 0.52);
                  final echoLeft = packetLeftPx - (echoWidth * 0.38);

                  return Stack(
                    children: [
                      Positioned(
                        left: packetLeftPx,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: packetWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                startColor.withValues(alpha: 0.00),
                                startColor.withValues(
                                  alpha: 0.72 * opacityScale,
                                ),
                                endColor.withValues(alpha: 0.96 * opacityScale),
                                endColor.withValues(alpha: 0.00),
                              ],
                              stops: const [0.0, 0.24, 0.78, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: highlightLeft,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: highlightWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                const Color(0x00FFFFFF),
                                const Color(
                                  0x88F5FFF8,
                                ).withValues(alpha: 0.53 * opacityScale),
                                const Color(0x00FFFFFF),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: echoLeft,
                        top: constraints.maxHeight * 0.10,
                        bottom: constraints.maxHeight * 0.10,
                        child: Container(
                          width: echoWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                startColor.withValues(alpha: 0.00),
                                startColor.withValues(
                                  alpha: 0.26 * opacityScale,
                                ),
                                endColor.withValues(alpha: 0.00),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Stack(
                  children: [
                    buildPacket(travel: progress, opacityScale: 1.0),
                    buildPacket(
                      travel: (progress + 0.34) % 1.0,
                      opacityScale: 0.72,
                    ),
                    buildPacket(
                      travel: (progress + 0.68) % 1.0,
                      opacityScale: 0.52,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
