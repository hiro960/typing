import 'package:chaletta/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:forui/forui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:chaletta/core/exceptions/app_exception.dart';
import 'package:chaletta/core/services/google_tts_service.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';
import 'package:chaletta/features/pronunciation_game/domain/providers/pronunciation_game_providers.dart';
import 'package:chaletta/features/pronunciation_game/presentation/screens/pronunciation_game_screen.dart';
import 'package:chaletta/features/pronunciation_game/presentation/screens/pronunciation_ranking_screen.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';
import 'package:chaletta/features/stats/domain/providers/integrated_stats_providers.dart';
import 'package:chaletta/features/wordbook/data/models/word_model.dart';
import 'package:chaletta/ui/app_theme.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:chaletta/ui/screens/wordbook/word_form_screen.dart';

/// 発音ゲーム結果画面
class PronunciationGameResultScreen extends ConsumerStatefulWidget {
  const PronunciationGameResultScreen({
    super.key,
    required this.difficulty,
    required this.score,
    required this.correctCount,
    required this.maxCombo,
    required this.totalBonusTime,
    required this.characterLevel,
    this.timeSpent,
    this.accuracy,
    this.isPracticeMode = false,
    this.targetQuestionCount,
    this.completedWords = const [],
    this.skippedWords = const [],
  });

  final String difficulty;
  final int score;
  final int correctCount;
  final int maxCombo;
  final int totalBonusTime;
  final int characterLevel;
  final int? timeSpent;
  final double? accuracy;
  final bool isPracticeMode;
  final int? targetQuestionCount;
  final List<PronunciationGameWord> completedWords;
  final List<PronunciationGameWord> skippedWords;

  @override
  ConsumerState<PronunciationGameResultScreen> createState() =>
      _PronunciationGameResultScreenState();
}

class _PronunciationGameResultScreenState
    extends ConsumerState<PronunciationGameResultScreen> {
  bool _isSubmitting = false;
  String? _errorMessage;
  PronunciationGameResultResponse? _resultResponse;
  final FlutterTts _tts = FlutterTts();

  // 高品質TTS用の状態変数
  bool _isTtsLoading = false;
  String? _currentTtsWord;

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitResult();
    });
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ko-KR');
    await _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakKorean(String text) async {
    await _tts.speak(text);
  }

  /// 高品質な音声を再生（練習モード用）
  Future<void> _playHighQualityPronunciation(String text) async {
    if (_isTtsLoading) return;

    setState(() {
      _isTtsLoading = true;
      _currentTtsWord = text;
    });

    try {
      final googleTts = ref.read(googleTtsServiceProvider);
      final result = await googleTts.speak(text);

      if (!mounted) return;

      switch (result) {
        case TtsResult.success:
          // 成功時は特に何もしない
          break;
        case TtsResult.premiumRequired:
          // 有料会員でない場合は通常のTTSにフォールバック
          await _speakKorean(text);
          break;
        case TtsResult.networkError:
        case TtsResult.error:
          // エラー時は通常のTTSにフォールバック
          await _speakKorean(text);
          break;
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTtsLoading = false;
          _currentTtsWord = null;
        });
      }
    }
  }

  Future<void> _openWordForm(String korean, String japanese) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordFormScreen(
          initialWord: korean,
          initialMeaning: japanese,
          initialCategory: WordCategory.WORDS,
        ),
      ),
    );
  }

  Future<void> _submitResult() async {
    if (!mounted) return;

    // 練習モードの場合はランキング送信しない
    if (widget.isPracticeMode) {
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final response = await ref
          .read(pronunciationGameResultSubmitterProvider.notifier)
          .submitResult(
            difficulty: widget.difficulty,
            score: widget.score,
            correctCount: widget.correctCount,
            maxCombo: widget.maxCombo,
            totalBonusTime: widget.totalBonusTime,
            characterLevel: widget.characterLevel,
            timeSpent: widget.timeSpent,
            accuracy: widget.accuracy,
          );

      if (!mounted) return;

      // 統計プロバイダーを無効化
      ref.invalidate(integratedStatsProvider);

      setState(() {
        _isSubmitting = false;
        _resultResponse = response;
      });
    } catch (e) {
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

  /// シェアボタンのGlobalKeyを保持（iPadでのシェアポップオーバー表示位置用）
  final GlobalKey _shareButtonKey = GlobalKey();

  void _shareResult() {
    final diffLabel = _getDifficultyLabel(widget.difficulty);
    final rankText = _resultResponse != null
        ? '順位: ${_resultResponse!.ranking.position}位 / ${_resultResponse!.ranking.totalParticipants}人中'
        : '';
    final newBestText =
        _resultResponse?.ranking.isNewBest == true ? '🎉 自己ベスト更新!' : '';

    final shareText = '''
🎤 発音ゲーム結果

📊 スコア: ${widget.score}点
🏆 $diffLabel モード
$rankText
$newBestText

✅ 正解数: ${widget.correctCount}問
🔥 最大コンボ: ${widget.maxCombo}
⏱️ ボーナス時間: +${widget.totalBonusTime}秒

#韓国語学習 #チャレッタ #発音練習
''';

    // iPadではシェアポップオーバーの表示位置を指定する必要がある
    final box = _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    Share.share(
      shareText.trim(),
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(pronunciationGameResultSubmitterProvider);

    final theme = Theme.of(context);
    return AppPageScaffold(
      title: '発音ゲーム結果',
      showBackButton: true,
      onBack: () => Navigator.of(context).pop(),
      actions: [
        FHeaderAction(
          key: _shareButtonKey,
          icon: const Icon(Iconsax.share),
          onPress: _shareResult,
        ),
      ],
      safeBottom: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _buildHeroSection(),
            const SizedBox(height: 16),
            if (widget.isPracticeMode)
              _buildPracticeModeInfo()
            else if (_isSubmitting)
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
              _buildErrorMessage(),
            const SizedBox(height: 16),
            _buildCompactStatsRow(),
            const SizedBox(height: 24),

            // 学習した単語一覧（正解した単語）
            if (widget.completedWords.isNotEmpty) ...[
              _buildWordsList(
                words: widget.completedWords,
                title: '正解した単語',
                icon: Iconsax.tick_circle,
                iconColor: AppColors.success,
                borderColor: AppColors.success,
              ),
              const SizedBox(height: 16),
            ],

            // スキップした単語
            if (widget.skippedWords.isNotEmpty) ...[
              _buildWordsList(
                words: widget.skippedWords,
                title: 'スキップした単語',
                icon: Iconsax.forward,
                iconColor: AppColors.warning,
                borderColor: AppColors.warning,
              ),
              const SizedBox(height: 24),
            ],

            if (widget.completedWords.isEmpty && widget.skippedWords.isEmpty)
              const SizedBox(height: 24),

            _buildActionButtons(),
          ],
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
          ScoreBasedCharacterWidget(
            score: widget.score,
            difficulty: widget.difficulty,
            showName: true,
            pixelSize: 2.5,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentEnd.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.microphone,
                            size: 12,
                            color: AppColors.accentEnd,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '発音',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentEnd,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                          Icon(Iconsax.gift, color: Colors.white, size: 14),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.cup,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '今月のランキング（発音ゲーム）',
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
                    positionChange > 0 ? Iconsax.arrow_up : Iconsax.arrow_down,
                    color: positionChange > 0 ? AppColors.success : AppColors.error,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${positionChange.abs()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          positionChange > 0 ? AppColors.success : AppColors.error,
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
    final accuracyPercent =
        widget.accuracy != null ? (widget.accuracy! * 100).toStringAsFixed(0) : '-';
    return Row(
      children: [
        Expanded(
          child: _buildCompactStatItem(
            icon: Iconsax.tick_circle,
            value: '${widget.correctCount}',
            label: '正解',
            color: AppColors.success,
          ),
        ),
        Expanded(
          child: _buildCompactStatItem(
            icon: Iconsax.flash_circle,
            value: '${widget.maxCombo}',
            label: 'コンボ',
            color: AppColors.accentEnd,
          ),
        ),
        Expanded(
          child: _buildCompactStatItem(
            icon: Iconsax.timer_1,
            value: '+${widget.totalBonusTime}s',
            label: 'ボーナス',
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: _buildCompactStatItem(
            icon: Icons.percent,
            value: '$accuracyPercent%',
            label: '正解率',
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

  Widget _buildWordsList({
    required List<PronunciationGameWord> words,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPremiumUser = ref.watch(currentUserProvider)?.isPremiumUser ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ヘッダー
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              '${words.length}語',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 単語リスト（Card形式）
        ...words.map((word) {
          final isCurrentTtsWord = _currentTtsWord == word.word;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor.withOpacity(0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: borderColor.withOpacity(0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 単語情報
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.meaning,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          word.word,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 単語帳追加ボタン
                  IconButton(
                    icon: const Icon(Iconsax.bookmark_2),
                    iconSize: 20,
                    onPressed: () => _openWordForm(word.word, word.meaning),
                    color: theme.colorScheme.secondary,
                  ),
                  // 音声再生ボタン（通常）
                  IconButton(
                    icon: const Icon(Iconsax.volume_high),
                    iconSize: 20,
                    onPressed: () => _speakKorean(word.word),
                    color: AppColors.primary,
                  ),
                  // 高品質音声再生ボタン（練習モード時のみ表示）
                  if (widget.isPracticeMode)
                    Stack(
                      children: [
                        IconButton(
                          icon: isCurrentTtsWord && _isTtsLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.accentEnd,
                                  ),
                                )
                              : const Icon(Iconsax.voice_square),
                          iconSize: 20,
                          onPressed: _isTtsLoading
                              ? null
                              : () => _playHighQualityPronunciation(word.word),
                          color: AppColors.accentEnd,
                        ),
                        // 有料会員でない場合は王冠マークを表示
                        if (!isPremiumUser && !(isCurrentTtsWord && _isTtsLoading))
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.crown,
                                size: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeModeInfo() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.book_1,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '練習モード',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'このスコアはランキングに反映されません',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
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
        SizedBox(
          width: double.infinity,
          child: FButton(
            onPress: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => PronunciationGameScreen(
                    config: PronunciationGameConfig(
                      difficulty: widget.difficulty,
                      isPracticeMode: widget.isPracticeMode,
                      targetQuestionCount: widget.targetQuestionCount,
                    ),
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.refresh, size: 18),
                SizedBox(width: 8),
                Text('もう一度プレイ'),
              ],
            ),
          ),
        ),
        // 練習モードでない場合のみランキングボタンを表示
        if (!widget.isPracticeMode) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FButton(
              style: FButtonStyle.outline(),
              onPress: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => PronunciationRankingScreen(
                      initialDifficulty: widget.difficulty,
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.ranking, size: 18),
                  SizedBox(width: 8),
                  Text('ランキングを見る'),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
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
