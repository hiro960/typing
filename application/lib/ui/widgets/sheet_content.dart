import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// showFSheet で使用する共通のコンテンツウィジェット
///
/// ボトムシートの選択肢リストを表示するためのウィジェットです。
class SheetContent extends StatelessWidget {
  const SheetContent({
    super.key,
    required this.children,
    this.side = FLayout.btt,
  });

  /// 表示する子ウィジェットのリスト
  final List<Widget> children;

  /// シートの表示方向
  final FLayout side;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: side.vertical
            ? Border.symmetric(
                horizontal: BorderSide(color: context.theme.colors.border),
              )
            : Border.symmetric(
                vertical: BorderSide(color: context.theme.colors.border),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...children, SizedBox(height: 15,)],
        ),
      ),
    );
  }
}

/// シート内の選択肢ボタン
///
/// [SheetContent] 内で使用する選択肢ボタンです。
class SheetOption extends StatelessWidget {
  const SheetOption({
    super.key,
    required this.label,
    required this.onPress,
    this.icon,
    this.style,
  });

  /// ボタンのラベル
  final String label;

  /// タップ時のコールバック
  final VoidCallback onPress;

  /// オプションのアイコン
  final IconData? icon;

  /// ボタンのスタイル（デフォルト: outline）
  final FBaseButtonStyle Function(FButtonStyle)? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: FButton(
        style: style ?? FButtonStyle.outline(),
        onPress: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}
