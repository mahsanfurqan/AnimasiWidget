import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'handphone2_widget.dart';
import 'floating_four_widget.dart';
import 'hijab_girl_widget.dart';
import 'pot_leaf_widget.dart';
import 'sparkle4_widget.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key, this.width = 360});

  final double width;

  static const String _backgroundAsset =
      'assets/background/background_onboarding.svg';
  static const double _backgroundAspectRatio = 8483 / 11367;
  static const Alignment _backgroundAlignment = Alignment(0.12, 0.0);
  static const double _hijabGirlWidthFactor = 0.25;
  static const double _hijabGirlLeftFactor = 0.08;
  static const double _hijabGirlTopFactor = 0.35;
  static const double _handphone2WidthFactor = 0.29;
  static const double _handphone2LeftFactor = 0.59;
  static const double _handphone2TopFactor = 0.09;
  static const double _leaf3AspectRatio = 1330 / 1670;
  static const double _leaf3WidthFactor = 0.10;
  static const double _leaf3LeftFactor = 0.109;
  static const double _leaf3TopFactor = 0.778;

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  bool _backgroundReady = false;
  bool _startedPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startedPrecache) {
      return;
    }
    _startedPrecache = true;
    _precacheBackground();
  }

  Future<void> _precacheBackground() async {
    try {
      await SvgAssetLoader(
        OnboardingWidget._backgroundAsset,
      ).loadBytes(context);
      if (!mounted) {
        return;
      }
      await Future.wait([
        SvgAssetLoader(HijabGirlWidget.backAsset).loadBytes(context),
        SvgAssetLoader(HijabGirlWidget.armAsset).loadBytes(context),
        SvgAssetLoader(HijabGirlWidget.frontAsset).loadBytes(context),
        SvgAssetLoader('assets/icons/hand_handphone.svg').loadBytes(context),
        SvgAssetLoader(PotLeafWidget.baseAsset).loadBytes(context),
        SvgAssetLoader(PotLeafWidget.leafAsset).loadBytes(context),
        SvgAssetLoader('assets/icons/blok square.svg').loadBytes(context),
        SvgAssetLoader('assets/icons/sparkle.svg').loadBytes(context),
        precacheImage(
          const AssetImage('assets/icons/handphone_runtime.png'),
          context,
        ),
      ]);
    } catch (_) {
      // Keep the widget usable even if preload fails.
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _backgroundReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = width / OnboardingWidget._backgroundAspectRatio;
    final hijabGirlWidth = width * OnboardingWidget._hijabGirlWidthFactor;
    final handphone2Width = width * OnboardingWidget._handphone2WidthFactor;
    final leaf3Width = width * OnboardingWidget._leaf3WidthFactor;
    final leaf3Height = leaf3Width / OnboardingWidget._leaf3AspectRatio;

    if (!_backgroundReady) {
      return SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const ColoredBox(color: Color(0xFFF8E7DF)),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SvgPicture.asset(
                OnboardingWidget._backgroundAsset,
                fit: BoxFit.cover,
                alignment: OnboardingWidget._backgroundAlignment,
              ),
            ),
          ),
          Positioned.fill(
            child: Sparkle4Widget(width: width, height: height),
          ),
          Positioned.fill(
            child: FloatingFourWidget(width: width, height: height),
          ),
          Positioned(
            left: width * OnboardingWidget._handphone2LeftFactor,
            top: height * OnboardingWidget._handphone2TopFactor,
            child: Handphone2Widget(width: handphone2Width),
          ),
          Positioned(
            left: width * OnboardingWidget._hijabGirlLeftFactor,
            top: height * OnboardingWidget._hijabGirlTopFactor,
            child: HijabGirlWidget(width: hijabGirlWidth),
          ),
          Positioned(
            left: width * OnboardingWidget._leaf3LeftFactor,
            top: height * OnboardingWidget._leaf3TopFactor,
            child: PotLeafWidget(width: leaf3Width, height: leaf3Height),
          ),
        ],
      ),
    );
  }
}
