import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_game_providers.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/ranking_leaderboard_screen.dart';

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
  bool _isSubmitted = false;
  String? _errorMessage;
  RankingGameResultResponse? _resultResponse;

  @override
  void initState() {
    super.initState();
    _submitResult();
  }

  Future<void> _submitResult() async {
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

      setState(() {
        _isSubmitting = false;
        _isSubmitted = true;
        _resultResponse = response;
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'オフラインで保存しました。次回接続時に送信されます。';
        _isSubmitted = true;
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'ゲーム結果',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // シェアボタン
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareResult,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // キャラクター表示
              ScoreBasedCharacterWidget(
                score: widget.score,
                showName: true,
              ),
              const SizedBox(height: 24),

              // 難易度バッジ
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getDifficultyColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getDifficultyColor(),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_getDifficultyLabel(widget.difficulty)}モード',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // スコア表示
              Text(
                'スコア',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.score}',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),

              // ベスト更新表示
              if (_resultResponse?.ranking.isNewBest == true)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.celebration, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '自己ベスト更新!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // ランキング情報
              if (_isSubmitting)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: Color(0xFF4CAF50),
                  ),
                )
              else if (_resultResponse != null)
                _buildRankingInfo()
              else if (_errorMessage != null)
                _buildOfflineMessage(),

              const SizedBox(height: 24),

              // 詳細統計
              _buildStatsGrid(),
              const SizedBox(height: 24),

              // アクションボタン
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingInfo() {
    final ranking = _resultResponse!.ranking;
    final positionChange = ranking.previousPosition != null
        ? ranking.previousPosition! - ranking.position
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.2),
            const Color(0xFF2196F3).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          const Text(
            '今月のランキング',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${ranking.position}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                '位',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${ranking.totalParticipants}人中',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          // 順位変動表示
          if (positionChange != null && positionChange != 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    positionChange > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: positionChange > 0 ? const Color(0xFF4CAF50) : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    positionChange > 0 ? '$positionChange位UP!' : '${positionChange.abs()}位DOWN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: positionChange > 0 ? const Color(0xFF4CAF50) : Colors.red,
                    ),
                  ),
                ],
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
    switch (widget.difficulty) {
      case 'beginner':
        return const Color(0xFF4CAF50);
      case 'intermediate':
        return const Color(0xFFFFEB3B);
      case 'advanced':
        return const Color(0xFFFF5722);
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle,
                  label: '正解数',
                  value: '${widget.correctCount}問',
                  color: const Color(0xFF4CAF50),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.local_fire_department,
                  label: '最大コンボ',
                  value: '${widget.maxCombo}',
                  color: const Color(0xFFFF5722),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.timer,
                  label: 'ボーナス時間',
                  value: '+${widget.totalBonusTime}秒',
                  color: const Color(0xFF2196F3),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.speed,
                  label: '平均入力速度',
                  value: '${widget.avgInputSpeed.toStringAsFixed(1)}文字/分',
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // シェアボタン
        SizedBox(
          width: double.infinity,
          child: FButton(
            onPress: _shareResult,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 18),
                SizedBox(width: 8),
                Text('結果をシェア'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // もう一度プレイ
        SizedBox(
          width: double.infinity,
          child: FButton(
            onPress: () {
              Navigator.of(context).pop();
            },
            child: const Text('もう一度プレイ'),
          ),
        ),
        const SizedBox(height: 12),

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
            child: const Text('ランキングを見る'),
          ),
        ),
        const SizedBox(height: 12),

        // ホームに戻る
        FButton(
          style: FButtonStyle.ghost(),
          onPress: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text(
            'ホームに戻る',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }
}
