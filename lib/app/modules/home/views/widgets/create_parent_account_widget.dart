import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'animated_cat_widget.dart';
import 'floating_object_widget.dart';
import 'leaf_widget.dart';
import 'new_badge_widget.dart';
import 'sparkle_field_widget.dart';
import 'star_rating_widget.dart';

class CreateParentAccountWidget extends StatefulWidget {
  const CreateParentAccountWidget({
    super.key,
    this.width = 360,
    this.totalStars = 5,
    this.initialRating = 0,
    this.onRatingChanged,
  });

  final double width;
  final int totalStars;
  final int initialRating;
  final ValueChanged<int>? onRatingChanged;

  static const String _backgroundAsset =
      'assets/background/backgroundwidgetcreate.png';
  static const double _backgroundAspectRatio = 696 / 389;
  static const double _catAspectRatio = 341.539 / 395.805;
  static const double _leafAspectRatio = 124 / 310;
  static const double _starWidthFactor = 0.105;
  static const double _starTopFactor = 0.320;
  static const double _starCenterXFactor = 0.570;
  static const double _newBadgeWidthFactor = 0.140;
  static const double _newBadgeCenterXFactor = 0.400;
  static const double _newBadgeTopFactor = 0.100;
  static const double _catWidthFactor = 0.165;
  static const double _catRightFactor = 0.050;
  static const double _catTopFactor = 0.400;
  static const double _leafWidthFactor = 0.050;
  static const double _leafLeftFactor = 0.185;
  static const double _leafBottomFactor = 0.290;

  @override
  State<CreateParentAccountWidget> createState() =>
      _CreateParentAccountWidgetState();
}

class _CreateParentAccountWidgetState extends State<CreateParentAccountWidget> {
  static const List<String> _svgAssets = [
    'assets/icons/toga.svg',
    'assets/icons/blok square.svg',
    'assets/icons/balok 123.svg',
    'assets/icons/shield.svg',
    'assets/icons/sparkle.svg',
    'assets/icons/tangkai.svg',
    'assets/icons/cat_parts/cat_body.svg',
    'assets/icons/cat_parts/cat_head_base.svg',
    'assets/icons/cat_parts/group_8673_v2.svg',
    'assets/icons/cat_parts/group_8672_v2.svg',
    'assets/icons/cat_parts/group_8671_v2.svg',
  ];

  bool _assetsReady = false;
  bool _startedPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startedPrecache) {
      return;
    }
    _startedPrecache = true;
    _precacheAssets();
  }

  Future<void> _precacheAssets() async {
    try {
      await precacheImage(
        const AssetImage(CreateParentAccountWidget._backgroundAsset),
        context,
      );
      await Future.wait(
        _svgAssets.map((asset) => SvgAssetLoader(asset).loadBytes(context)),
      );
    } catch (_) {
      // If one preload fails, keep the widget usable instead of blocking it.
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _assetsReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final height = width / CreateParentAccountWidget._backgroundAspectRatio;
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

    final starCenterXFactor = isLandscape
        ? 0.590
        : CreateParentAccountWidget._starCenterXFactor;
    final starTopFactor = isLandscape
        ? 0.335
        : CreateParentAccountWidget._starTopFactor;
    final starWidth = width * CreateParentAccountWidget._starWidthFactor;
    final starLeft = (width * starCenterXFactor) - (starWidth / 2);
    final starTop = height * starTopFactor;
    final newBadgeWidthFactor = isLandscape
        ? 0.125
        : CreateParentAccountWidget._newBadgeWidthFactor;
    final newBadgeCenterXFactor = isLandscape
        ? 0.420
        : CreateParentAccountWidget._newBadgeCenterXFactor;
    final newBadgeTopFactor = isLandscape
        ? 0.105
        : CreateParentAccountWidget._newBadgeTopFactor;
    final newBadgeWidth = width * newBadgeWidthFactor;
    final newBadgeLeft = (width * newBadgeCenterXFactor) - (newBadgeWidth / 2);
    final newBadgeTop = height * newBadgeTopFactor;
    final catWidthFactor = isLandscape
        ? 0.145
        : CreateParentAccountWidget._catWidthFactor;
    final catRightFactor = isLandscape
        ? 0.080
        : CreateParentAccountWidget._catRightFactor;
    final catTopFactor = isLandscape
        ? 0.425
        : CreateParentAccountWidget._catTopFactor;
    final catWidth = width * catWidthFactor;
    final catHeight = catWidth / CreateParentAccountWidget._catAspectRatio;
    final leafWidthFactor = isLandscape
        ? 0.045
        : CreateParentAccountWidget._leafWidthFactor;
    final leafLeftFactor = isLandscape
        ? 0.205
        : CreateParentAccountWidget._leafLeftFactor;
    final leafBottomFactor = isLandscape
        ? 0.300
        : CreateParentAccountWidget._leafBottomFactor;
    final leafWidth = width * leafWidthFactor;
    final leafHeight = leafWidth / CreateParentAccountWidget._leafAspectRatio;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                CreateParentAccountWidget._backgroundAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          FloatingObjectWidget(width: width, height: height),
          SparkleFieldWidget(width: width, height: height),
          Positioned(
            left: newBadgeLeft,
            top: newBadgeTop,
            child: NewBadgeWidget(width: newBadgeWidth),
          ),
          Positioned(
            left: starLeft,
            top: starTop,
            child: StarRatingWidget(
              width: starWidth,
              totalStars: widget.totalStars,
              initialRating: widget.initialRating,
              onRatingChanged: widget.onRatingChanged,
            ),
          ),
          Positioned(
            right: width * catRightFactor,
            top: height * catTopFactor,
            child: AnimatedCatWidget(width: catWidth, height: catHeight),
          ),
          Positioned(
            left: width * leafLeftFactor,
            bottom: height * leafBottomFactor,
            child: LeafWidget(width: leafWidth, height: leafHeight),
          ),
        ],
      ),
    );
  }
}
