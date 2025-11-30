import 'package:flutter/material.dart';

/// Shimmer効果を提供する基本コンテナ
/// 子ウィジェット全体にシマー効果を適用する
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base =
        widget.baseColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.06);
    final highlight =
        widget.highlightColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.12);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, highlight, base],
              stops: [
                0.0,
                (0.5 + _animation.value * 0.25).clamp(0.0, 1.0),
                1.0,
              ],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

/// 角丸ブロック型のスケルトンプレースホルダー
class ShimmerBlock extends StatelessWidget {
  const ShimmerBlock({
    super.key,
    this.width,
    this.height = 14,
    this.widthFactor,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double? widthFactor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);

    Widget block = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    if (widthFactor != null) {
      block = FractionallySizedBox(
        widthFactor: widthFactor,
        child: block,
      );
    }

    return block;
  }
}

/// 円形のスケルトンプレースホルダー（アバター用）
class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({
    super.key,
    this.size = 40,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: baseColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// テキスト行のスケルトンプレースホルダー
class ShimmerTextLine extends StatelessWidget {
  const ShimmerTextLine({
    super.key,
    this.widthFactor = 1.0,
    this.height = 14,
  });

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerBlock(
      widthFactor: widthFactor,
      height: height,
    );
  }
}

/// 複数行のテキストスケルトン
class ShimmerTextLines extends StatelessWidget {
  const ShimmerTextLines({
    super.key,
    this.lines = 3,
    this.lineHeight = 14,
    this.spacing = 8,
    this.lastLineWidthFactor = 0.6,
  });

  final int lines;
  final double lineHeight;
  final double spacing;
  final double lastLineWidthFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: ShimmerBlock(
            widthFactor: isLast ? lastLineWidthFactor : 1.0,
            height: lineHeight,
          ),
        );
      }),
    );
  }
}

/// カード形状のスケルトンプレースホルダー
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 120,
    this.borderRadius = 12,
    this.margin,
  });

  final double height;
  final double borderRadius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);

    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// 統計値表示用のスケルトン（数値 + ラベル）
class ShimmerStatItem extends StatelessWidget {
  const ShimmerStatItem({
    super.key,
    this.valueHeight = 24,
    this.labelHeight = 12,
    this.spacing = 4,
  });

  final double valueHeight;
  final double labelHeight;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerBlock(width: 48, height: valueHeight),
        SizedBox(height: spacing),
        ShimmerBlock(width: 36, height: labelHeight),
      ],
    );
  }
}
