import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/game_session_provider.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_game_providers.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/combo_meter_widget.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/ranking_game_result_screen.dart';
import 'package:chaletta/ui/widgets/typing_keyboard.dart';

/// ランキングゲーム画面
class RankingGameScreen extends ConsumerStatefulWidget {
  const RankingGameScreen({super.key, required this.difficulty});

  final String difficulty;

  @override
  ConsumerState<RankingGameScreen> createState() => _RankingGameScreenState();
}

class _RankingGameScreenState extends ConsumerState<RankingGameScreen> {
  final FocusNode _focusNode = FocusNode();
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() => _isStarted = true);
    ref
        .read(rankingGameSessionProvider(widget.difficulty).notifier)
        .startGame();
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final sessionNotifier = ref.read(
      rankingGameSessionProvider(widget.difficulty).notifier,
    );
    final state = ref.read(rankingGameSessionProvider(widget.difficulty));

    if (!state.isPlaying) return;

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      sessionNotifier.deleteLastCharacter();
    } else if (event.character != null && event.character!.isNotEmpty) {
      sessionNotifier.processInput(event.character!);
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

  String _formatTime(int ms) {
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final tenths = (ms % 1000) ~/ 100;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$tenths';
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(
      rankingGameSessionProvider(widget.difficulty),
    );

    // ゲーム終了時に結果画面へ遷移
    ref.listen<RankingGameSessionState>(
      rankingGameSessionProvider(widget.difficulty),
      (previous, next) {
        if (next.isFinished && previous?.isFinished != true) {
          _navigateToResult(next);
        }
      },
    );

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '${_getDifficultyLabel(widget.difficulty)}モード',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            // タイマー
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: sessionState.remainingTimeMs < 10000
                    ? Colors.red.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    color: sessionState.remainingTimeMs < 10000
                        ? Colors.red
                        : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(sessionState.remainingTimeMs),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: sessionState.remainingTimeMs < 10000
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: _isStarted
              ? _buildGameContent(sessionState)
              : _buildStartScreen(),
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ScoreBasedCharacterWidget(score: 0),
          const SizedBox(height: 32),
          Text(
            '${_getDifficultyLabel(widget.difficulty)}モード',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getTimeLimit(),
            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 32, vertical: 6),
            child: FButton(onPress: _startGame, child: const Text('スタート')),
          ),
        ],
      ),
    );
  }

  String _getTimeLimit() {
    switch (widget.difficulty) {
      case 'beginner':
        return '制限時間: 60秒';
      case 'intermediate':
        return '制限時間: 90秒';
      case 'advanced':
        return '制限時間: 120秒';
      default:
        return '';
    }
  }

  Widget _buildGameContent(RankingGameSessionState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // コンボメーター
          ComboMeterWidget(state: state.comboMeter),
          const SizedBox(height: 16),

          // スコアとコンボ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatChip(
                icon: Icons.stars,
                label: 'スコア',
                value: state.score.toString(),
                color: const Color(0xFFFFD700),
              ),
              const SizedBox(width: 24),
              _buildStatChip(
                icon: Icons.local_fire_department,
                label: 'コンボ',
                value: state.currentCombo.toString(),
                color: const Color(0xFFFF5722),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // キャラクター
          Expanded(
            flex: 2,
            child: Center(
              child: ScoreBasedCharacterWidget(
                score: state.score,
                showName: true,
              ),
            ),
          ),

          // 出題エリア
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.currentWord != null) ...[
                  // 出題文
                  Text(
                    state.currentWord!.word,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 意味
                  Text(
                    state.currentWord!.meaning,
                    style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 24),
                  // 入力中の文字
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getInputBorderColor(state),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      state.inputBuffer.isEmpty ? '　' : state.inputBuffer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        color: _getInputTextColor(state),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // オンスクリーン韓国語キーボード
          if (state.isPlaying)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TypingKeyboard(
                onTextInput: (value) {
                  ref
                      .read(
                        rankingGameSessionProvider(widget.difficulty).notifier,
                      )
                      .processInput(value);
                },
                onBackspace: () {
                  ref
                      .read(
                        rankingGameSessionProvider(widget.difficulty).notifier,
                      )
                      .deleteLastCharacter();
                },
                onSpace: () {
                  // スペースは韓国語入力では使わないが、必要な場合は処理
                },
                onEnter: () {
                  // Enterも特に処理不要
                },
                enableHaptics: true,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.8)),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getInputBorderColor(RankingGameSessionState state) {
    if (state.inputBuffer.isEmpty) return Colors.grey;
    if (state.currentWord?.word.startsWith(state.inputBuffer) ?? false) {
      return const Color(0xFF4CAF50);
    }
    return Colors.red;
  }

  Color _getInputTextColor(RankingGameSessionState state) {
    if (state.inputBuffer.isEmpty) return Colors.grey;
    if (state.currentWord?.word.startsWith(state.inputBuffer) ?? false) {
      return const Color(0xFF4CAF50);
    }
    return Colors.red;
  }

  void _navigateToResult(RankingGameSessionState state) {
    final avgInputSpeed = ref
        .read(rankingGameSessionProvider(widget.difficulty).notifier)
        .getAvgInputSpeed();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => RankingGameResultScreen(
          difficulty: widget.difficulty,
          score: state.score,
          correctCount: state.correctCount,
          maxCombo: state.maxCombo,
          totalBonusTime: state.totalBonusTime,
          avgInputSpeed: avgInputSpeed,
          characterLevel: state.characterLevel,
        ),
      ),
    );
  }
}
