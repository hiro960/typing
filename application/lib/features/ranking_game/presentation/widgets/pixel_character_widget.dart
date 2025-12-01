import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/pixel_characters.dart';

/// ドット絵キャラクターを描画するCustomPainter
class PixelCharacterPainter extends CustomPainter {
  final List<List<int>> pixelData;
  final double pixelSize;
  final int animationFrame;
  final bool isEgg;

  PixelCharacterPainter({
    required this.pixelData,
    this.pixelSize = 3.0,
    this.animationFrame = 0,
    this.isEgg = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // アニメーションオフセット
    // たまご: 左右に揺れる、その他: 上下にバウンス
    final double offsetX = isEgg ? (animationFrame == 1 ? 2.0 : 0.0) : 0.0;
    final double offsetY = isEgg ? 0.0 : (animationFrame == 1 ? -3.0 : 0.0);

    for (int y = 0; y < pixelData.length; y++) {
      for (int x = 0; x < pixelData[y].length; x++) {
        final color = pixelData[y][x];
        if (color != 0x00000000) {
          paint.color = Color(color);
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize + offsetX,
              y * pixelSize + offsetY,
              pixelSize,
              pixelSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PixelCharacterPainter oldDelegate) {
    return oldDelegate.pixelData != pixelData ||
        oldDelegate.animationFrame != animationFrame ||
        oldDelegate.isEgg != isEgg;
  }
}

/// キャラクター表示ウィジェット
class PixelCharacterWidget extends StatefulWidget {
  /// 進化レベル（0-5）
  final int evolutionLevel;

  /// アニメーションを有効にするか
  final bool isAnimating;

  /// ピクセルサイズ（デフォルト: 3.0、32x32グリッド用）
  final double pixelSize;

  /// 進化時のエフェクトを表示するか
  final bool showEvolutionEffect;

  const PixelCharacterWidget({
    super.key,
    required this.evolutionLevel,
    this.isAnimating = true,
    this.pixelSize = 3.0,
    this.showEvolutionEffect = false,
  });

  @override
  State<PixelCharacterWidget> createState() => _PixelCharacterWidgetState();
}

class _PixelCharacterWidgetState extends State<PixelCharacterWidget>
    with SingleTickerProviderStateMixin {
  Timer? _animationTimer;
  int _frame = 0;

  // 進化エフェクト用
  late AnimationController _evolutionController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // 待機アニメーション
    if (widget.isAnimating) {
      final duration = widget.evolutionLevel == 0
          ? const Duration(milliseconds: 500) // たまごは遅め
          : const Duration(milliseconds: 350);

      _animationTimer = Timer.periodic(
        duration,
        (_) {
          if (mounted) {
            setState(() => _frame = (_frame + 1) % 2);
          }
        },
      );
    }

    // 進化エフェクト用アニメーション
    _evolutionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _evolutionController, curve: Curves.easeOut),
    );

    if (widget.showEvolutionEffect) {
      _evolutionController.forward();
    }
  }

  @override
  void didUpdateWidget(PixelCharacterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 進化レベルが変わった場合、エフェクトを再生
    if (oldWidget.evolutionLevel != widget.evolutionLevel &&
        widget.showEvolutionEffect) {
      _evolutionController.reset();
      _evolutionController.forward();
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _evolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pixelData = PixelCharacters.getCharacter(widget.evolutionLevel);
    final isEgg = widget.evolutionLevel == 0;

    // キャラクターのサイズ（32x32ピクセル）
    final characterSize = Size(
      PixelCharacters.pixelGridSize * widget.pixelSize,
      PixelCharacters.pixelGridSize * widget.pixelSize,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        // 進化エフェクト（光のオーバーレイ）
        if (widget.showEvolutionEffect)
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: characterSize.width + 30,
                height: characterSize.height + 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow
                          .withValues(alpha: (1.0 - _glowAnimation.value) * 0.6),
                      blurRadius: 30 * (1.0 - _glowAnimation.value),
                      spreadRadius: 15 * (1.0 - _glowAnimation.value),
                    ),
                  ],
                ),
              );
            },
          ),

        // キャラクター本体
        CustomPaint(
          size: characterSize,
          painter: PixelCharacterPainter(
            pixelData: pixelData,
            pixelSize: widget.pixelSize,
            animationFrame: widget.isAnimating ? _frame : 0,
            isEgg: isEgg,
          ),
        ),

        // キラキラエフェクト（進化時）
        if (widget.showEvolutionEffect)
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              if (_glowAnimation.value < 0.3) return const SizedBox.shrink();
              return _buildSparkles(_glowAnimation.value, characterSize);
            },
          ),
      ],
    );
  }

  Widget _buildSparkles(double progress, Size characterSize) {
    return SizedBox(
      width: characterSize.width + 50,
      height: characterSize.height + 50,
      child: Stack(
        children: [
          // 6つのキラキラ
          for (int i = 0; i < 6; i++)
            Positioned(
              left: _sparklePositions[i].dx * (characterSize.width + 50),
              top: _sparklePositions[i].dy * (characterSize.height + 50),
              child: Opacity(
                opacity: ((1.0 - progress) * 2).clamp(0.0, 1.0),
                child: Text(
                  i % 2 == 0 ? '✧' : '✦',
                  style: TextStyle(
                    color: i % 3 == 0 ? Colors.yellow : Colors.white,
                    fontSize: 14 + (i % 3) * 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static const List<Offset> _sparklePositions = [
    Offset(0.1, 0.15),
    Offset(0.85, 0.1),
    Offset(0.05, 0.5),
    Offset(0.9, 0.55),
    Offset(0.15, 0.85),
    Offset(0.8, 0.9),
  ];
}

/// スコアからキャラクターを表示するウィジェット
class ScoreBasedCharacterWidget extends StatefulWidget {
  /// 現在のスコア
  final int score;

  /// 難易度（'beginner', 'intermediate', 'advanced'）
  final String difficulty;

  /// アニメーションを有効にするか
  final bool isAnimating;

  /// ピクセルサイズ
  final double pixelSize;

  /// キャラクター名を表示するか
  final bool showName;

  const ScoreBasedCharacterWidget({
    super.key,
    required this.score,
    this.difficulty = 'beginner',
    this.isAnimating = true,
    this.pixelSize = 2.0,
    this.showName = true,
  });

  @override
  State<ScoreBasedCharacterWidget> createState() =>
      _ScoreBasedCharacterWidgetState();
}

class _ScoreBasedCharacterWidgetState extends State<ScoreBasedCharacterWidget> {
  int _previousLevel = 0;
  bool _showEvolutionEffect = false;

  @override
  void initState() {
    super.initState();
    _previousLevel = PixelCharacters.getEvolutionLevel(
      widget.score,
      difficulty: widget.difficulty,
    );
  }

  @override
  void didUpdateWidget(ScoreBasedCharacterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newLevel = PixelCharacters.getEvolutionLevel(
      widget.score,
      difficulty: widget.difficulty,
    );
    if (newLevel > _previousLevel) {
      // 進化した！
      setState(() {
        _showEvolutionEffect = true;
        _previousLevel = newLevel;
      });

      // エフェクト終了後にフラグをリセット
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() => _showEvolutionEffect = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = PixelCharacters.getEvolutionLevel(
      widget.score,
      difficulty: widget.difficulty,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PixelCharacterWidget(
          evolutionLevel: level,
          isAnimating: widget.isAnimating,
          pixelSize: widget.pixelSize,
          showEvolutionEffect: _showEvolutionEffect,
        ),
        if (widget.showName) ...[
          const SizedBox(height: 8),
          Text(
            PixelCharacters.getCharacterName(level),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
