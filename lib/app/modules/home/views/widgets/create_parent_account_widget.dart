import 'package:flutter/material.dart';

import 'animated_cat_widget.dart';
import 'floating_object_widget.dart';
import 'leaf_widget.dart';
import 'new_badge_widget.dart';
import 'sparkle_field_widget.dart';
import 'star_rating_widget.dart';

class CreateParentAccountWidget extends StatelessWidget {
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
  static const double _starTopFactor = 0.330;
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
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final height = width / _backgroundAspectRatio;
    final starCenterXFactor = isLandscape ? 0.590 : _starCenterXFactor;
    final starTopFactor = isLandscape ? 0.335 : _starTopFactor;
    final starWidth = width * _starWidthFactor;
    final starLeft = (width * starCenterXFactor) - (starWidth / 2);
    final starTop = height * starTopFactor;
    final newBadgeWidthFactor = isLandscape ? 0.125 : _newBadgeWidthFactor;
    final newBadgeCenterXFactor = isLandscape ? 0.420 : _newBadgeCenterXFactor;
    final newBadgeTopFactor = isLandscape ? 0.105 : _newBadgeTopFactor;
    final newBadgeWidth = width * newBadgeWidthFactor;
    final newBadgeLeft = (width * newBadgeCenterXFactor) - (newBadgeWidth / 2);
    final newBadgeTop = height * newBadgeTopFactor;
    final catWidthFactor = isLandscape ? 0.145 : _catWidthFactor;
    final catRightFactor = isLandscape ? 0.080 : _catRightFactor;
    final catTopFactor = isLandscape ? 0.425 : _catTopFactor;
    final catWidth = width * catWidthFactor;
    final catHeight = catWidth / _catAspectRatio;
    final leafWidthFactor = isLandscape ? 0.045 : _leafWidthFactor;
    final leafLeftFactor = isLandscape ? 0.205 : _leafLeftFactor;
    final leafBottomFactor = isLandscape ? 0.300 : _leafBottomFactor;
    final leafWidth = width * leafWidthFactor;
    final leafHeight = leafWidth / _leafAspectRatio;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(_backgroundAsset, fit: BoxFit.cover),
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
              totalStars: totalStars,
              initialRating: initialRating,
              onRatingChanged: onRatingChanged,
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
