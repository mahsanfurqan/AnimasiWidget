import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'floating_two_widget.dart';
import 'hand_widget.dart';
import 'leaf2_widget.dart';
import 'profile_child_widget.dart';
import 'rope_connector_widget.dart';
import 'sparkle2_widget.dart';

class AddNewChildWidget extends StatefulWidget {
  const AddNewChildWidget({super.key, this.width = 360});

  final double width;

  @override
  State<AddNewChildWidget> createState() => _AddNewChildWidgetState();
}

class _AddNewChildWidgetState extends State<AddNewChildWidget>
    with TickerProviderStateMixin {
  static const List<String> _svgAssets = [
    'assets/icons/leaf2.svg',
    'assets/icons/sparkle.svg',
    'assets/icons/telescope.svg',
    'assets/icons/shield2.svg',
    'assets/icons/key.svg',
    'assets/icons/blok square.svg',
    'assets/icons/profile.svg',
    'assets/icons/hand.svg',
    'assets/icons/sofa_right.svg',
  ];
  static const String _backgroundAsset =
      'assets/background/backgroundwidgetadd.png';
  static const String _sofaRightAsset = 'assets/icons/sofa_right.svg';
  static const double _backgroundAspectRatio = 2762 / 1543;
  static const double _leafAspectRatio = 155 / 315;
  static const double _handAspectRatio = 0.93;
  static const double _leafWidthFactor = 0.060;
  static const double _leafLeftFactor = 0.066;
  static const double _leafBottomFactor = 0.350;
  static const double _profileCardWidthFactor = 0.140;
  static const double _profileCardCenterXFactor = 0.670;
  static const double _profileCardTopFactor = 0.105;
  static const double _sofaRightWidthFactor = 0.230;
  static const double _sofaRightRightFactor = 0.615;
  static const double _sofaRightBottomFactor = 0.000;
  static const double _handWidthFactor = 0.200;
  static const double _handRightFactor = 0.460;
  static const double _handBottomFactor = 0.109;
  static const double _ropeWidthScale = 0.40;
  static const double _ropeShiftRightFactor = 0.400;
  static const double _ropeShiftTopFactor = -0.125;

  late final AnimationController _ropeCtrl;
  late final AnimationController _ambientCtrl;
  late final AnimationController _profileIntroCtrl;
  late final Animation<double> _profileFade;
  late final Animation<Offset> _profileSlide;
  bool _assetsReady = false;
  bool _startedPrecache = false;
  bool _hasStartedEntrance = false;
  bool _isVisibleEnough = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startedPrecache) {
      return;
    }
    _startedPrecache = true;
    _precacheAssets();
  }

  @override
  void dispose() {
    _ropeCtrl.dispose();
    _ambientCtrl.dispose();
    _profileIntroCtrl.dispose();
    super.dispose();
  }

  Future<void> _precacheAssets() async {
    try {
      await precacheImage(const AssetImage(_backgroundAsset), context);
      await Future.wait(
        _svgAssets.map((asset) => SvgAssetLoader(asset).loadBytes(context)),
      );
    } catch (_) {
      // Keep rendering the scene even if one preload asset fails.
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _assetsReady = true;
    });
    if (_isVisibleEnough) {
      _playEntranceSequence();
    }
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
    if (!_assetsReady) {
      return SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const ColoredBox(color: Color(0xFFF8E7DF)),
        ),
      );
    }

    final leafWidthFactor = isLandscape ? 0.050 : _leafWidthFactor;
    final leafLeftFactor = isLandscape ? 0.085 : _leafLeftFactor;
    final leafBottomFactor = isLandscape ? 0.350 : _leafBottomFactor;
    final leafWidth = width * leafWidthFactor;
    final leafHeight = leafWidth / _leafAspectRatio;

    final profileCardWidthFactor = isLandscape
        ? 0.150
        : _profileCardWidthFactor;
    final profileCardCenterXFactor = isLandscape
        ? 0.680
        : _profileCardCenterXFactor;
    final profileCardTopFactor = isLandscape ? 0.095 : _profileCardTopFactor;
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
    final ropeWidthScale = isLandscape ? 0.48 : _ropeWidthScale;
    final ropeShiftRightFactor = isLandscape ? 0.020 : _ropeShiftRightFactor;
    final ropeShiftTopFactor = isLandscape ? -0.020 : _ropeShiftTopFactor;
    final ropeStartXFactor = isLandscape ? 0.33 : 0.30;
    final ropeStartYFactor = isLandscape ? 0.82 : 0.81;
    final ropeFlatYFactor = isLandscape ? 0.83 : 0.82;
    final ropeEndXFactor = isLandscape ? -0.90 : -1.2;
    final ropeEndYOffsetFactor = isLandscape ? 0.29 : 0.37;

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
    final ropeBendStartOffsetFactor = isLandscape ? 0.12 : 0.20;
    final ropeBendStart = Offset(
      ropeStart.dx + (width * ropeWidthScale * ropeBendStartOffsetFactor),
      height * ropeFlatYFactor,
    );
    final ropeOutlineWidth = 6.0;
    final ropeStrokeWidth = 4.6;

    return VisibilityDetector(
      key: const Key('add-new-child-widget-visibility'),
      onVisibilityChanged: (info) {
        _isVisibleEnough = info.visibleFraction > 0.35;
        if (_assetsReady && !_hasStartedEntrance && _isVisibleEnough) {
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
              child: Sparkle2Widget(width: width, height: height),
            ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([_ropeCtrl, _ambientCtrl]),
                builder: (context, _) {
                  final t =
                      (math.sin(_ambientCtrl.value * math.pi * 2) + 1) / 2;
                  final curveBreath =
                      (math.sin(_ambientCtrl.value * math.pi * 2) + 1) / 2;
                  final animatedRopeBendStart = Offset(
                    ropeBendStart.dx + (width * 0.010 * curveBreath),
                    ropeBendStart.dy - (height * 0.012 * curveBreath),
                  );
                  final animatedRopeEnd = Offset(
                    ropeEnd.dx + (width * 0.003 * curveBreath),
                    ropeEnd.dy - (height * 0.002 * curveBreath),
                  );
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
                      width * ropeShiftRightFactor * (1 - ropeWidthScale),
                      height * ropeShiftTopFactor,
                    ),
                    child: RopeConnectorWidget(
                      width: width,
                      height: height,
                      progress: _ropeCtrl.value,
                      start: ropeStart,
                      controlOne: ropeStart,
                      controlTwo: animatedRopeBendStart,
                      bendStart: animatedRopeBendStart,
                      bendEnd: animatedRopeEnd,
                      end: animatedRopeEnd,
                      shadowWidth: ropeOutlineWidth,
                      strokeWidth: ropeStrokeWidth,
                      shadowColor: const Color(0xFF6D3E69),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [ropeStartColor, ropeEndColor],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: FloatingTwoWidget(width: width, height: height),
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
