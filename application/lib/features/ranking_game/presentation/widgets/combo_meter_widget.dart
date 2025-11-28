import 'package:flutter/material.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';

/// コンボメーターウィジェット
class ComboMeterWidget extends StatelessWidget {
  const ComboMeterWidget({
    super.key,
    required this.state,
    this.barHeight = 16.0,
  });

  final ComboMeterState state;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // キー数表示（上部）
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bolt,
                    size: 16,
                    color: Color(0xFFFFD700),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${state.currentKeys}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ' / ${ComboMeterState.milestones.last} keys',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              if (state.totalBonusTime > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '+${state.totalBonusTime}秒',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // メーターバー + マイルストーンラベル
        SizedBox(
          height: barHeight + 28,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // バー背景
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(barHeight / 2),
                        border: Border.all(
                          color: const Color(0xFF3D3D3D),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // プログレスバー
                  Positioned(
                    top: 0,
                    left: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      width: totalWidth * _calculateTotalProgress(),
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getGradientColors(),
                        ),
                        borderRadius: BorderRadius.circular(barHeight / 2),
                        boxShadow: [
                          BoxShadow(
                            color: _getGradientColors().first.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // マイルストーンマーカーとラベル
                  ..._buildMilestoneMarkersWithLabels(totalWidth),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  double _calculateTotalProgress() {
    final totalKeys = ComboMeterState.milestones.last;
    return (state.currentKeys / totalKeys).clamp(0.0, 1.0);
  }

  List<Color> _getGradientColors() {
    switch (state.currentMilestone) {
      case 0:
        return [const Color(0xFF4CAF50), const Color(0xFF81C784)];
      case 1:
        return [const Color(0xFFFFEB3B), const Color(0xFFFFF176)];
      case 2:
        return [const Color(0xFFFF9800), const Color(0xFFFFB74D)];
      case 3:
        return [const Color(0xFFE91E63), const Color(0xFFF48FB1)];
      default:
        return [const Color(0xFF9C27B0), const Color(0xFFCE93D8)];
    }
  }

  List<Widget> _buildMilestoneMarkersWithLabels(double totalWidth) {
    final markers = <Widget>[];
    final totalKeys = ComboMeterState.milestones.last;

    for (int i = 0; i < ComboMeterState.milestones.length; i++) {
      final milestone = ComboMeterState.milestones[i];
      final position = milestone / totalKeys;
      final isReached = state.currentKeys >= milestone;
      final bonusSeconds = ComboMeterState.bonusSeconds[i];
      final xPos = totalWidth * position;

      // マイルストーンマーカー（縦線 + ラベル）
      markers.add(
        Positioned(
          left: xPos,
          top: 0,
          child: FractionalTranslation(
            translation: const Offset(-0.5, 0),
            child: Column(
              children: [
                // 縦線
                Container(
                  width: 2,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: isReached ? Colors.white : Colors.grey[600],
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: isReached
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 2),
                // ボーナスラベル
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: isReached
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isReached
                          ? const Color(0xFF4CAF50)
                          : Colors.grey[700]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '+$bonusSeconds秒',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isReached ? Colors.white : Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }
}

/// ボーナス時間ポップアップ
class BonusTimePopup extends StatefulWidget {
  const BonusTimePopup({
    super.key,
    required this.bonusSeconds,
    required this.onComplete,
  });

  final int bonusSeconds;
  final VoidCallback onComplete;

  @override
  State<BonusTimePopup> createState() => _BonusTimePopupState();
}

class _BonusTimePopupState extends State<BonusTimePopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                '+${widget.bonusSeconds}秒',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
