import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RopeLinkWidget extends StatefulWidget {
  const RopeLinkWidget({super.key, required this.width});

  final double width;

  static const String _asset = 'assets/icons/rope_link.svg';
  static const double _aspectRatio = 387 / 464;

  @override
  State<RopeLinkWidget> createState() => _RopeLinkWidgetState();
}

class _RopeLinkWidgetState extends State<RopeLinkWidget>
    with SingleTickerProviderStateMixin {
  static const Color _outlineColor = Color(0xFF6D3E69);
  static const Color _leftPink = Color(0xFFEE9CA0);
  static const Color _midViolet = Color(0xFF9A3DFF);
  static const Color _rightBlue = Color(0xFF4B63FF);
  static const Color _glowPink = Color(0xFFFFC4D0);
  static const Color _glowBlue = Color(0xFFC7D1FF);

  late final AnimationController _colorCtrl;
  String? _svgTemplate;
  bool _startedLoad = false;

  double get _height => widget.width / RopeLinkWidget._aspectRatio;

  @override
  void initState() {
    super.initState();
    _colorCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
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
    final svg = await rootBundle.loadString(RopeLinkWidget._asset);
    if (!mounted) {
      return;
    }
    setState(() {
      _svgTemplate = svg;
    });
  }

  @override
  void dispose() {
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_svgTemplate == null) {
      return SizedBox(width: widget.width, height: _height);
    }

    return SizedBox(
      width: widget.width,
      height: _height,
      child: AnimatedBuilder(
        animation: _colorCtrl,
        builder: (context, _) {
          final svg = _applyAnimatedGradient(_svgTemplate!, _colorCtrl.value);
          return SvgPicture.string(
            svg,
            width: widget.width,
            height: _height,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  String _applyAnimatedGradient(String svg, double t) {
    final flowT = 1 - t;
    final leftWave = Curves.easeInOut.transform(
      0.5 + (0.5 * math.sin(flowT * math.pi * 2)),
    );
    final rightWave = Curves.easeInOut.transform(
      0.5 + (0.5 * math.sin((flowT * math.pi * 2) + 1.2)),
    );
    final leftGlow = Color.lerp(_leftPink, _glowPink, leftWave * 0.55)!;
    final rightGlow = Color.lerp(_rightBlue, _glowBlue, rightWave * 0.55)!;
    final stops = <_GradientStop>[
      _GradientStop(0.00, _leftPink),
      _GradientStop(0.16, Color.lerp(_leftPink, _midViolet, 0.55)!),
      _GradientStop(0.34, _midViolet),
      _GradientStop(0.68, _midViolet),
      _GradientStop(0.84, Color.lerp(_midViolet, _rightBlue, 0.45)!),
      _GradientStop(1.00, _rightBlue),
      ..._flowBandStopsWrapped(
        center: flowT,
        width: 0.22,
        lead: leftGlow,
        core: _midViolet,
        tail: rightGlow,
      ),
      ..._flowBandStopsWrapped(
        center: (flowT + 0.34) % 1.0,
        width: 0.18,
        lead: Color.lerp(_leftPink, leftGlow, 0.55)!,
        core: _midViolet,
        tail: Color.lerp(_rightBlue, rightGlow, 0.7)!,
      ),
      ..._flowBandStopsWrapped(
        center: (flowT + 0.68) % 1.0,
        width: 0.16,
        lead: leftGlow,
        core: _midViolet,
        tail: rightGlow,
      ),
    ]..sort((a, b) => a.offset.compareTo(b.offset));
    final stopMarkup = stops
        .map(
          (stop) =>
              '    <stop offset="${_svgPercent(stop.offset)}" stop-color="${_svgRgb(stop.color)}"/>',
        )
        .join('\n');
    final defs = '''
<defs>
  <linearGradient id="ropeGradient" x1="0%" y1="0%" x2="100%" y2="0%">
$stopMarkup
  </linearGradient>
</defs>''';
    final withDefs = svg.replaceFirst('</svg>', '$defs</svg>');
    final style =
        'fill:url(#ropeGradient);stroke:${_svgRgb(_outlineColor)};'
        'stroke-width:8px;stroke-linejoin:round;stroke-linecap:round;';
    return withDefs.replaceFirstMapped(RegExp(r'<path\b([^>]*)/>'), (match) {
      return '<path${match.group(1)} style="$style"/>';
    });
  }

  String _svgRgb(Color color) {
    final red = (color.r * 255).round().clamp(0, 255);
    final green = (color.g * 255).round().clamp(0, 255);
    final blue = (color.b * 255).round().clamp(0, 255);
    return 'rgb($red,$green,$blue)';
  }

  String _svgPercent(double value) => '${(value * 100).toStringAsFixed(2)}%';

  List<_GradientStop> _flowBandStopsWrapped({
    required double center,
    required double width,
    required Color lead,
    required Color core,
    required Color tail,
  }) {
    final normalizedCenter = center % 1.0;
    final half = width / 2;
    final start = normalizedCenter - half;
    final innerStart = normalizedCenter - (width * 0.18);
    final innerEnd = normalizedCenter + (width * 0.18);
    final end = normalizedCenter + half;
    return _wrappedStops([
      _GradientStop(start, Color.lerp(core, lead, 0.55)!),
      _GradientStop(innerStart, lead),
      _GradientStop(normalizedCenter, core),
      _GradientStop(innerEnd, tail),
      _GradientStop(end, Color.lerp(tail, core, 0.55)!),
    ]);
  }

  List<_GradientStop> _wrappedStops(List<_GradientStop> stops) {
    final wrapped = <_GradientStop>[];
    for (final stop in stops) {
      if (stop.offset < 0) {
        wrapped.add(_GradientStop(stop.offset + 1, stop.color));
      } else if (stop.offset > 1) {
        wrapped.add(_GradientStop(stop.offset - 1, stop.color));
      } else {
        wrapped.add(stop);
      }
    }
    return wrapped;
  }
}

class _GradientStop {
  const _GradientStop(this.offset, this.color);

  final double offset;
  final Color color;
}
