import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/grammar/data/models/grammar_exercise.dart';
import '../../../features/grammar/data/models/grammar_models.dart';
import '../../../features/grammar/domain/providers/grammar_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_error_view.dart';

/// 文法練習問題画面
class GrammarExerciseScreen extends ConsumerStatefulWidget {
  const GrammarExerciseScreen({
    super.key,
    required this.grammarId,
  });

  final String grammarId;

  @override
  ConsumerState<GrammarExerciseScreen> createState() =>
      _GrammarExerciseScreenState();
}

class _GrammarExerciseScreenState
    extends ConsumerState<GrammarExerciseScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _showResult = false;
  bool _isAnswered = false;
  bool _isCorrect = false;
  String? _selectedAnswer;
  final TextEditingController _inputController = TextEditingController();

  // マッチング問題用の状態
  Map<String, String> _matchedPairs = {}; // left -> right のマッピング
  String? _selectedLeft; // 選択中の左側アイテム
  List<String> _shuffledRightItems = []; // シャッフルされた右側アイテム

  @override
  void initState() {
    super.initState();
    // テキスト入力の変更を監視してボタン状態を更新
    _inputController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    super.dispose();
  }

  void _checkAnswer(GrammarExercise exercise) {
    setState(() {
      _isAnswered = true;
      switch (exercise.type) {
        case ExerciseType.fillBlank:
        case ExerciseType.typing:
        case ExerciseType.translation:
          _isCorrect = exercise.checkAnswer(_inputController.text);
          break;
        case ExerciseType.choice:
          final selectedIndex = exercise.choices?.indexOf(_selectedAnswer ?? '');
          _isCorrect = exercise.checkAnswer(selectedIndex);
          break;
        case ExerciseType.matching:
          _isCorrect = exercise.checkAnswer(_matchedPairs);
          break;
      }
      if (_isCorrect) {
        _correctCount++;
      }
    });
  }

  void _nextQuestion(List<GrammarExercise> exercises) {
    if (_currentIndex < exercises.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _isCorrect = false;
        _selectedAnswer = null;
        _inputController.clear();
        // マッチング状態をリセット
        _matchedPairs = {};
        _selectedLeft = null;
        _shuffledRightItems = [];
      });
    } else {
      setState(() {
        _showResult = true;
      });
    }
  }

  void _resetExercise() {
    setState(() {
      _currentIndex = 0;
      _correctCount = 0;
      _showResult = false;
      _isAnswered = false;
      _isCorrect = false;
      _selectedAnswer = null;
      _inputController.clear();
      // マッチング状態をリセット
      _matchedPairs = {};
      _selectedLeft = null;
      _shuffledRightItems = [];
    });
  }

  /// マッチング問題の右側アイテムをシャッフルして取得
  List<String> _getShuffledRightItems(GrammarExercise exercise) {
    if (_shuffledRightItems.isEmpty && exercise.pairs != null) {
      _shuffledRightItems = exercise.pairs!.map((p) => p.right).toList()
        ..shuffle();
    }
    return _shuffledRightItems;
  }

  /// 左側アイテムを選択
  void _onSelectLeft(String left) {
    setState(() {
      if (_selectedLeft == left) {
        _selectedLeft = null;
      } else {
        _selectedLeft = left;
      }
    });
  }

  /// 右側アイテムを選択してマッチング
  void _onSelectRight(String right) {
    if (_selectedLeft == null) return;

    setState(() {
      // 既にマッチされている場合は何もしない
      if (_matchedPairs.containsValue(right)) return;

      _matchedPairs[_selectedLeft!] = right;
      _selectedLeft = null;
    });
  }

  /// マッチを解除
  void _onRemoveMatch(String left) {
    setState(() {
      _matchedPairs.remove(left);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(grammarDetailProvider(widget.grammarId));

    return detailAsync.when(
      data: (grammar) {
        if (grammar.exercises.isEmpty) {
          return AppPageScaffold(
            title: '練習問題',
            showBackButton: true,
            child: const Center(
              child: Text('練習問題がありません'),
            ),
          );
        }

        if (_showResult) {
          return _ResultView(
            correctCount: _correctCount,
            totalCount: grammar.exercises.length,
            onRetry: _resetExercise,
            onBack: () => Navigator.of(context).pop(),
          );
        }

        final exercise = grammar.exercises[_currentIndex];

        return AppPageScaffold(
          title: '練習問題',
          showBackButton: true,
          safeBottom: true,
          child: Column(
            children: [
              // 進捗バー
              _ProgressBar(
                current: _currentIndex + 1,
                total: grammar.exercises.length,
              ),
              const SizedBox(height: AppSpacing.lg),
              // 問題カード
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: _ExerciseCard(
                    exercise: exercise,
                    isAnswered: _isAnswered,
                    isCorrect: _isCorrect,
                    selectedAnswer: _selectedAnswer,
                    inputController: _inputController,
                    onSelectAnswer: (answer) {
                      setState(() {
                        _selectedAnswer = answer;
                      });
                    },
                    // マッチング問題用
                    matchedPairs: _matchedPairs,
                    selectedLeft: _selectedLeft,
                    shuffledRightItems: _getShuffledRightItems(exercise),
                    onSelectLeft: _onSelectLeft,
                    onSelectRight: _onSelectRight,
                    onRemoveMatch: _onRemoveMatch,
                  ),
                ),
              ),
              // ボタン
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child:
                    _isAnswered
                        ? SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                            ),
                            onPressed: () => _nextQuestion(grammar.exercises),
                            child: Text(
                              _currentIndex < grammar.exercises.length - 1
                                  ? '次の問題'
                                  : '結果を見る',
                            ),
                          ),
                        )
                        : SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                            ),
                            onPressed:
                                _canSubmit(exercise)
                                    ? () => _checkAnswer(exercise)
                                    : null,
                            child: const Text('回答する'),
                          ),
                        ),
              ),
            ],
          ),
        );
      },
      loading: () => AppPageScaffold(
        title: '練習問題',
        showBackButton: true,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => AppPageScaffold(
        title: '練習問題',
        showBackButton: true,
        child: PageErrorView(
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(grammarDetailProvider(widget.grammarId)),
        ),
      ),
    );
  }

  bool _canSubmit(GrammarExercise exercise) {
    switch (exercise.type) {
      case ExerciseType.fillBlank:
      case ExerciseType.typing:
      case ExerciseType.translation:
        return _inputController.text.isNotEmpty;
      case ExerciseType.choice:
        return _selectedAnswer != null;
      case ExerciseType.matching:
        // すべてのペアがマッチングされたら提出可能
        final pairsCount = exercise.pairs?.length ?? 0;
        return _matchedPairs.length == pairsCount;
    }
  }
}

/// 進捗バー
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '問題 $current / $total',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(current / total * 100).toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: current / total,
            backgroundColor:
                theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// 問題カード
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.isAnswered,
    required this.isCorrect,
    required this.selectedAnswer,
    required this.inputController,
    required this.onSelectAnswer,
    // マッチング問題用
    required this.matchedPairs,
    required this.selectedLeft,
    required this.shuffledRightItems,
    required this.onSelectLeft,
    required this.onSelectRight,
    required this.onRemoveMatch,
  });

  final GrammarExercise exercise;
  final bool isAnswered;
  final bool isCorrect;
  final String? selectedAnswer;
  final TextEditingController inputController;
  final ValueChanged<String> onSelectAnswer;
  // マッチング問題用
  final Map<String, String> matchedPairs;
  final String? selectedLeft;
  final List<String> shuffledRightItems;
  final ValueChanged<String> onSelectLeft;
  final ValueChanged<String> onSelectRight;
  final ValueChanged<String> onRemoveMatch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 問題タイプラベル
          Row(
            children: [
              Icon(exercise.type.icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                exercise.type.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // 問題文
          Text(
            exercise.type == ExerciseType.translation
                ? (exercise.japanese ?? exercise.question)
                : exercise.question,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // 回答入力部分
          _buildAnswerInput(context),
          // ヒント（未回答時）
          if (!isAnswered && exercise.hint != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.lamp_charge, size: 16, color: Colors.amber),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'ヒント: ${exercise.hint}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // 結果表示（回答後）
          if (isAnswered) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildResultFeedback(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerInput(BuildContext context) {
    final theme = Theme.of(context);

    switch (exercise.type) {
      case ExerciseType.fillBlank:
      case ExerciseType.typing:
      case ExerciseType.translation:
        return TextField(
          controller: inputController,
          enabled: !isAnswered,
          decoration: InputDecoration(
            hintText: exercise.type == ExerciseType.translation
                ? '韓国語を入力'
                : '回答を入力',
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        );

      case ExerciseType.choice:
        return Column(
          children:
              (exercise.choices ?? []).map((choice) {
                final isSelected = choice == selectedAnswer;
                final isCorrectChoice =
                    isAnswered &&
                    exercise.choices != null &&
                    exercise.choices!.indexOf(choice) == exercise.answerIndex;

                Color? backgroundColor;
                Color? borderColor;
                if (isAnswered) {
                  if (isCorrectChoice) {
                    backgroundColor = Colors.green.withValues(alpha: 0.2);
                    borderColor = Colors.green;
                  } else if (isSelected && !isCorrect) {
                    backgroundColor = Colors.red.withValues(alpha: 0.2);
                    borderColor = Colors.red;
                  }
                } else if (isSelected) {
                  backgroundColor = AppColors.primary.withValues(alpha: 0.1);
                  borderColor = AppColors.primary;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: isAnswered ? null : () => onSelectAnswer(choice),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              borderColor ??
                              theme.colorScheme.outline.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(choice)),
                          if (isAnswered && isCorrectChoice)
                            const Icon(Iconsax.tick_circle, color: Colors.green)
                          else if (isAnswered && isSelected && !isCorrect)
                            const Icon(Iconsax.close_circle, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        );

      case ExerciseType.matching:
        return _buildMatchingInput(context, theme);
    }
  }

  Widget _buildMatchingInput(BuildContext context, ThemeData theme) {
    final pairs = exercise.pairs ?? [];
    final leftItems = pairs.map((p) => p.left).toList();

    // 正解マップを作成（回答後の表示用）
    final correctMap = <String, String>{};
    for (final pair in pairs) {
      correctMap[pair.left] = pair.right;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 説明テキスト
        if (!isAnswered)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.info_circle, size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '左側を選択してから、対応する右側を選択してください',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // マッチング表示
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左側（韓国語）
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '韓国語',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...leftItems.map((left) {
                    final isSelected = selectedLeft == left;
                    final isMatched = matchedPairs.containsKey(left);
                    final matchedRight = matchedPairs[left];

                    // 回答後の正解判定
                    bool? isCorrectMatch;
                    if (isAnswered && isMatched) {
                      isCorrectMatch = correctMap[left] == matchedRight;
                    }

                    Color? backgroundColor;
                    Color? borderColor;
                    if (isAnswered) {
                      if (isMatched) {
                        backgroundColor = isCorrectMatch!
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2);
                        borderColor = isCorrectMatch ? Colors.green : Colors.red;
                      }
                    } else if (isSelected) {
                      backgroundColor = AppColors.primary.withValues(alpha: 0.2);
                      borderColor = AppColors.primary;
                    } else if (isMatched) {
                      backgroundColor = Colors.grey.withValues(alpha: 0.1);
                      borderColor = Colors.grey;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: isAnswered
                            ? null
                            : () {
                                if (isMatched) {
                                  onRemoveMatch(left);
                                } else {
                                  onSelectLeft(left);
                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: borderColor ??
                                  theme.colorScheme.outline.withValues(alpha: 0.3),
                              width: isSelected || isMatched ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  left,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isMatched ? FontWeight.bold : null,
                                  ),
                                ),
                              ),
                              if (isMatched && !isAnswered)
                                const Icon(Iconsax.link, size: 16, color: Colors.grey),
                              if (isAnswered && isMatched)
                                Icon(
                                  isCorrectMatch! ? Iconsax.tick_square : Iconsax.close_circle,
                                  size: 16,
                                  color: isCorrectMatch ? Colors.green : Colors.red,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // 右側（日本語）
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '日本語',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...shuffledRightItems.map((right) {
                    final isMatched = matchedPairs.containsValue(right);
                    final matchedLeft = matchedPairs.entries
                        .where((e) => e.value == right)
                        .map((e) => e.key)
                        .firstOrNull;

                    // 回答後の正解判定
                    bool? isCorrectMatch;
                    if (isAnswered && matchedLeft != null) {
                      isCorrectMatch = correctMap[matchedLeft] == right;
                    }

                    Color? backgroundColor;
                    Color? borderColor;
                    if (isAnswered) {
                      if (isMatched) {
                        backgroundColor = isCorrectMatch!
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2);
                        borderColor = isCorrectMatch ? Colors.green : Colors.red;
                      }
                    } else if (isMatched) {
                      backgroundColor = Colors.grey.withValues(alpha: 0.1);
                      borderColor = Colors.grey;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: (isAnswered || isMatched || selectedLeft == null)
                            ? null
                            : () => onSelectRight(right),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: borderColor ??
                                  theme.colorScheme.outline.withValues(alpha: 0.3),
                              width: isMatched ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  right,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isMatched ? FontWeight.bold : null,
                                    color: (!isAnswered && !isMatched && selectedLeft == null)
                                        ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                                        : null,
                                  ),
                                ),
                              ),
                              if (isMatched && !isAnswered)
                                const Icon(Iconsax.link, size: 16, color: Colors.grey),
                              if (isAnswered && isMatched)
                                Icon(
                                  isCorrectMatch! ? Iconsax.tick_square : Iconsax.close_circle,
                                  size: 16,
                                  color: isCorrectMatch ? Colors.green : Colors.red,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        // マッチング済みペアの表示
        if (matchedPairs.isNotEmpty && !isAnswered) ...[
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'マッチング済み (${matchedPairs.length}/${pairs.length})',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...matchedPairs.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Iconsax.arrow_right, size: 14, color: Colors.grey),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  GestureDetector(
                    onTap: () => onRemoveMatch(entry.key),
                    child: const Icon(Iconsax.close_circle, size: 16, color: Colors.red),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildResultFeedback(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color:
            isCorrect
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isCorrect
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Iconsax.tick_circle : Iconsax.close_circle,
                color: isCorrect ? Colors.green : Colors.red,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                isCorrect ? '正解！' : '不正解',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          if (!isCorrect) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '正解: ${exercise.correctAnswer}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (exercise.explanation != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              exercise.explanation!,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

/// 結果画面
class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.correctCount,
    required this.totalCount,
    required this.onRetry,
    required this.onBack,
  });

  final int correctCount;
  final int totalCount;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (correctCount / totalCount * 100).toInt();
    final isPerfect = correctCount == totalCount;
    final isGood = percentage >= 70;

    return AppPageScaffold(
      title: '結果',
      showBackButton: true,
      safeBottom: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // アイコン
            Icon(
              isPerfect
                  ? Iconsax.cup
                  : isGood
                      ? Iconsax.like_1
                      : Iconsax.teacher,
              size: 80,
              color:
                  isPerfect
                      ? Colors.amber
                      : isGood
                          ? Colors.green
                          : AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            // メッセージ
            Text(
              isPerfect
                  ? 'すばらしい！'
                  : isGood
                      ? 'よくできました！'
                      : 'もう少し頑張りましょう',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // スコア
            Text(
              '$correctCount / $totalCount 問正解',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$percentage%',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    isPerfect
                        ? Colors.amber
                        : isGood
                            ? Colors.green
                            : AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // ボタン
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRetry,
                    child: const Text('もう一度'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onBack,
                    child: const Text('戻る'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
