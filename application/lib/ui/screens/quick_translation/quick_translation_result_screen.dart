import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/quick_translation/data/models/quick_translation_models.dart';
import '../../../features/quick_translation/domain/providers/quick_translation_providers.dart';
import '../../app_theme.dart';
import '../../app_spacing.dart';

/// 結果画面
class QuickTranslationResultScreen extends ConsumerStatefulWidget {
  const QuickTranslationResultScreen({super.key});

  @override
  ConsumerState<QuickTranslationResultScreen> createState() =>
      _QuickTranslationResultScreenState();
}

class _QuickTranslationResultScreenState
    extends ConsumerState<QuickTranslationResultScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _saveProgress();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ko-KR');
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _saveProgress() async {
    setState(() => _isSaving = true);
    await ref.read(practiceSessionProvider.notifier).finishSession();
    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(practiceSessionProvider);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('結果')),
        body: const Center(child: Text('セッションが見つかりません')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('結果'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.close_circle),
            onPressed: () => _exitToHome(context),
          ),
        ],
      ),
      body: _buildContent(context, session),
    );
  }

  Widget _buildContent(BuildContext context, PracticeSessionState session) {
    return Column(
      children: [
        // スコアヘッダー
        _buildScoreHeader(context, session),

        // 問題一覧
        Expanded(
          child: _buildQuestionList(context, session),
        ),

        // アクションボタン
        _buildActionButtons(context, session),
      ],
    );
  }

  Widget _buildScoreHeader(
    BuildContext context,
    PracticeSessionState session,
  ) {
    final theme = Theme.of(context);
    final correctRate = (session.correctCount + session.almostCorrectCount) /
        session.totalQuestions;
    final isCleared = correctRate >= 0.8;
    final accent = isCleared ? AppColors.primary : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCleared
              ? [
                  AppColors.primary.withValues(alpha: 0.18),
                  AppColors.primaryBright.withValues(alpha: 0.14),
                ]
              : [
                  AppColors.warning.withValues(alpha: 0.2),
                  AppColors.error.withValues(alpha: 0.12),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: accent.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 完了アイコン
          Icon(
            isCleared ? Iconsax.medal_star : Iconsax.cup,
            size: 48,
            color: accent,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isCleared ? '완료!' : '수고하셨어요!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // スコア表示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ScoreItem(
                label: '正解',
                count: session.correctCount,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.lg),
              _ScoreItem(
                label: 'ほぼ正解',
                count: session.almostCorrectCount,
                color: AppColors.warning,
              ),
              const SizedBox(width: AppSpacing.lg),
              _ScoreItem(
                label: '不正解',
                count: session.incorrectCount + session.skippedCount,
                color: AppColors.error,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // 進捗バー
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: correctRate,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(
                accent,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${(correctRate * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),

          if (_isSaving) ...[
            const SizedBox(height: AppSpacing.sm),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionList(
    BuildContext context,
    PracticeSessionState session,
  ) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: session.records.length,
      itemBuilder: (context, index) {
        final record = session.records[index];
        final question = session.questionSet.questions.firstWhere(
          (q) => q.id == record.questionId,
        );
        final accent = _resultColor(record.result);

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surface
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accent.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.16),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 結果アイコン
                _buildResultIcon(record.result),
                const SizedBox(width: AppSpacing.md),

                // 問題内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.japanese,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        question.korean,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (record.userAnswer.isNotEmpty &&
                          record.result != AnswerResult.correct) ...[
                        const SizedBox(height: 4),
                        Text(
                          'あなた: ${record.userAnswer}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: accent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 音声再生ボタン
                IconButton(
                  icon: const Icon(Iconsax.volume_high),
                  iconSize: 20,
                  onPressed: () => _speakKorean(question.korean),
                  color: accent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultIcon(AnswerResult result) {
    final accent = _resultColor(result);
    switch (result) {
      case AnswerResult.correct:
        return Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryBright],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.tick_square, size: 18, color: Colors.white),
        );
      case AnswerResult.almostCorrect:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 2),
          ),
          child: Icon(Iconsax.tick_square, size: 18, color: accent),
        );
      case AnswerResult.incorrect:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 2),
          ),
          child: Icon(Iconsax.close_circle, size: 18, color: accent),
        );
      case AnswerResult.skipped:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.6), width: 2),
          ),
          child: Icon(Iconsax.arrow_right_3, size: 18, color: accent),
        );
    }
  }

  Color _resultColor(AnswerResult result) {
    switch (result) {
      case AnswerResult.correct:
        return AppColors.primary;
      case AnswerResult.almostCorrect:
        return AppColors.warning;
      case AnswerResult.incorrect:
        return AppColors.error;
      case AnswerResult.skipped:
        return AppColors.border;
    }
  }

  Widget _buildActionButtons(
    BuildContext context,
    PracticeSessionState session,
  ) {
    final hasIncorrect =
        session.incorrectCount > 0 || session.skippedCount > 0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color:
                isDark ? AppColors.border.withValues(alpha: 0.5) : AppColors.lightBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // もう一度ボタン
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _retryAll(context),
                icon: const Icon(Iconsax.refresh),
                label: const Text('もう一度'),
              ),
            ),
            if (hasIncorrect) ...[
              const SizedBox(width: AppSpacing.sm),
              // 間違えた問題だけボタン
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _retryIncorrect(context),
                  icon: const Icon(Iconsax.refresh),
                  label: const Text('間違えたのみ'),
                ),
              ),
            ],
            const SizedBox(width: AppSpacing.sm),
            // 終了ボタン
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _exitToHome(context),
                icon: const Icon(Iconsax.tick_square),
                label: const Text('終了'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _speakKorean(String text) async {
    await _tts.speak(text);
  }

  Future<void> _retryAll(BuildContext context) async {
    final success =
        await ref.read(practiceSessionProvider.notifier).retry();
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _retryIncorrect(BuildContext context) async {
    final success = await ref
        .read(practiceSessionProvider.notifier)
        .retryIncorrect();
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _exitToHome(BuildContext context) {
    ref.read(practiceSessionProvider.notifier).reset();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

/// スコアアイテム
class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '$count',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
