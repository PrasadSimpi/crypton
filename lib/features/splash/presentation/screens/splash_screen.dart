import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/accent_bloom.dart';
import '../../../../shared/widgets/crypton_mark.dart';
import '../../../../shared/widgets/fade_up.dart';
import '../widgets/grid_backdrop.dart';
import '../widgets/splash_progress.dart';

/// The animated opener: the mark strokes itself on, the wordmark tightens from
/// 17px tracking to 6, and the app moves to sign-in.
///
/// One [AnimationController] drives every stage through [Interval]s - the same
/// structure as the CSS keyframe percentages in the reference, so the timeline
/// can be retimed by changing [duration] alone.
///
/// Honours the platform's reduce-motion setting by jumping to the end state and
/// holding for a beat instead of animating.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 3000),
    this.tagline = 'Markets in your pocket.',
    this.caption = 'SECURING SESSION',
  });

  /// Total length of the intro. Every stage scales with it.
  final Duration duration;

  final String tagline;
  final String caption;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _hex = _stage(0.20, 1.40, Curves.easeInOutCubic);
  late final Animation<double> _line = _stage(1.00, 1.80, Curves.easeInOutCubic);
  late final Animation<double> _glow = _stage(1.10, 2.30, Curves.easeOutCubic);
  late final Animation<double> _dot = _stage(1.70, 2.05, Curves.easeOutBack);
  late final Animation<double> _word = _stage(1.90, 2.50, Curves.easeOutCubic);
  late final Animation<double> _tag = _stage(2.30, 2.90, Curves.easeOutCubic);
  late final Animation<double> _bar = _stage(0.20, 3.00, Curves.easeInOut);

  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onStatus)
      ..dispose();
    super.dispose();
  }

  /// Maps real seconds onto a 0..1 interval of the controller.
  Animation<double> _stage(double fromSeconds, double toSeconds, Curve curve) {
    final total = widget.duration.inMilliseconds / 1000;
    final begin = (fromSeconds / total).clamp(0.0, 1.0);
    final rawEnd = (toSeconds / total).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, rawEnd <= begin ? 1.0 : rawEnd, curve: curve),
    );
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _finish();
  }

  void _start() {
    if (!mounted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      Future<void>.delayed(const Duration(milliseconds: 900), _finish);
      return;
    }
    _controller.forward();
  }

  void _finish() {
    if (_finished || !mounted) return;
    _finished = true;
    context.go(AppRoutes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: GridBackdrop()),
          const Positioned(
            left: -90,
            bottom: -160,
            child: AccentBloom(diameter: 420),
          ),
          // Only this subtree rebuilds each frame; the backdrop above is const.
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) => _SplashStage(
                hex: _hex.value,
                line: _line.value,
                glow: _glow.value,
                dot: _dot.value,
                word: _word.value,
                tag: _tag.value,
                bar: _bar.value,
                tagline: widget.tagline,
                caption: widget.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The animating content, split out so [AnimatedBuilder] rebuilds one subtree
/// rather than the whole screen.
class _SplashStage extends StatelessWidget {
  const _SplashStage({
    required this.hex,
    required this.line,
    required this.glow,
    required this.dot,
    required this.word,
    required this.tag,
    required this.bar,
    required this.tagline,
    required this.caption,
  });

  final double hex;
  final double line;
  final double glow;
  final double dot;
  final double word;
  final double tag;
  final double bar;
  final String tagline;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final glowValue = glow.clamp(0.0, 1.0);
    final wordValue = word.clamp(0.0, 1.0);
    // 17px tracking at rest, tightening to 6 as the wordmark settles.
    final tracking = 6 + 11 * (1 - wordValue);

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox.square(
                  dimension: 176,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: glowValue,
                        child: Transform.scale(
                          scale: 0.72 + 0.28 * glowValue,
                          child: const AccentBloom(
                            diameter: 176,
                            opacity: 0.26,
                            edge: 0.70,
                          ),
                        ),
                      ),
                      CryptonMark(
                        size: 132,
                        hexProgress: hex,
                        lineProgress: line,
                        dotProgress: dot,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                FadeUp(
                  t: wordValue,
                  child: Padding(
                    // letterSpacing also trails the final glyph, so nudging by
                    // the full value keeps the word optically centred.
                    padding: EdgeInsets.only(left: tracking),
                    child: Text(
                      'CRYPTON',
                      style: AppTextStyles.wordmark.copyWith(
                        letterSpacing: tracking,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FadeUp(
                  t: tag,
                  offsetY: 8,
                  child: Text(
                    tagline,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 74,
            child: SplashProgress(progress: bar, caption: caption),
          ),
        ],
      ),
    );
  }
}
