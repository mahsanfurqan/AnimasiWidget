import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'floating_two_widget.dart';
import 'hand_widget.dart';
import 'leaf2_widget.dart';
import 'profile_child_widget.dart';
import 'rope_connector_widget.dart';

class AddNewChildWidget extends StatefulWidget {
  const AddNewChildWidget({super.key, this.width = 360});

  final double width;

  @override
  State<AddNewChildWidget> createState() => _AddNewChildWidgetState();
}

class _AddNewChildWidgetState extends State<AddNewChildWidget>
    with TickerProviderStateMixin {
  static const String _backgroundAsset =
      'assets/background/backgroundwidgetadd.png';
  static const String _sofaRightAsset = 'assets/icons/sofa_right.svg';
  static const double _backgroundAspectRatio = 2762 / 1543;
  static const double _leafAspectRatio = 155 / 315;
  static const double _handAspectRatio = 0.93;
  static const double _leafWidthFactor = 0.060;
  static const double _leafLeftFactor = 0.063;
  static const double _leafBottomFactor = 0.350;
  static const double _profileCardWidthFactor = 0.140;
  static const double _profileCardCenterXFactor = 0.670;
  static const double _profileCardTopFactor = 0.105;
  static const double _sofaRightWidthFactor = 0.230;
  static const double _sofaRightRightFactor = 0.615;
  static const double _sofaRightBottomFactor = 0.000;
  static const double _handWidthFactor = 0.200;
  static const double _handRightFactor = 0.450;
  static const double _handBottomFactor = 0.109;
  static const double _ropeWidthScale = 0.50;
  static const double _ropeShiftRightFactor = 0.339;
  static const double _ropeShiftTopFactor = -0.125;

  late final AnimationController _ropeCtrl;
  late final AnimationController _ambientCtrl;
  late final AnimationController _profileIntroCtrl;
  late final Animation<double> _profileFade;
  late final Animation<Offset> _profileSlide;
  bool _hasStartedEntrance = false;

  @override
  void initState() {
    super.initState();
    _ropeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1550),
    );
    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);
    _profileIntroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );
    _profileFade = CurvedAnimation(
      parent: _profileIntroCtrl,
      curve: Curves.easeOutCubic,
    );
    _profileSlide =
        Tween<Offset>(begin: const Offset(0, 0.16), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _profileIntroCtrl,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _ropeCtrl.dispose();
    _ambientCtrl.dispose();
    _profileIntroCtrl.dispose();
    super.dispose();
  }

  Future<void> _playEntranceSequence() async {
    if (_hasStartedEntrance) {
      return;
    }
    _hasStartedEntrance = true;
    await _ropeCtrl.forward(from: 0);
    if (!mounted) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 90));
    if (!mounted) {
      return;
    }
    await _profileIntroCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final width = widget.width;
    final height = width / _backgroundAspectRatio;

    final leafWidthFactor = isLandscape ? 0.050 : _leafWidthFactor;
    final leafLeftFactor = isLandscape ? 0.085 : _leafLeftFactor;
    final leafBottomFactor = isLandscape ? 0.350 : _leafBottomFactor;
    final leafWidth = width * leafWidthFactor;
    final leafHeight = leafWidth / _leafAspectRatio;

    final profileCardWidthFactor = isLandscape
        ? 0.180
        : _profileCardWidthFactor;
    final profileCardCenterXFactor = isLandscape
        ? 0.510
        : _profileCardCenterXFactor;
    final profileCardTopFactor = isLandscape ? 0.065 : _profileCardTopFactor;
    final profileCardWidth = (width * profileCardWidthFactor).roundToDouble();
    final profileCardLeft =
        ((width * profileCardCenterXFactor) - (profileCardWidth / 2))
            .roundToDouble();
    final profileCardTop = (height * profileCardTopFactor).roundToDouble();
    final profileCardHeight =
        profileCardWidth / ProfileChildWidget.cardAspectRatio;
    final profileCardTotalHeight =
        profileCardHeight + (profileCardHeight * 0.13);
    final sofaRightWidthFactor = isLandscape ? 0.100 : _sofaRightWidthFactor;
    final sofaRightRightFactor = isLandscape ? 0.060 : _sofaRightRightFactor;
    final sofaRightBottomFactor = isLandscape ? 0.092 : _sofaRightBottomFactor;
    final sofaRightWidth = width * sofaRightWidthFactor;

    final handWidthFactor = isLandscape ? 0.180 : _handWidthFactor;
    final handRightFactor = isLandscape ? 0.480 : _handRightFactor;
    final handBottomFactor = isLandscape ? 0.114 : _handBottomFactor;
    final handWidth = width * handWidthFactor;
    final handHeight = handWidth / _handAspectRatio;
    final ropeWidthScale = isLandscape ? 0.84 : _ropeWidthScale;
    final ropeShiftRightFactor = isLandscape ? 0.035 : _ropeShiftRightFactor;
    final ropeShiftTopFactor = isLandscape ? -0.012 : _ropeShiftTopFactor;
    final ropeStartXFactor = isLandscape ? 0.39 : 0.42;
    final ropeStartYFactor = isLandscape ? 0.79 : 0.81;
    final ropeControlOneXFactor = isLandscape ? 0.54 : 0.58;
    final ropeControlOneYFactor = isLandscape ? 0.82 : 0.83;
    final ropeControlTwoXFactor = isLandscape ? 0.58 : 0.61;
    final ropeControlTwoYOffsetFactor = isLandscape ? 0.220 : 0.260;
    final ropeEndXFactor = isLandscape ? 0.45 : 0.47;
    final ropeEndYOffsetFactor = isLandscape ? 0.180 : 0.220;

    final ropeStart = Offset(
      width * ropeStartXFactor,
      height * ropeStartYFactor,
    );
    final ropeEnd = Offset(
      profileCardLeft + (profileCardWidth * ropeEndXFactor),
      profileCardTop +
          profileCardTotalHeight +
          (profileCardHeight * ropeEndYOffsetFactor),
    );
    final ropeControlOne = Offset(
      width * ropeControlOneXFactor,
      height * ropeControlOneYFactor,
    );
    final ropeControlTwo = Offset(
      profileCardLeft + (profileCardWidth * ropeControlTwoXFactor),
      profileCardTop +
          profileCardTotalHeight +
          (profileCardHeight * ropeControlTwoYOffsetFactor),
    );

    return VisibilityDetector(
      key: const Key('add-new-child-widget-visibility'),
      onVisibilityChanged: (info) {
        if (!_hasStartedEntrance && info.visibleFraction > 0.35) {
          _playEntranceSequence();
        }
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(_backgroundAsset, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: width * leafLeftFactor,
            bottom: height * leafBottomFactor,
            child: Leaf2Widget(width: leafWidth, height: leafHeight),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([_ropeCtrl, _ambientCtrl]),
              builder: (context, _) {
                final t = (math.sin(_ambientCtrl.value * math.pi * 2) + 1) / 2;
                final floatY = math.sin(_ambientCtrl.value * math.pi * 2) * 1.8;
                final ropeStartColor =
                    Color.lerp(
                      const Color(0xFFB8B1DD),
                      const Color(0xFFD59AB1),
                      t,
                    ) ??
                    const Color(0xFFC8A6C7);
                final ropeEndColor =
                    Color.lerp(
                      const Color(0xFFDFA7B9),
                      const Color(0xFFE8C18A),
                      t,
                    ) ??
                    const Color(0xFFE3B3A2);
                return Transform.translate(
                  offset: Offset(
                    width * ropeShiftRightFactor,
                    (height * ropeShiftTopFactor) + floatY,
                  ),
                  child: Transform.scale(
                    scaleX: ropeWidthScale,
                    alignment: Alignment.centerLeft,
                    child: RopeConnectorWidget(
                      width: width,
                      height: height,
                      progress: _ropeCtrl.value,
                      start: ropeStart,
                      controlOne: ropeControlOne,
                      controlTwo: ropeControlTwo,
                      end: ropeEnd,
                      shadowWidth: 6.3,
                      strokeWidth: 4.5,
                      shadowColor: const Color(0xFF6D3E69),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [ropeStartColor, ropeEndColor],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: FloatingTwoWidget(
              width: width,
              height: height,
            ),
          ),
          Positioned(
            left: profileCardLeft,
            top: profileCardTop,
            child: FadeTransition(
              opacity: _profileFade,
              child: SlideTransition(
                position: _profileSlide,
                child: ProfileChildWidget(width: profileCardWidth),
              ),
            ),
          ),
          Positioned(
            right: width * handRightFactor,
            bottom: height * handBottomFactor,
            child: HandWidget(width: handWidth, height: handHeight),
          ),
          Positioned(
            right: width * sofaRightRightFactor,
            bottom: height * sofaRightBottomFactor,
            child: SvgPicture.asset(
              _sofaRightAsset,
              width: sofaRightWidth,
              fit: BoxFit.contain,
            ),
          ),
          ],
        ),
      ),
    );
  }
}
