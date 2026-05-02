import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'new_badge_widget.dart';

class ProfileChildWidget extends StatefulWidget {
  const ProfileChildWidget({super.key, required this.width});

  final double width;

  static const String _profileAsset = 'assets/icons/profile.svg';
  static const double cardAspectRatio = 0.70;

  @override
  State<ProfileChildWidget> createState() => _ProfileChildWidgetState();
}

class _ProfileChildWidgetState extends State<ProfileChildWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambientCtrl;

  double get _cardWidth => widget.width;
  double get _cardHeight => _cardWidth / ProfileChildWidget.cardAspectRatio;
  double get _badgeWidth => _cardWidth * 0.78;
  double get _cardBorderWidth => math.max(1.4, _cardWidth * 0.022);
  double get _avatarBorderWidth => math.max(1.1, _cardWidth * 0.014);
  double get _loadingBorderWidth => math.max(1.2, _cardWidth * 0.016);

  @override
  void initState() {
    super.initState();
    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ambientCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _cardWidth,
      height: _cardHeight + (_cardHeight * 0.13),
      child: AnimatedBuilder(
        animation: _ambientCtrl,
        builder: (context, _) {
          final t = (math.sin(_ambientCtrl.value * math.pi * 2) + 1) / 2;
          final floatY = math.sin(_ambientCtrl.value * math.pi * 2) * 1.8;
          final cardGlow =
              Color.lerp(const Color(0x26F7D3A2), const Color(0x45F7E2B4), t) ??
              const Color(0x33F7D8AA);
          final loadingStart =
              Color.lerp(const Color(0xFFB8B1DD), const Color(0xFFD59AB1), t) ??
              const Color(0xFFC8A6C7);
          final loadingEnd =
              Color.lerp(const Color(0xFFDFA7B9), const Color(0xFFE8C18A), t) ??
              const Color(0xFFE3B3A2);
          final avatarRing =
              Color.lerp(const Color(0xFFE9E2FB), const Color(0xFFF5EBFF), t) ??
              const Color(0xFFF0E7FD);

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: _cardHeight * 0.12,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: _cardWidth,
                    height: _cardHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_cardWidth * 0.11),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFFDF6), Color(0xFFFFFBF2)],
                      ),
                      border: Border.all(
                        color: const Color(0xFF6D3E69),
                        width: _cardBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cardGlow,
                          blurRadius: 18 + (t * 10),
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: _cardWidth * 0.09,
                          top: _cardHeight * 0.07,
                          child: _DecorSparkle(
                            color: const Color(0xFFE4B06D),
                            size: _cardWidth * 0.09,
                          ),
                        ),
                        Positioned(
                          right: _cardWidth * 0.11,
                          top: _cardHeight * 0.39,
                          child: _DecorSparkle(
                            color: const Color(0xFFC7BFE8),
                            size: _cardWidth * 0.080,
                          ),
                        ),
                        Positioned(
                          top: _cardHeight * 0.08,
                          left: _cardWidth * 0.16,
                          right: _cardWidth * 0.16,
                          child: Column(
                            children: [
                              Container(
                                width: _cardWidth * 0.43,
                                height: _cardWidth * 0.43,
                                padding: EdgeInsets.all(_cardWidth * 0.026),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: avatarRing,
                                  border: Border.all(
                                    color: const Color(0xFF6D3E69),
                                    width: _avatarBorderWidth,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x22FFFFFF),
                                      blurRadius: 10 + (t * 4),
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  ProfileChildWidget._profileAsset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: _cardHeight * 0.06),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _ScoreIcon(
                                    icon: Icons.star_rounded,
                                    color: const Color(0xFFD79ED1),
                                    size: _cardWidth * 0.155,
                                  ),
                                  _ScoreIcon(
                                    icon: Icons.star_rounded,
                                    color: const Color(0xFFF1B489),
                                    size: _cardWidth * 0.155,
                                  ),
                                  _ScoreIcon(
                                    icon: Icons.close_rounded,
                                    color: const Color(0xFFF2B46F),
                                    size: _cardWidth * 0.165,
                                  ),
                                ],
                              ),
                              SizedBox(height: _cardHeight * 0.05),
                              _SoftLine(width: _cardWidth * 0.66),
                              SizedBox(height: _cardHeight * 0.03),
                              _SoftLine(width: _cardWidth * 0.50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: (_cardWidth - _badgeWidth) / 2,
                  top: 0,
                  child: NewBadgeWidget(width: _badgeWidth),
                ),
                Positioned(
                  left: _cardWidth * 0.16,
                  right: _cardWidth * 0.16,
                  bottom: 0,
                  child: Container(
                    height: _cardHeight * 0.095,
                    padding: EdgeInsets.all(_cardWidth * 0.018),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF5),
                      borderRadius: BorderRadius.circular(_cardHeight * 0.08),
                      border: Border.all(
                        color: const Color(0xFF6D3E69),
                        width: _loadingBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x20D58DA5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_cardHeight * 0.06),
                      child: Stack(
                        children: [
                          Container(color: const Color(0xFFE7DEF2)),
                          FractionallySizedBox(
                            widthFactor: 0.62 + (t * 0.10),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [loadingStart, loadingEnd],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _DecorSparkle extends StatelessWidget {
  const _DecorSparkle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome_rounded, color: color, size: size);
  }
}

class _ScoreIcon extends StatelessWidget {
  const _ScoreIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
      shadows: const [Shadow(color: Color(0x18FFFFFF), blurRadius: 2)],
    );
  }
}

class _SoftLine extends StatelessWidget {
  const _SoftLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFFE1D3E8),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
