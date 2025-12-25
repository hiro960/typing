import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:chaletta/core/services/sound_service.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/game_session_provider.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/combo_meter_widget.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/typing_game_result_screen.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:chaletta/ui/widgets/typing/input_feedback_widget.dart';
import 'package:chaletta/ui/widgets/typing_keyboard.dart';
import 'package:chaletta/ui/app_theme.dart';
import 'package:chaletta/features/typing/domain/providers/typing_settings_provider.dart';
import 'package:chaletta/features/typing/data/models/typing_settings.dart';
import 'package:chaletta/features/typing/domain/services/hangul_composer.dart';

/// タイピングゲーム画面
class RankingGameScreen extends ConsumerStatefulWidget {
  const RankingGameScreen({super.key, required this.difficulty});

  final String difficulty;

  @override
  ConsumerState<RankingGameScreen> createState() => _RankingGameScreenState();
}

class _RankingGameScreenState extends ConsumerState<RankingGameScreen> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  bool _isStarted = false;
  String _previousGameInput = ''; // システムキーボード入力の前回値を追跡

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
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() => _isStarted = true);
    ref
        .read(rankingGameSessionProvider(widget.difficulty).notifier)
        .startGame();

    // 内蔵キーボード使用時は入力欄にフォーカスを当てる
    final settings = ref.read(typingSettingsProvider).value;
    if (settings != null && !settings.useCustomKeyboard) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _textFieldFocusNode.requestFocus();
      });
    }
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
    final settingsAsync = ref.watch(typingSettingsProvider);
    final settings = settingsAsync.value;
    final theme = Theme.of(context);

    // ゲーム終了時に結果画面へ遷移
    ref.listen<RankingGameSessionState>(
      rankingGameSessionProvider(widget.difficulty),
      (previous, next) {
        if (next.isFinished && previous?.isFinished != true) {
          _navigateToResult(next);
        }
      },
    );

    // 正解/不正解音を再生
    ref.listen<RankingGameSessionState>(
      rankingGameSessionProvider(widget.difficulty),
      (previous, next) {
        final soundService = ref.read(soundServiceProvider);

        // 問題完了時（currentPositionが0にリセットされた）に正解音を再生
        if (previous != null &&
            previous.currentPosition > 0 &&
            next.currentPosition == 0 &&
            next.isPlaying) {
          soundService.playCorrect();
        }

        // 誤答音は現状通り（各文字のミス時）
        if (previous?.lastInputResult != next.lastInputResult &&
            next.lastInputResult == InputResultType.mistake) {
          soundService.playIncorrect();
        }
      },
    );

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: AppPageScaffold(
        title: '${_getDifficultyLabel(widget.difficulty)}モード',
        showBackButton: true,
        actions: [
          // タイマー
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: sessionState.remainingTimeMs < 10000
                  ? AppColors.error.withOpacity(0.3)
                  : theme.colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.timer_1,
                  color: sessionState.remainingTimeMs < 10000
                      ? AppColors.error
                      : theme.colorScheme.onSurface,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(sessionState.remainingTimeMs),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: sessionState.remainingTimeMs < 10000
                        ? AppColors.error
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
        safeBottom: true,
        child: _isStarted
            ? _buildGameContent(
                sessionState,
                settings ?? const TypingSettings(),
              )
            : _buildStartScreen(),
      ),
    );
  }

  Widget _buildStartScreen() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScoreBasedCharacterWidget(score: 0, difficulty: widget.difficulty),
          const SizedBox(height: 32),
          Text(
            '${_getDifficultyLabel(widget.difficulty)}モード',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getTimeLimit(),
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
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
        return '制限時間 60秒';
      case 'intermediate':
        return '制限時間 90秒';
      case 'advanced':
        return '制限時間 120秒';
      default:
        return '';
    }
  }

  Widget _buildGameContent(RankingGameSessionState state, TypingSettings settings) {
    final theme = Theme.of(context);
    final useCustomKeyboard = settings.useCustomKeyboard;

    return Column(
      children: [
        // キーボード以外のコンテンツ（パディング付き）
        Expanded(
          child: Padding(
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
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 24),
                    _buildStatChip(
                      icon: Iconsax.flash_circle,
                      label: 'コンボ',
                      value: state.currentCombo.toString(),
                      color: AppColors.accentEnd,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // キャラクター
                Expanded(
                  flex: 2,
                  child: Center(
                    child: ScoreBasedCharacterWidget(
                      score: state.score,
                      difficulty: widget.difficulty,
                      showName: false,
                    ),
                  ),
                ),

                // 出題エリア
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (state.currentWord != null) ...[
                        // 意味
                        Text(
                          state.currentWord!.meaning,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 出題文
                        Text(
                          state.currentWord!.word,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // 入力中の文字（ミス時は横揺れ）- カスタムキーボード用
                        if (useCustomKeyboard)
                          ShakeContainer(
                            key: state.lastInputResult == InputResultType.mistake &&
                                    state.lastInputTime != null
                                ? ValueKey(state.lastInputTime)
                                : null,
                            shouldShake:
                                state.lastInputResult == InputResultType.mistake,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 32),
                              decoration: BoxDecoration(
                                color: theme.brightness == Brightness.light
                                    ? theme.colorScheme.onSurface.withOpacity(0.08)
                                    : theme.colorScheme.onSurface.withOpacity(0.1),
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
                          )
                        // システムキーボード用の入力フィールド
                        else if (state.isPlaying)
                          _buildSystemKeyboardInputForGame(state),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // オンスクリーン韓国語キーボード（画面横幅いっぱい、SafeArea無視）
        if (state.isPlaying && useCustomKeyboard)
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
                ref
                    .read(
                      rankingGameSessionProvider(widget.difficulty).notifier,
                    )
                    .processInput(' ');
              },
              onEnter: () {
                // Enterも特に処理不要
              },
              enableHaptics: settings.hapticsEnabled,
            ),
          ),
      ],
    );
  }

  Widget _buildSystemKeyboardInputForGame(RankingGameSessionState state) {
    final theme = Theme.of(context);
    final targetWord = state.currentWord?.word ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? theme.colorScheme.onSurface.withOpacity(0.08)
            : theme.colorScheme.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: TextField(
        controller: _textController,
        focusNode: _textFieldFocusNode,
        autofocus: true,
        textAlign: TextAlign.center,
        autocorrect: false,
        enableSuggestions: false,
        enableIMEPersonalizedLearning: false,
        style: TextStyle(
          fontSize: 28,
          color: theme.colorScheme.onSurface,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        onChanged: (value) {
          // 単語単位で判定（文字ごとではなく）
          if (value.isEmpty || targetWord.isEmpty) return;

          // 入力が正解と完全一致した場合
          if (value == targetWord) {
            _handleCorrectAnswer(targetWord);
          }
          // 入力文字数がターゲットを超えた場合は不正解
          else if (value.length > targetWord.length) {
            _handleIncorrectAnswer();
          }
        },
        onSubmitted: (value) {
          // Enterキーで判定
          if (value.isEmpty || targetWord.isEmpty) return;

          if (value == targetWord) {
            _handleCorrectAnswer(targetWord);
          } else {
            _handleIncorrectAnswer();
          }
        },
      ),
    );
  }

  void _handleCorrectAnswer(String targetWord) {
    final sessionNotifier = ref.read(
      rankingGameSessionProvider(widget.difficulty).notifier,
    );

    // 正解の字母を全て入力して単語を完了（これにより正解音が再生される）
    final decomposed = HangulComposer.decomposeText(targetWord);
    for (final jamo in decomposed) {
      sessionNotifier.processInput(jamo);
    }

    // TextFieldをクリア（次の単語用）
    _textController.clear();
    _previousGameInput = '';

    // 次の単語のためにフォーカスを維持
    _textFieldFocusNode.requestFocus();
  }

  void _handleIncorrectAnswer() {
    // 不正解音を再生
    ref.read(soundServiceProvider).playIncorrect();

    // TextFieldをクリアして再入力を促す
    _textController.clear();
    _previousGameInput = '';

    // 再入力のためにフォーカスを維持
    _textFieldFocusNode.requestFocus();
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
    // 最後の入力結果に基づいて色を決定
    switch (state.lastInputResult) {
      case InputResultType.correct:
        return AppColors.success;
      case InputResultType.mistake:
        return AppColors.error;
      case InputResultType.none:
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.3);
    }
  }

  Color _getInputTextColor(RankingGameSessionState state) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    // 最後の入力結果に基づいて色を決定
    switch (state.lastInputResult) {
      case InputResultType.correct:
        // ライトモードでは暗めの緑色を使用
        return isLight ? const Color(0xFF16A34A) : AppColors.success;
      case InputResultType.mistake:
        return AppColors.error;
      case InputResultType.none:
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    }
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
          timeSpent: state.totalPlayTimeMs,
          accuracy: state.accuracy,
          mistakeCharacters: state.mistakeCharacters,
          completedWords: state.completedWords,
        ),
      ),
    );
  }
}
