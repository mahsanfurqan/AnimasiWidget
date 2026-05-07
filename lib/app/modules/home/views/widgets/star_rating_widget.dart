import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({
    super.key,
    this.totalStars = 5,
    this.initialRating = 0,
    this.width = 280,
    this.onRatingChanged,
  });

  final int totalStars;
  final int initialRating;
  final double width;
  final ValueChanged<int>? onRatingChanged;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget>
    with TickerProviderStateMixin {
  static const double _widthToHeightRatio = 188.0 / 42.0;
  static const Color _pillFill = Color(0xFFFDF8FC);
  static const Color _pillBorder = Color(0xFF8A667D);
  static const Color _outlineStarColor = Color(0xFFD8C2D2);
  static const Color _filledStarColor = Color(0xFFCF8B78);

  late int _currentRating;
  late final AnimationController _containerEntryCtrl;
  late final Animation<double> _containerFade;
  late final Animation<double> _containerScale;
  late final Animation<Offset> _containerSlide;
  late final List<AnimationController> _bounceCtrl;
  late final List<Animation<double>> _bounceAnim;
  late final List<AnimationController> _entryCtrl;
  late final List<Animation<double>> _entryAnim;
  int _sequenceToken = 0;

  double get _widgetHeight => widget.width / _widthToHeightRatio;

  double get _horizontalPadding => _widgetHeight * 0.28;

  double get _starSize {
    final availableWidth = widget.width - (_horizontalPadding * 2);
    final slotWidth = availableWidth / widget.totalStars;
    final desiredSize = _widgetHeight * 0.76;
    return desiredSize.clamp(0.0, slotWidth * 0.94);
  }

  @override
  void initState() {
    super.initState();
    _currentRating = 0;

    _containerEntryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _containerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _containerEntryCtrl, curve: Curves.easeOut),
    );
    _containerScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _containerEntryCtrl, curve: Curves.easeOutBack),
    );
    _containerSlide =
        Tween<Offset>(begin: const Offset(0, -0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _containerEntryCtrl,
            curve: Curves.easeOutCubic,
          ),
        );

    _bounceCtrl = List.generate(
      widget.totalStars,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      ),
    );
    _bounceAnim = _bounceCtrl.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 35),
        TweenSequenceItem(tween: Tween(begin: 1.45, end: 0.88), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.0), weight: 35),
      ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    _entryCtrl = List.generate(
      widget.totalStars,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _entryAnim = _entryCtrl.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _containerEntryCtrl.forward();
    _startLoopingRatingSequence();
  }

  @override
  void didUpdateWidget(covariant StarRatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating ||
        oldWidget.totalStars != widget.totalStars) {
      _sequenceToken++;
      _currentRating = 0;
      _startLoopingRatingSequence();
    }
  }

  @override
  void dispose() {
    _sequenceToken++;
    _containerEntryCtrl.dispose();
    for (final controller in _bounceCtrl) {
      controller.dispose();
    }
    for (final controller in _entryCtrl) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _startLoopingRatingSequence() async {
    final token = ++_sequenceToken;

    await Future<void>.delayed(const Duration(milliseconds: 500));

    while (mounted && token == _sequenceToken) {
      for (int i = 0; i < widget.totalStars; i++) {
        if (!mounted || token != _sequenceToken) {
          return;
        }

        setState(() {
          _currentRating = i + 1;
        });
        _entryCtrl[i].forward(from: 0.0);
        _bounceCtrl[i].forward(from: 0.0);

        await Future<void>.delayed(const Duration(milliseconds: 340));
      }

      if (!mounted || token != _sequenceToken) {
        return;
      }

      widget.onRatingChanged?.call(_currentRating);
      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted || token != _sequenceToken) {
        return;
      }

      setState(() {
        _currentRating = 0;
      });

      await Future<void>.delayed(const Duration(milliseconds: 380));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _containerFade,
      child: SlideTransition(
        position: _containerSlide,
        child: ScaleTransition(
          scale: _containerScale,
          child: Container(
            width: widget.width,
            height: _widgetHeight,
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            decoration: BoxDecoration(
              color: _pillFill,
              borderRadius: BorderRadius.circular(_widgetHeight / 2),
              border: Border.all(
                color: _pillBorder,
                width: _widgetHeight * 0.06,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.totalStars, (index) {
                final isFilled = index < _currentRating;

                return SizedBox(
                  width: _starSize,
                  height: _starSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: _starSize,
                        color: _outlineStarColor,
                      ),
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _bounceCtrl[index],
                          _entryCtrl[index],
                        ]),
                        builder: (context, child) {
                          final entryScale = _entryAnim[index].value;
                          final bounceScale = isFilled
                              ? _bounceAnim[index].value
                              : 1.0;

                          return Transform.scale(
                            scale: entryScale * bounceScale,
                            child: AnimatedOpacity(
                              opacity: isFilled ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.star_rounded,
                          size: _starSize,
                          color: _filledStarColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
