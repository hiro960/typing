import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

import '../../../features/typing/domain/services/hangul_composer.dart';

/// タイピング画面用のプロンプトカード
/// 問題テキストを表示するための装飾的なカード
class TypingPromptCard extends StatelessWidget {
  const TypingPromptCard({
    super.key,
    required this.targetText,
    this.subText,
    this.completedCharCount,
    this.fontSize = 24,
    this.showCharacterProgress = false,
  });

  /// 表示するメインテキスト（問題文/韓国語）
  final String targetText;

  /// サブテキスト（意味/日本語） - オプション
  final String? subText;

  /// 完了した文字数（進捗表示用） - オプション
  final int? completedCharCount;

  /// フォントサイズ
  final double fontSize;

  /// 文字ごとの進捗表示を有効にするか
  final bool showCharacterProgress;

  /// Jamo進捗から完了文字数を計算するヘルパー
  static int calculateCompletedCharCount(
    String targetText,
    int currentJamoPosition,
  ) {
    final targetChars = targetText.characters.toList();
    int jamoCount = 0;

    for (int i = 0; i < targetChars.length; i++) {
      final jamos = HangulComposer.decomposeSyllable(targetChars[i]);
      jamoCount += jamos.length;

      if (currentJamoPosition < jamoCount) {
        return i;
      }
    }

    return targetChars.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            colors.surfaceContainerHighest.withValues(alpha: 0.2),
            colors.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            blurRadius: 40,
            offset: const Offset(0, 20),
            color: colors.primary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          _buildMainText(theme, colors),
          if (subText != null && subText!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subText!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainText(ThemeData theme, ColorScheme colors) {
    final targetChars = targetText.characters.toList();

    if (showCharacterProgress && completedCharCount != null) {
      // 文字ごとに色分けして表示
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            for (int i = 0; i < targetChars.length; i++)
              TextSpan(
                text: targetChars[i],
                style: TextStyle(
                  color: i < completedCharCount!
                      ? colors.primary
                      : colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize,
                ),
              ),
          ],
        ),
      );
    }

    // シンプルなテキスト表示
    return Text(
      targetText,
      style: TextStyle(
        color: colors.onSurface,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// 入力フィールド用のカード
/// ユーザーの入力を表示するためのカード
class TypingInputCard extends StatelessWidget {
  const TypingInputCard({
    super.key,
    required this.inputText,
    this.placeholder = '',
    this.fontSize = 24,
  });

  /// 入力されたテキスト
  final String inputText;

  /// プレースホルダーテキスト
  final String placeholder;

  /// フォントサイズ
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isEmpty = inputText.isEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          isEmpty ? placeholder : inputText,
          style: TextStyle(
            color: isEmpty ? colors.onSurfaceVariant : colors.onSurface,
            fontWeight: isEmpty ? FontWeight.normal : FontWeight.bold,
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// ヒント表示カード（正解テキスト表示用）
class TypingHintCard extends StatelessWidget {
  const TypingHintCard({
    super.key,
    required this.hintText,
    this.fontSize = 18,
  });

  /// ヒントテキスト
  final String hintText;

  /// フォントサイズ
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        hintText,
        style: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
