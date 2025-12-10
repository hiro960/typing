import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../features/quick_translation/data/models/quick_translation_models.dart';
import '../../../features/quick_translation/domain/providers/quick_translation_providers.dart';
import '../../app_spacing.dart';
import 'quick_translation_result_screen.dart';

/// 練習画面
class QuickTranslationPracticeScreen extends ConsumerStatefulWidget {
  const QuickTranslationPracticeScreen({
    super.key,
    required this.grammarRef,
    required this.practiceMode,
    required this.inputMode,
  });

  final String grammarRef;
  final PracticeMode practiceMode;
  final InputMode inputMode;

  @override
  ConsumerState<QuickTranslationPracticeScreen> createState() =>
      _QuickTranslationPracticeScreenState();
}

class _QuickTranslationPracticeScreenState
    extends ConsumerState<QuickTranslationPracticeScreen> {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();

  bool _isLoading = true;
  bool _showAnswer = false;
  bool _showFeedback = false;
  AnswerResult? _lastResult;
  String _recognizedText = '';
  bool _isListening = false;
  bool _speechAvailable = false;
  String _speechError = '';

  @override
  void initState() {
    super.initState();
    _initSession();
    _initTts();
    if (widget.inputMode == InputMode.voice) {
      _initSpeech();
    }
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ko-KR');
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _initSpeech({bool autoStart = false}) async {
    try {
      _speechAvailable = await _speechToText.initialize(
        onError: (error) {
          debugPrint('Speech error: ${error.errorMsg}');
          if (mounted) {
            setState(() {
              _speechError = error.errorMsg;
              _isListening = false;
            });
          }
        },
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (mounted) {
            if (status == 'notListening' || status == 'done') {
              setState(() => _isListening = false);
            }
          }
        },
      );
      debugPrint('Speech available: $_speechAvailable');
      if (mounted) {
        setState(() {});
        // 初期化成功後、自動開始が指定されていれば認識開始
        if (autoStart && _speechAvailable) {
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted && !_isListening) {
            _startListening();
          }
        }
      }
    } catch (e) {
      debugPrint('Speech init error: $e');
      _speechAvailable = false;
      _speechError = e.toString();
    }
  }

  Future<void> _initSession() async {
    final notifier = ref.read(practiceSessionProvider.notifier);
    final success = await notifier.startSession(
      grammarRef: widget.grammarRef,
      practiceMode: widget.practiceMode,
      inputMode: widget.inputMode,
    );

    if (!success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('問題の読み込みに失敗しました')),
      );
      return;
    }

    setState(() => _isLoading = false);

    // 音声入力モードの場合、自動で認識開始
    if (widget.inputMode == InputMode.voice) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted && _speechAvailable && !_isListening) {
        _startListening();
      }
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(practiceSessionProvider);

    if (_isLoading || session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('読み込み中...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (session.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToResult();
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, session),
      body: _showFeedback
          ? _buildFeedbackView(context, session)
          : _buildQuestionView(context, session),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PracticeSessionState session,
  ) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        '${session.currentIndex + 1}/${session.totalQuestions}',
        style: theme.textTheme.titleMedium,
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _showExitConfirmation(context),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: LinearProgressIndicator(
          value: session.progressRate,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildQuestionView(
    BuildContext context,
    PracticeSessionState session,
  ) {
    final theme = Theme.of(context);
    final question = session.currentQuestion;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Spacer(),

            // 日本語問題文
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '日本語',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    question.japanese,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // 入力エリア
            if (widget.inputMode == InputMode.voice)
              _buildVoiceInputArea(context, question)
            else
              _buildManualModeArea(context, question),

            const Spacer(),

            // アクションボタン
            _buildActionButtons(context, session),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInputArea(
    BuildContext context,
    QuickTranslationQuestion question,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 音声認識の状態表示
        if (!_speechAvailable && _speechError.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning, color: Colors.red, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '音声認識を初期化できません',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ],
            ),
          ),

        Text(
          _isListening ? '聞いています...' : '韓国語で話してください',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: _isListening
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: _isListening ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 認識結果表示
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: _isListening
                ? theme.colorScheme.primary.withValues(alpha: 0.05)
                : null,
            border: Border.all(
              color: _isListening
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: _isListening ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _recognizedText.isEmpty
                ? Text(
                    _isListening ? '...' : 'マイクボタンを押して話す',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    _recognizedText,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ヒント
        if (question.hint != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'ヒント: ${question.hint}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),

        const SizedBox(height: AppSpacing.lg),

        // 音声入力ボタン
        GestureDetector(
          onTap: _speechAvailable ? _toggleListening : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isListening ? 90 : 80,
            height: _isListening ? 90 : 80,
            decoration: BoxDecoration(
              color: !_speechAvailable
                  ? Colors.grey
                  : _isListening
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (!_speechAvailable
                          ? Colors.grey
                          : _isListening
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary)
                      .withValues(alpha: 0.3),
                  blurRadius: _isListening ? 24 : 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _isListening ? Icons.stop : Icons.mic,
              size: _isListening ? 40 : 36,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // マイクボタンの説明
        Text(
          _isListening ? 'タップで停止' : 'タップで開始',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildManualModeArea(
    BuildContext context,
    QuickTranslationQuestion question,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '韓国語で話してみよう',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '声に出して練習してください',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ヒント
        if (question.hint != null)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'ヒント: ${question.hint}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSpacing.xl),

        // 正解表示ボタン
        if (!_showAnswer)
          ElevatedButton.icon(
            onPressed: () => setState(() => _showAnswer = true),
            icon: const Icon(Icons.visibility),
            label: const Text('正解を見る'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
            ),
          )
        else
          _buildAnswerReveal(context, question),
      ],
    );
  }

  Widget _buildAnswerReveal(
    BuildContext context,
    QuickTranslationQuestion question,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            '正解',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.green,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            question.korean,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          // 音声再生ボタン
          IconButton(
            onPressed: () => _speakKorean(question.korean),
            icon: const Icon(Icons.volume_up),
            color: Colors.green,
          ),
          if (question.explanation != null) ...[
            const Divider(height: AppSpacing.lg),
            Text(
              question.explanation!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    PracticeSessionState session,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _handleSkip,
            child: const Text('スキップ'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: widget.inputMode == InputMode.voice
                ? (_recognizedText.isNotEmpty ? _handleSubmitVoice : null)
                : (_showAnswer ? _handleNextManual : null),
            child: Text(
              widget.inputMode == InputMode.voice ? '確定' : '次の問題',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackView(
    BuildContext context,
    PracticeSessionState session,
  ) {
    final theme = Theme.of(context);
    // 前の問題を取得（currentIndexは既に次に進んでいる）
    final questionIndex = session.currentIndex - 1;
    if (questionIndex < 0) return const SizedBox.shrink();

    final question = session.questionSet.questions[questionIndex];
    final record = session.records.isNotEmpty ? session.records.last : null;

    Color feedbackColor;
    IconData feedbackIcon;
    String feedbackText;

    switch (_lastResult) {
      case AnswerResult.correct:
        feedbackColor = Colors.green;
        feedbackIcon = Icons.check_circle;
        feedbackText = '정답!';
      case AnswerResult.almostCorrect:
        feedbackColor = Colors.orange;
        feedbackIcon = Icons.check_circle_outline;
        feedbackText = '거의 맞았어요!';
      case AnswerResult.incorrect:
        feedbackColor = Colors.red;
        feedbackIcon = Icons.cancel;
        feedbackText = '아쉬워요!';
      default:
        feedbackColor = Colors.grey;
        feedbackIcon = Icons.skip_next;
        feedbackText = 'スキップ';
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              feedbackIcon,
              size: 80,
              color: feedbackColor,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              feedbackText,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: feedbackColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ユーザーの回答
            if (record != null && record.userAnswer.isNotEmpty) ...[
              Text(
                'あなたの回答:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                record.userAnswer,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // 正解
            Text(
              '正解:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              question.korean,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            // 音声再生
            IconButton(
              onPressed: () => _speakKorean(question.korean),
              icon: const Icon(Icons.volume_up, size: 32),
              color: Colors.green,
            ),

            if (question.explanation != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question.explanation!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            const Spacer(),

            // 次へボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToNext,
                child: const Text('次の問題'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 音声認識を開始
  Future<void> _startListening() async {
    if (_isListening) return;

    if (!_speechAvailable) {
      // 音声認識が利用できない場合は再初期化を試みる
      await _initSpeech();
      if (!_speechAvailable) {
        debugPrint('Speech not available after retry');
        return;
      }
    }

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _speechError = '';
    });

    try {
      await _speechToText.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              _recognizedText = result.recognizedWords;
            });
            debugPrint('Recognized: ${result.recognizedWords}, final: ${result.finalResult}');
          }
        },
        localeId: 'ko-KR',
        listenMode: ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('Listen error: $e');
      if (mounted) {
        setState(() {
          _isListening = false;
          _speechError = e.toString();
        });
      }
    }
  }

  /// 音声認識を停止
  Future<void> _stopListening() async {
    if (!_isListening) return;
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  /// 音声認識のトグル
  Future<void> _toggleListening() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  void _handleSubmitVoice() {
    if (_recognizedText.isEmpty) return;

    final session = ref.read(practiceSessionProvider);
    if (session == null) return;

    final checker = ref.read(answerCheckerServiceProvider);
    final result = checker.checkAnswer(_recognizedText, session.currentQuestion);

    _lastResult = result;
    ref.read(practiceSessionProvider.notifier).submitAnswer(
          _recognizedText,
          result,
        );

    setState(() {
      _showFeedback = true;
      _recognizedText = '';
    });
  }

  void _handleNextManual() {
    final session = ref.read(practiceSessionProvider);
    if (session == null) return;

    // 手動モードでは正解とみなす（自己判断）
    ref.read(practiceSessionProvider.notifier).submitAnswer(
          '',
          AnswerResult.correct,
        );

    setState(() {
      _showAnswer = false;
    });
  }

  void _handleSkip() {
    ref.read(practiceSessionProvider.notifier).skip();
    setState(() {
      _showAnswer = false;
      _recognizedText = '';
    });
  }

  Future<void> _proceedToNext() async {
    setState(() {
      _showFeedback = false;
      _showAnswer = false;
      _recognizedText = '';
      _lastResult = null;
    });

    // 音声入力モードの場合、次の問題で自動的に認識開始
    if (widget.inputMode == InputMode.voice) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && _speechAvailable && !_isListening) {
        _startListening();
      }
    }
  }

  Future<void> _speakKorean(String text) async {
    await _tts.speak(text);
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('練習を終了しますか？'),
        content: const Text('進捗は保存されません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(practiceSessionProvider.notifier).reset();
              Navigator.of(context).pop();
            },
            child: const Text('終了'),
          ),
        ],
      ),
    );
  }

  void _navigateToResult() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const QuickTranslationResultScreen(),
      ),
    );
  }
}
