import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'floating_three_widget.dart';
import 'handphone_widget.dart';
import 'leaf3_widget.dart';
import 'leaf4_widget.dart';
import 'rope_link_widget.dart';
import 'sparkle3_widget.dart';

class LinkAccountWidget extends StatefulWidget {
  const LinkAccountWidget({super.key, this.width = 360});

  final double width;

  static const String _backgroundAsset = 'assets/background/backgroundlink.png';
  static const String _leaf3Asset = 'assets/icons/leaf3.svg';
  static const String _leaf4Asset = 'assets/icons/leaf4.svg';
  static const double _backgroundAspectRatio = 1661 / 929;
  static const double _leaf3AspectRatio = 212 / 289;
  static const double _leaf4AspectRatio = 101 / 245;
  static const double _leaf3WidthFactor = 0.050;
  static const double _leaf4WidthFactor = 0.060;
  static const double _leaf3RightFactor = 0.023;
  static const double _leaf3BottomFactor = 0.446;
  static const double _leaf4LeftFactor = 0.014;
  static const double _leaf4BottomFactor = 0.170;
  static const double _handphoneWidthFactor = 0.095;
  static const double _handphoneLeftFactor = 0.384;
  static const double _handphoneTopFactor = 0.360;
  static const double _ropeLinkWidthFactor = 0.103;
  static const double _ropeLinkLeftFactor = 0.475;
  static const double _ropeLinkTopFactor = 0.500;

  @override
  State<LinkAccountWidget> createState() => _LinkAccountWidgetState();
}

class _LinkAccountWidgetState extends State<LinkAccountWidget> {
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
      await precacheImage(
        const AssetImage(LinkAccountWidget._backgroundAsset),
        context,
      );
      if (!mounted) {
        return;
      }
      await Future.wait([
        SvgAssetLoader(LinkAccountWidget._leaf3Asset).loadBytes(context),
        SvgAssetLoader(LinkAccountWidget._leaf4Asset).loadBytes(context),
        SvgAssetLoader('assets/icons/recycle.svg').loadBytes(context),
        SvgAssetLoader('assets/icons/shield3.svg').loadBytes(context),
        SvgAssetLoader('assets/icons/chain.svg').loadBytes(context),
        SvgAssetLoader('assets/icons/child_profile.svg').loadBytes(context),
        SvgAssetLoader('assets/icons/rope_link.svg').loadBytes(context),
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
    final height = width / LinkAccountWidget._backgroundAspectRatio;
    final leaf3Width = width * LinkAccountWidget._leaf3WidthFactor;
    final leaf3Height = leaf3Width / LinkAccountWidget._leaf3AspectRatio;
    final leaf4Width = width * LinkAccountWidget._leaf4WidthFactor;
    final leaf4Height = leaf4Width / LinkAccountWidget._leaf4AspectRatio;
    final handphoneWidth = width * LinkAccountWidget._handphoneWidthFactor;
    final ropeLinkWidth = width * LinkAccountWidget._ropeLinkWidthFactor;

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
              child: Image.asset(
                LinkAccountWidget._backgroundAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: FloatingThreeWidget(width: width, height: height),
          ),
          Positioned.fill(
            child: Sparkle3Widget(width: width, height: height),
          ),
          Positioned(
            left: width * LinkAccountWidget._ropeLinkLeftFactor,
            top: height * LinkAccountWidget._ropeLinkTopFactor,
            child: RopeLinkWidget(width: ropeLinkWidth),
          ),
          Positioned(
            left: width * LinkAccountWidget._handphoneLeftFactor,
            top: height * LinkAccountWidget._handphoneTopFactor,
            child: HandphoneWidget(width: handphoneWidth),
          ),
          Positioned(
            left: width * LinkAccountWidget._leaf4LeftFactor,
            bottom: height * LinkAccountWidget._leaf4BottomFactor,
            child: Leaf4Widget(width: leaf4Width, height: leaf4Height),
          ),
          Positioned(
            right: width * LinkAccountWidget._leaf3RightFactor,
            bottom: height * LinkAccountWidget._leaf3BottomFactor,
            child: Leaf3Widget(width: leaf3Width, height: leaf3Height),
          ),
        ],
      ),
    );
  }
}
