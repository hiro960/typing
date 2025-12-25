import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';

/// URLを検出してクリック可能なリンクとして表示するテキストウィジェット
class LinkableText extends StatelessWidget {
  const LinkableText({
    super.key,
    required this.text,
    this.style,
    this.linkStyle,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  // URLを検出する正規表現
  static final _urlRegex = RegExp(
    r'https?://[^\s\u3000\u3001\u3002\uff0c\uff0e\u300c\u300d\u300e\u300f\u3010\u3011\u3014\u3015\uff08\uff09\uff3b\uff3d\uff5b\uff5d\u201c\u201d\u2018\u2019]+',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = style ?? theme.textTheme.bodyLarge;
    final defaultLinkStyle = linkStyle ??
        defaultStyle?.copyWith(
          color: AppColors.primary,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primary,
        );

    final spans = _buildTextSpans(context, defaultStyle, defaultLinkStyle);

    return Text.rich(
      TextSpan(children: spans),
      style: defaultStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  List<InlineSpan> _buildTextSpans(
    BuildContext context,
    TextStyle? defaultStyle,
    TextStyle? linkStyle,
  ) {
    final spans = <InlineSpan>[];
    final matches = _urlRegex.allMatches(text);

    if (matches.isEmpty) {
      spans.add(TextSpan(text: text, style: defaultStyle));
      return spans;
    }

    int lastEnd = 0;
    for (final match in matches) {
      // URL前のテキスト
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: defaultStyle,
        ));
      }

      // URL部分
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: linkStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () => _showUrlConfirmDialog(context, url),
      ));

      lastEnd = match.end;
    }

    // URL後のテキスト
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: defaultStyle,
      ));
    }

    return spans;
  }

  Future<void> _showUrlConfirmDialog(BuildContext context, String url) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Iconsax.warning_2,
          color: theme.colorScheme.error,
          size: 48,
        ),
        title: const Text('外部サイトへ移動'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '外部サイトへ移動します。\n\n'
              '悪意のあるサイトへ誘導される可能性があります。\n'
              'URLが信頼できるものか確認してください。',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                url,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('開く'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _launchUrl(url);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      // URLを開けなかった場合は何もしない
    }
  }
}
