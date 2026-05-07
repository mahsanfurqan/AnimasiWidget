import 'package:flutter/material.dart';

class LinkAccountWidget extends StatefulWidget {
  const LinkAccountWidget({super.key, this.width = 360});

  final double width;

  static const String _backgroundAsset = 'assets/background/backgroundlink.png';
  static const double _backgroundAspectRatio = 1661 / 929;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          LinkAccountWidget._backgroundAsset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
