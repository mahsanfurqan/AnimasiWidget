import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedCatWidget extends StatefulWidget {
  const AnimatedCatWidget({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<AnimatedCatWidget> createState() => _AnimatedCatWidgetState();
}

class _AnimatedCatWidgetState extends State<AnimatedCatWidget>
    with TickerProviderStateMixin {
  static const String _catBodyAsset = 'assets/icons/cat_parts/cat_body.svg';
  static const String _catHeadBaseAsset =
      'assets/icons/cat_parts/cat_head_base.svg';
  static const String _catTailAsset =
      'assets/icons/cat_parts/group_8673_v2.svg';
  static const String _catRightEarAsset =
      'assets/icons/cat_parts/group_8672_v2.svg';
  static const String _catLeftEarAsset =
      'assets/icons/cat_parts/group_8671_v2.svg';

  late final AnimationController _catCtrl;
  late final AnimationController _tapCtrl;

  @override
  void initState() {
    super.initState();
    _catCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    );
  }

  @override
  void dispose() {
    _catCtrl.dispose();
    _tapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _tapCtrl.forward(from: 0);
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: Listenable.merge([_catCtrl, _tapCtrl]),
          builder: (context, _) {
            final tapTailKick = _tailTapKick(_tapCtrl.value);
            final tapEarKick = _earTapKick(_tapCtrl.value);
            final headTilt = _headTapTilt(_tapCtrl.value);
            final tailRotation = _tailRotation(_catCtrl.value) + tapTailKick;
            final leftEarRotation =
                _earRotation(_catCtrl.value, 0.08) - tapEarKick;
            final rightEarRotation =
                _earRotation(_catCtrl.value, 0.53) + tapEarKick;

            return Stack(
              children: [
                Transform.rotate(
                  angle: tailRotation,
                  alignment: const Alignment(0.72, 0.68),
                  child: SvgPicture.asset(
                    _catTailAsset,
                    width: widget.width,
                    height: widget.height,
                    fit: BoxFit.contain,
                  ),
                ),
                SvgPicture.asset(
                  _catBodyAsset,
                  width: widget.width,
                  height: widget.height,
                  fit: BoxFit.contain,
                ),
                Transform.rotate(
                  angle: headTilt,
                  alignment: const Alignment(-0.06, -0.44),
                  child: Stack(
                    children: [
                      Transform.rotate(
                        angle: rightEarRotation,
                        alignment: const Alignment(0.63, -0.92),
                        child: SvgPicture.asset(
                          _catRightEarAsset,
                          width: widget.width,
                          height: widget.height,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Transform.rotate(
                        angle: leftEarRotation,
                        alignment: const Alignment(-0.63, -0.92),
                        child: SvgPicture.asset(
                          _catLeftEarAsset,
                          width: widget.width,
                          height: widget.height,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SvgPicture.asset(
                        _catHeadBaseAsset,
                        width: widget.width,
                        height: widget.height,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _tailRotation(double progress) {
    final phase = progress * math.pi * 2;
    return math.sin(phase) * 0.22;
  }

  double _earRotation(double progress, double shift) {
    final phase = (progress + shift) % 1.0;
    if (phase < 0.52 || phase > 0.94) {
      return 0;
    }

    final local = (phase - 0.52) / 0.42;
    return math.sin(local * math.pi * 6) * 0.08 * (1 - (local * 0.75));
  }

  double _tailTapKick(double progress) {
    final phase = progress * math.pi * 3.4;
    return math.sin(phase) * 0.18 * (1 - progress);
  }

  double _earTapKick(double progress) {
    final phase = progress * math.pi * 2.8;
    return math.sin(phase) * 0.065 * (1 - (progress * 0.55));
  }

  double _headTapTilt(double progress) {
    final phase = progress * math.pi * 2.1;
    return math.sin(phase) * 0.08 * (1 - (progress * 0.4));
  }
}
