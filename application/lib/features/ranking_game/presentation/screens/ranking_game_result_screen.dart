import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:chaletta/core/exceptions/app_exception.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_game_providers.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/ranking_leaderboard_screen.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/ranking_game_screen.dart';
import 'package:chaletta/ui/app_theme.dart';

/// ランキングゲーム結果画面
class RankingGameResultScreen extends ConsumerStatefulWidget {
  const RankingGameResultScreen({
    super.key,
    required this.difficulty,
    required this.score,
    required this.correctCount,
    required this.maxCombo,
    required this.totalBonusTime,
    required this.avgInputSpeed,
    required this.characterLevel,
  });

  final String difficulty;
  final int score;
  final int correctCount;
  final int maxCombo;
  final int totalBonusTime;
  final double avgInputSpeed;
  final int characterLevel;

  @override
  ConsumerState<RankingGameResultScreen> createState() =>
      _RankingGameResultScreenState();
}

class _RankingGameResultScreenState
    extends ConsumerState<RankingGameResultScreen> {
  bool _isSubmitting = false;
  String? _errorMessage;
  RankingGameResultResponse? _resultResponse;

  @override
  void initState() {
    super.initState();
    // ウィジェットツリー構築完了後にProviderを変更するため、addPostFrameCallbackを使用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitResult();
    });
  }

  Future<void> _submitResult() async {
    if (!mounted) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final response = await ref.read(gameResultSubmitterProvider.notifier).submitResult(
            difficulty: widget.difficulty,
            score: widget.score,
            correctCount: widget.correctCount,
            maxCombo: widget.maxCombo,
            totalBonusTime: widget.totalBonusTime,
            avgInputSpeed: widget.avgInputSpeed,
            characterLevel: widget.characterLevel,
          );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
        _resultResponse = response;
        // responseがnullの場合はオフライン保存されたことを示す
        if (response == null) {
          _errorMessage = 'オフラインで保存しました。次回接続時に送信されます。';
        }
      });
    } catch (e, stackTrace) {
      // オンラインエラー（サーバーエラー、認証エラーなど）
      developer.log(
        'ゲーム結果送信エラー',
        name: 'RankingGameResultScreen',
        error: e,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
        if (e is AppException) {
          _errorMessage = e.message;
        } else {
          _errorMessage = 'エラーが発生しました。時間をおいて再試行してください。';
        }
      });
    }
  }

  String _getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return '初級';
      case 'intermediate':
        return '中級';
      case 'advanced':
        return '高級';
      default:
        return difficulty;
    }
  }

  void _shareResult() {
    final diffLabel = _getDifficultyLabel(widget.difficulty);
    final rankText = _resultResponse != null
        ? '順位: ${_resultResponse!.ranking.position}位 / ${_resultResponse!.ranking.totalParticipants}人中'
        : '';
    final newBestText = _resultResponse?.ranking.isNewBest == true ? '🎉 自己ベスト更新!' : '';

    final shareText = '''
🎮 韓国語タイピングゲーム結果

📊 スコア: ${widget.score}点
🏆 $diffLabel モード
$rankText
$newBestText

✅ 正解数: ${widget.correctCount}問
🔥 最大コンボ: ${widget.maxCombo}
⏱️ ボーナス時間: +${widget.totalBonusTime}秒
⌨️ 入力速度: ${widget.avgInputSpeed.toStringAsFixed(1)}文字/分

#韓国語学習 #タイピングゲーム
''';

    Share.share(shareText.trim());
  }

  @override
  Widget build(BuildContext context) {
    // autoDisposeプロバイダーを維持するためにwatchする
    // これにより、画面がアクティブな間はプロバイダーが破棄されない
    ref.watch(gameResultSubmitterProvider);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ゲーム結果',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        actions: [
          // シェアボタン
          IconButton(
            icon: Icon(Icons.share, color: theme.colorScheme.onSurface),
            onPressed: _shareResult,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // ヒーローセクション（キャラクター + スコア + 難易度）
              _buildHeroSection(),
              const SizedBox(height: 16),

              // ランキング情報（コンパクト）
              if (_isSubmitting)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                    strokeWidth: 2,
                  ),
                )
              else if (_resultResponse != null)
                _buildCompactRankingInfo()
              else if (_errorMessage != null)
                _buildOfflineMessage(),

              const SizedBox(height: 16),

              // 詳細統計（コンパクト横並び）
              _buildCompactStatsRow(),
              const SizedBox(height: 24),

              // アクションボタン
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getDifficultyColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getDifficultyColor().withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // キャラクター（左側）
          ScoreBasedCharacterWidget(
            score: widget.score,
            showName: true,
            pixelSize: 2.5,
          ),
          const SizedBox(width: 16),
          // スコアと難易度（右側）
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 難易度バッジ
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getDifficultyLabel(widget.difficulty),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getDifficultyColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // スコア
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${widget.score}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'pt',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                // ベスト更新表示
                if (_resultResponse?.ranking.isNewBest == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.celebration, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '自己ベスト!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactRankingInfo() {
    final theme = Theme.of(context);
    final ranking = _resultResponse!.ranking;
    final positionChange = ranking.previousPosition != null
        ? ranking.previousPosition! - ranking.position
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // ランキングアイコンと順位
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // 順位情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '今月のランキング',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${ranking.position}位',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      ' / ${ranking.totalParticipants}人中',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 順位変動
          if (positionChange != null && positionChange != 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: positionChange > 0
                    ? AppColors.success.withOpacity(0.2)
                    : AppColors.error.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    positionChange > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: positionChange > 0 ? AppColors.success : AppColors.error,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${positionChange.abs()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: positionChange > 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCompactStatItem(
            icon: Icons.check_circle_outline,
            value: '${widget.correctCount}',
            label: '正解',
            color: AppColors.success,
          ),
        ),
        Expanded(
          child: _buildCompactStatItem(
            icon: Icons.local_fire_department,
            value: '${widget.maxCombo}',
            label: 'コンボ',
            color: AppColors.accentEnd,
          ),
        ),
        Expanded(
          child: _buildCompactStatItem(
            icon: Icons.timer_outlined,
            value: '+${widget.totalBonusTime}s',
            label: 'ボーナス',
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: _buildCompactStatItem(
            icon: Icons.speed,
            value: '${widget.avgInputSpeed.toStringAsFixed(0)}',
            label: '文字/分',
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    // _LevelAccordionsと同じ色合いを使用
    switch (widget.difficulty) {
      case 'beginner':
        return AppColors.primaryBright;
      case 'intermediate':
        return AppColors.secondary;
      case 'advanced':
        return AppColors.accentEnd;
      default:
        return AppColors.mutedForeground;
    }
  }

  Widget _buildActionButtons() {
    final theme = Theme.of(context);
    return Column(
      children: [
        // もう一度プレイ（主要アクション）
        SizedBox(
          width: double.infinity,
          child: FButton(
            onPress: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => RankingGameScreen(
                    difficulty: widget.difficulty,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 18),
                SizedBox(width: 8),
                Text('もう一度プレイ'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ランキングを見る
        SizedBox(
          width: double.infinity,
          child: FButton(
            style: FButtonStyle.outline(),
            onPress: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => RankingLeaderboardScreen(
                    initialDifficulty: widget.difficulty,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.leaderboard_outlined, size: 18),
                SizedBox(width: 8),
                Text('ランキングを見る'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ホームに戻る
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text(
            'ホームに戻る',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
