import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'onboarding_widget.dart';

class OnboardingExpandableWidget extends StatefulWidget {
  const OnboardingExpandableWidget({super.key, this.width = 360});

  final double width;

  @override
  State<OnboardingExpandableWidget> createState() =>
      _OnboardingExpandableWidgetState();
}

class _OnboardingExpandableWidgetState
    extends State<OnboardingExpandableWidget> {
  static const double _previewAspectRatio = 1090 / 508;
  static const Color _panelBackground = Color(0xFFEAE7FB);
  static const double _pinkGirlWidthFactor = 0.19;
  static const double _pinkGirlHeightFactor = 0.37;
  static const double _pinkGirlCenterXFactor = 0.100;
  static const double _pinkGirlTopFactor = 0.15;
  static const double _hijabGirlWidthFactor = 0.13;
  static const double _hijabGirlHeightFactor = 0.30;
  static const double _hijabGirlCenterXFactor = 0.25;
  static const double _hijabGirlTopFactor = 0.49;
  static const double _ipadBoySizeFactor = 0.17;
  static const double _ipadBoyCenterXFactor = 0.400;
  static const double _ipadBoyTopFactor = 0.16;
  static const double _handphoneWidthFactor = 0.22;
  static const double _handphoneCenterXFactor = 0.57;
  static const double _handphoneTopFactor = 0.15;
  static const double _orangeGirlWidthFactor = 0.34;
  static const double _orangeGirlCenterXFactor = 0.815;
  static const double _orangeGirlTopFactor = 0.26;
  static const double _tapToLearnTextWidthFactor = 0.30;
  static const double _tapToLearnTextFontFactor = 0.050;
  static const List<String> _previewImageAssets = [
    'assets/icons/ipad_boy_preview.png',
    'assets/icons/orange_girl_preview.png',
    'assets/icons/handphone_preview.png',
    'assets/icons/pink_girl_preview.png',
  ];
  static const String _previewHijabGirlAsset = 'assets/icons/hijab_girl.svg';

  bool _expanded = false;
  bool _startedPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startedPrecache) {
      return;
    }
    _startedPrecache = true;
    _precachePreviewAssets();
  }

  Future<void> _precachePreviewAssets() async {
    try {
      await Future.wait(
        _previewImageAssets.map(
          (asset) => precacheImage(AssetImage(asset), context),
        ),
      );
      if (!mounted) {
        return;
      }
      await SvgAssetLoader(_previewHijabGirlAsset).loadBytes(context);
    } catch (_) {
      // Keep the preview usable even if a preload asset fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 720),
      firstCurve: Curves.easeInOutCubic,
      secondCurve: Curves.easeInOutCubic,
      sizeCurve: Curves.easeInOutCubic,
      crossFadeState: _expanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: _PreviewPanel(
        width: widget.width,
        onTap: () {
          if (_expanded) {
            return;
          }
          setState(() {
            _expanded = true;
          });
        },
      ),
      secondChild: OnboardingWidget(width: widget.width),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({required this.width, required this.onTap});

  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final height = width / _OnboardingExpandableWidgetState._previewAspectRatio;
    final pinkGirlWidth =
        width * _OnboardingExpandableWidgetState._pinkGirlWidthFactor;
    final pinkGirlHeight =
        height * _OnboardingExpandableWidgetState._pinkGirlHeightFactor;
    final hijabGirlWidth =
        width * _OnboardingExpandableWidgetState._hijabGirlWidthFactor;
    final hijabGirlHeight =
        height * _OnboardingExpandableWidgetState._hijabGirlHeightFactor;
    final ipadBoySize =
        width * _OnboardingExpandableWidgetState._ipadBoySizeFactor;
    final handphoneWidth =
        width * _OnboardingExpandableWidgetState._handphoneWidthFactor;
    final orangeGirlWidth =
        width * _OnboardingExpandableWidgetState._orangeGirlWidthFactor;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              color: _OnboardingExpandableWidgetState._panelBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left:
                      (width *
                          _OnboardingExpandableWidgetState
                              ._pinkGirlCenterXFactor) -
                      (pinkGirlWidth / 2),
                  top:
                      height *
                      _OnboardingExpandableWidgetState._pinkGirlTopFactor,
                  child: SizedBox(
                    width: pinkGirlWidth,
                    height: pinkGirlHeight,
                    child: Image.asset(
                      'assets/icons/pink_girl_preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left:
                      (width *
                          _OnboardingExpandableWidgetState
                              ._hijabGirlCenterXFactor) -
                      (hijabGirlWidth / 2),
                  top:
                      height *
                      _OnboardingExpandableWidgetState._hijabGirlTopFactor,
                  child: SizedBox(
                    width: hijabGirlWidth,
                    height: hijabGirlHeight,
                    child: SvgPicture.asset(
                      'assets/icons/hijab_girl.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left:
                      (width *
                          _OnboardingExpandableWidgetState
                              ._ipadBoyCenterXFactor) -
                      (ipadBoySize / 2),
                  top:
                      height *
                      _OnboardingExpandableWidgetState._ipadBoyTopFactor,
                  child: SizedBox(
                    width: ipadBoySize,
                    height: ipadBoySize,
                    child: Image.asset(
                      'assets/icons/ipad_boy_preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left:
                      (width *
                          _OnboardingExpandableWidgetState
                              ._handphoneCenterXFactor) -
                      (handphoneWidth / 2),
                  top:
                      height *
                      _OnboardingExpandableWidgetState._handphoneTopFactor,
                  child: Transform.rotate(
                    angle: 0.10,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: handphoneWidth,
                      child: Image.asset(
                        'assets/icons/handphone_preview.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left:
                      (width *
                          _OnboardingExpandableWidgetState
                              ._orangeGirlCenterXFactor) -
                      (orangeGirlWidth / 2),
                  top:
                      height *
                      _OnboardingExpandableWidgetState._orangeGirlTopFactor,
                  child: SizedBox(
                    width: orangeGirlWidth,
                    child: Image.asset(
                      'assets/icons/orange_girl_preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: height * 0.05,
                  child: Center(
                    child: SizedBox(
                      width:
                          width *
                          _OnboardingExpandableWidgetState
                              ._tapToLearnTextWidthFactor,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'tap to learn more',
                          softWrap: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF1FA5CE),
                            fontSize:
                                width *
                                _OnboardingExpandableWidgetState
                                    ._tapToLearnTextFontFactor,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
