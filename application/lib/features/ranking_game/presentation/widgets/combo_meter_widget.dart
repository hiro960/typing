import 'package:flutter/material.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';

/// コンボメーターウィジェット
class ComboMeterWidget extends StatelessWidget {
  const ComboMeterWidget({
    super.key,
    required this.state,
    this.height = 24.0,
  });

  final ComboMeterState state;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // メーターバー
        Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              // プログレスバー
              FractionallySizedBox(
                widthFactor: _calculateTotalProgress(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientColors(),
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ),
              // マイルストーンマーカー
              ..._buildMilestoneMarkers(context),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // キー数表示
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.currentKeys} / ${ComboMeterState.milestones.last} keys',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            if (state.totalBonusTime > 0)
              Text(
                '+${state.totalBonusTime}秒',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }

  double _calculateTotalProgress() {
    final totalKeys = ComboMeterState.milestones.last;
    return state.currentKeys / totalKeys;
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

  List<Widget> _buildMilestoneMarkers(BuildContext context) {
    final markers = <Widget>[];
    final totalKeys = ComboMeterState.milestones.last;

    for (int i = 0; i < ComboMeterState.milestones.length; i++) {
      final milestone = ComboMeterState.milestones[i];
      final position = milestone / totalKeys;
      final isReached = state.currentKeys >= milestone;
      final bonusText = '+${ComboMeterState.bonusSeconds[i]}秒';

      markers.add(
        Positioned(
          left: 0,
          right: 0,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: position,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // マイルストーンライン
                  Container(
                    width: 2,
                    height: height,
                    color: isReached
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.withOpacity(0.5),
                  ),
                ],
              ),
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
