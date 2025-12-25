import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:chaletta/core/services/sound_service.dart';
import 'package:chaletta/core/services/google_tts_service.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';
import 'package:chaletta/features/pronunciation_game/domain/providers/pronunciation_game_session_provider.dart';
import 'package:chaletta/features/pronunciation_game/presentation/screens/pronunciation_game_result_screen.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/features/auth/data/models/user_model.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:chaletta/ui/widgets/premium_feature_gate.dart';
import 'package:chaletta/ui/app_theme.dart';
import 'package:chaletta/features/settings/domain/providers/display_settings_provider.dart';
import 'package:chaletta/features/settings/data/models/display_settings.dart';

/// 発音ゲーム画面
class PronunciationGameScreen extends ConsumerStatefulWidget {
  const PronunciationGameScreen({super.key, required this.config});

  final PronunciationGameConfig config;

  @override
  ConsumerState<PronunciationGameScreen> createState() =>
      _PronunciationGameScreenState();
}

class _PronunciationGameScreenState
    extends ConsumerState<PronunciationGameScreen> {
  bool _isStarted = false;
  bool _isStarting = false;
  bool _isTtsSpeaking = false;

  // Note: dispose時のリソースクリーンアップはプロバイダー側のref.onDisposeで行われる
  // ウィジェットのdispose内でプロバイダーのstateを変更するとRiverpodの制約でエラーになるため、
  // 画面側からはreset()を呼ばない。次回startGame()時に_cleanupPreviousSession()で
  // 前回のセッションがクリーンアップされる。

  @override
  void initState() {
    super.initState();
    // サウンドを事前に初期化（Androidでの遅延対策）
    _initializeSounds();
  }

  /// サウンドサービスを事前に初期化
  Future<void> _initializeSounds() async {
    final soundService = ref.read(soundServiceProvider);
    if (!soundService.isInitialized) {
      await soundService.initialize();
    }
  }

  Future<void> _startGame() async {
    // 重複起動を防止
    if (_isStarting) return;
    _isStarting = true;

    try {
      final success = await ref
          .read(pronunciationGameSessionProvider(widget.config).notifier)
          .startGame();

      if (!mounted) return;

      if (success) {
        setState(() => _isStarted = true);
      } else {
        // 初期化に失敗した場合はダイアログを表示
        _showInitializationErrorDialog();
      }
    } catch (e) {
      if (mounted) {
        _showInitializationErrorDialog();
      }
    } finally {
      _isStarting = false;
    }
  }

  void _showInitializationErrorDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.mic_off,
          color: AppColors.error,
          size: 48,
        ),
        title: const Text('マイクが使用できません'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '発音ゲームにはマイクの使用が必要です。',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '以下を確認してください：\n'
              '• 設定アプリでマイクの権限を許可\n'
              '• 他のアプリがマイクを使用していないか確認\n'
              '• デバイスのマイクが正常に動作しているか確認',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop(); // ゲーム画面から戻る
            },
            child: const Text('戻る'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _startGame(); // 再試行
            },
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }

  /// Google Cloud TTSで発音を再生（有料会員限定）
  Future<void> _playPronunciation(String text) async {
    if (_isTtsSpeaking) return;

    // 有料会員チェック
    final user = ref.read(currentUserProvider);
    if (user == null || !user.isPremiumUser) {
      _showPremiumOnlyDialog();
      return;
    }

    setState(() => _isTtsSpeaking = true);

    try {
      final ttsService = ref.read(googleTtsServiceProvider);
      final result = await ttsService.speak(text);

      if (!mounted) return;

      switch (result) {
        case TtsResult.success:
          // 再生成功
          break;
        case TtsResult.premiumRequired:
          _showPremiumOnlyDialog();
          break;
        case TtsResult.networkError:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ネットワークエラーが発生しました')),
          );
          break;
        case TtsResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('音声の再生に失敗しました')),
          );
          break;
      }
    } finally {
      if (mounted) {
        setState(() => _isTtsSpeaking = false);
      }
    }
  }

  /// 有料会員限定機能のダイアログを表示
  void _showPremiumOnlyDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Iconsax.crown, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('有料会員限定'),
          ],
        ),
        content: const Text(
          'この機能は有料会員限定です。\n\nアップグレードすると、高品質なネイティブ発音をご利用いただけます。',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const PremiumFeatureGateScreen(focusFeature: 'ネイティブ発音'),
                ),
              );
            },
            child: const Text('プロプランを見る'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
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
      pronunciationGameSessionProvider(widget.config),
    );
    final theme = Theme.of(context);

    // ゲーム終了時に結果画面へ遷移
    ref.listen<PronunciationGameSessionState>(
      pronunciationGameSessionProvider(widget.config),
      (previous, next) {
        if (next.isFinished && previous?.isFinished != true) {
          _navigateToResult(next);
        }
      },
    );

    // 正解/不正解音を再生
    ref.listen<PronunciationGameSessionState>(
      pronunciationGameSessionProvider(widget.config),
      (previous, next) {
        if (previous?.lastInputResult != next.lastInputResult) {
          final soundService = ref.read(soundServiceProvider);
          if (next.lastInputResult == PronunciationInputResultType.correct) {
            soundService.playCorrect();
          } else if (next.lastInputResult == PronunciationInputResultType.mistake) {
            soundService.playIncorrect();
          }
        }
      },
    );

    return AppPageScaffold(
      title: '発音ゲーム ${_getDifficultyLabel(widget.config.difficulty)}',
      showBackButton: true,
      actions: [
        // 練習モードの場合は進捗表示、通常モードはタイマー表示
        widget.config.isPracticeMode
            ? _buildPracticeProgressBadge(sessionState, theme)
            : _buildTimerBadge(sessionState, theme),
      ],
      safeBottom: true,
      child:
          _isStarted ? _buildGameContent(sessionState) : _buildStartScreen(),
    );
  }

  Widget _buildTimerBadge(PronunciationGameSessionState sessionState, ThemeData theme) {
    return Container(
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
            Icons.timer,
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
    );
  }

  Widget _buildPracticeProgressBadge(PronunciationGameSessionState sessionState, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.book_1,
            color: AppColors.secondary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '${sessionState.correctCount}/${widget.config.targetQuestionCount}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartScreen() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScoreBasedCharacterWidget(score: 0, difficulty: widget.config.difficulty),
          const SizedBox(height: 32),
          Text(
            '発音ゲーム',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_getDifficultyLabel(widget.config.difficulty)}モード',
                style: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              if (widget.config.isPracticeMode) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '練習',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getTimeLimit(),
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '韓国語を声に出して発音してください\n正解すると次の問題に進みます',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
            child: FButton(
              onPress: _startGame,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Iconsax.microphone, size: 20),
                  SizedBox(width: 8),
                  Text('スタート'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeLimit() {
    if (widget.config.isPracticeMode) {
      return '${widget.config.targetQuestionCount}問 / 時間無制限';
    }
    switch (widget.config.difficulty) {
      case 'beginner':
        return '制限時間 30秒';
      case 'intermediate':
        return '制限時間 45秒';
      case 'advanced':
        return '制限時間 60秒';
      default:
        return '';
    }
  }

  Widget _buildGameContent(PronunciationGameSessionState state) {
    final theme = Theme.of(context);
    final displaySettings =
        ref.watch(displaySettingsProvider).value ?? const DisplaySettings();
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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
                const SizedBox(height: 16),

                // キャラクター
                Expanded(
                  flex: 2,
                  child: Center(
                    child: ScoreBasedCharacterWidget(
                      score: state.score,
                      difficulty: widget.config.difficulty,
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
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 出題文
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            state.currentWord!.word,
                            style: TextStyle(
                              fontSize: 32 * displaySettings.promptFontScale,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 認識中のテキスト表示
                        _buildRecognizedTextArea(state),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // マイクコントロールエリア
        if (state.isPlaying) _buildMicrophoneArea(state),
      ],
    );
  }

  Widget _buildRecognizedTextArea(PronunciationGameSessionState state) {
    final theme = Theme.of(context);
    final isCorrect =
        state.lastInputResult == PronunciationInputResultType.correct;
    final isMistake =
        state.lastInputResult == PronunciationInputResultType.mistake;

    // 赤い点の表示条件：isListeningの時のみ表示
    final showRecIndicator = state.isListening;

    // ステータスラベルを決定
    // ゲームプレイ中は常に「発音してください」を表示（チカチカ防止）
    String statusLabel;
    if (isCorrect) {
      statusLabel = '正解！';
    } else if (isMistake) {
      statusLabel = 'もう一度';
    } else if (state.recognizedText.isNotEmpty) {
      statusLabel = '認識中...';
    } else {
      // ゲームプレイ中は isListening に関係なく常に表示
      statusLabel = '発音してください';
    }

    // 表示テキストを決定
    // ゲームプレイ中は常にマイクアイコンを表示（チカチカ防止）
    String displayText;
    if (state.recognizedText.isNotEmpty) {
      displayText = state.recognizedText;
    } else if (isCorrect) {
      displayText = '✓';
    } else if (isMistake) {
      displayText = '✗';
    } else {
      // ゲームプレイ中は isListening に関係なくマイクを表示
      displayText = '🎤';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withOpacity(0.15)
            : isMistake
                ? AppColors.error.withOpacity(0.15)
                : theme.colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? AppColors.success
              : isMistake
                  ? AppColors.error
                  : theme.colorScheme.onSurface.withOpacity(0.2),
          width: isCorrect || isMistake ? 3 : 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 録音中インジケーター（赤い点）- ゲームプレイ中は常に表示
              AnimatedOpacity(
                opacity: showRecIndicator ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (isCorrect)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Iconsax.tick_circle,
                    color: AppColors.success,
                    size: 16,
                  ),
                ),
              if (isMistake)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.cancel,
                    color: AppColors.error,
                    size: 16,
                  ),
                ),
              Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCorrect || isMistake ? FontWeight.bold : FontWeight.normal,
                  color: isCorrect
                      ? AppColors.success
                      : isMistake
                          ? AppColors.error
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            displayText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: isCorrect
                  ? AppColors.success
                  : isMistake
                      ? AppColors.error
                      : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicrophoneArea(PronunciationGameSessionState state) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // スキップボタン
            FButton(
              style: FButtonStyle.secondary(),
              onPress: () {
                ref
                    .read(pronunciationGameSessionProvider(widget.config)
                        .notifier)
                    .skipWord();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.skip_next, size: 20),
                  SizedBox(width: 4),
                  Text('スキップ'),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // マイクインジケーター（タップで音声認識を再起動）
            GestureDetector(
              onTap: () {
                ref
                    .read(pronunciationGameSessionProvider(widget.config)
                        .notifier)
                    .restartSpeechRecognition();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: state.isListening
                      ? AppColors.accentEnd.withOpacity(0.2)
                      : theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: state.isListening
                        ? AppColors.accentEnd
                        : theme.colorScheme.primary,
                    width: 3,
                  ),
                  boxShadow: state.isListening
                      ? [
                          BoxShadow(
                            color: AppColors.accentEnd.withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  state.isListening ? Iconsax.microphone : Iconsax.microphone,
                  size: 36,
                  color: state.isListening
                      ? AppColors.accentEnd
                      : theme.colorScheme.primary,
                ),
              ),
            ),
            // 練習モード時のみスピーカーボタンを表示
            if (widget.config.isPracticeMode && state.currentWord != null) ...[
              const SizedBox(width: 24),
              // スピーカーボタン（ネイティブ発音再生）
              GestureDetector(
                onTap: _isTtsSpeaking
                    ? null
                    : () => _playPronunciation(state.currentWord!.word),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _isTtsSpeaking
                        ? AppColors.primary.withOpacity(0.3)
                        : AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    boxShadow: _isTtsSpeaking
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Iconsax.volume_high,
                        size: 28,
                        color: AppColors.primary,
                      ),
                      // 有料会員でない場合は王冠マークを表示
                      if (!(ref.watch(currentUserProvider)?.isPremiumUser ?? false))
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.crown,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
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

  void _navigateToResult(PronunciationGameSessionState state) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PronunciationGameResultScreen(
          difficulty: widget.config.difficulty,
          score: state.score,
          correctCount: state.correctCount,
          maxCombo: state.maxCombo,
          totalBonusTime: state.totalBonusTime,
          characterLevel: state.characterLevel,
          timeSpent: state.totalPlayTimeMs,
          accuracy: state.accuracy,
          isPracticeMode: widget.config.isPracticeMode,
          targetQuestionCount: widget.config.targetQuestionCount,
          completedWords: state.completedWords,
        ),
      ),
    );
  }
}
