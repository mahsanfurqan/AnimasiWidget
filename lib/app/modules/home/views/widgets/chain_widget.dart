import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChainWidget extends StatefulWidget {
  const ChainWidget({super.key, required this.width});

  final double width;

  static const String _asset = 'assets/icons/chain.svg';

  @override
  State<ChainWidget> createState() => _ChainWidgetState();
}

class _ChainWidgetState extends State<ChainWidget>
    with SingleTickerProviderStateMixin {
  static const Color _parentBase = Color(0xFFEE9CA0);
  static const Color _childBase = Color(0xFFC1B6E1);
  static const Color _sharedHighlight = Color(0xFFF4E4F2);
  static const String _outlineRgb = 'rgb(105,54,78)';

  late final AnimationController _flowCtrl;
  String? _svgTemplate;
  bool _startedLoad = false;

  @override
  void initState() {
    super.initState();
    _flowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startedLoad) {
      return;
    }
    _startedLoad = true;
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    final svg = await rootBundle.loadString(ChainWidget._asset);
    if (!mounted) {
      return;
    }
    setState(() {
      _svgTemplate = svg;
    });
  }

  @override
  void dispose() {
    _flowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_svgTemplate == null) {
      return SizedBox.square(dimension: widget.width);
    }

    return SizedBox.square(
      dimension: widget.width,
      child: AnimatedBuilder(
        animation: _flowCtrl,
        builder: (context, _) {
          final parentProgress = _flowStrength(0.00);
          final childProgress = _flowStrength(0.26);

          final parentBlend = Color.lerp(_parentBase, _childBase, parentProgress)!;
          final childBlend = Color.lerp(_childBase, _parentBase, childProgress)!;

          final parentColor =
              Color.lerp(parentBlend, _sharedHighlight, parentProgress * 0.22)!;
          final childColor =
              Color.lerp(childBlend, _sharedHighlight, childProgress * 0.22)!;

          final animatedSvg = _applyFill(
            _applyFill(_svgTemplate!, 'chain-parent', parentColor),
            'chain-child',
            childColor,
          );

          return SvgPicture.string(
            animatedSvg,
            width: widget.width,
            height: widget.width,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  double _flowStrength(double shift) {
    final t = (_flowCtrl.value + shift) % 1.0;

    if (t < 0.28) {
      return 0.0;
    }
    if (t < 0.48) {
      return Curves.easeInOut.transform((t - 0.28) / 0.20);
    }
    if (t < 0.74) {
      return 1.0;
    }
    if (t < 0.94) {
      return 1.0 - Curves.easeInOut.transform((t - 0.74) / 0.20);
    }
    return 0.0;
  }

  String _applyFill(String svg, String id, Color color) {
    final fill =
        'fill:${_svgRgb(color)};stroke:$_outlineRgb;stroke-width:8px;'
        'stroke-linejoin:round;stroke-linecap:round;fill-opacity:1;';
    final pattern = RegExp('(<path id="$id"[^>]*style=")[^"]*(")');
    return svg.replaceFirstMapped(pattern, (match) {
      return '${match.group(1)}$fill${match.group(2)}';
    });
  }

  String _svgRgb(Color color) {
    final red = (color.r * 255.0).round().clamp(0, 255);
    final green = (color.g * 255.0).round().clamp(0, 255);
    final blue = (color.b * 255.0).round().clamp(0, 255);
    return 'rgb($red,$green,$blue)';
  }
}
