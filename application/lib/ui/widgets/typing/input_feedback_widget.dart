import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 正解時のパルスアニメーション
class PulseFeedback extends StatelessWidget {
  const PulseFeedback({
    super.key,
    required this.label,
    this.icon = Icons.check_circle,
    this.iconColor = Colors.green,
    this.iconSize = 20,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0.8, end: 1),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

/// 不正解時の横揺れアニメーション
class ShakeFeedback extends StatelessWidget {
  const ShakeFeedback({
    super.key,
    required this.label,
    this.icon = Icons.close_rounded,
    this.iconColor = Colors.red,
    this.iconSize = 20,
    this.intensity = 6.0,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 420),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        final offset = math.sin(value * math.pi * 5) * intensity;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

/// 汎用の横揺れコンテナ（子ウィジェットを揺らす）
class ShakeContainer extends StatelessWidget {
  const ShakeContainer({
    super.key,
    required this.shouldShake,
    required this.child,
    this.intensity = 8.0,
    this.duration = const Duration(milliseconds: 420),
  });

  final bool shouldShake;
  final Widget child;
  final double intensity;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (!shouldShake) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        final offset = math.sin(value * math.pi * 5) * intensity;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
