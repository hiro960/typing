import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Dialog を表示するための共通ヘルパークラス
///
/// アプリ全体で一貫したダイアログ表示を提供します。
class DialogHelper {
  /// 確認ダイアログを表示
  ///
  /// [context] - 表示に使用するBuildContext
  /// [title] - ダイアログのタイトル
  /// [content] - ダイアログの本文
  /// [positiveLabel] - 肯定ボタンのラベル（デフォルト: 'OK'）
  /// [negativeLabel] - 否定ボタンのラベル（デフォルト: 'キャンセル'）
  /// [isDestructive] - 肯定ボタンを破壊的アクション（赤色）にするか
  ///
  /// 戻り値: ユーザーが肯定ボタンを押した場合はtrue、それ以外はfalse
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String positiveLabel = 'OK',
    String negativeLabel = 'キャンセル',
    bool isDestructive = false,
  }) async {
    final result = await showFDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context, style, animation) => FDialog.adaptive(
        style: style,
        animation: animation,
        title: Text(title),
        body: Text(content),
        actions: [
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(context).pop(false),
            child: Text(negativeLabel),
          ),
          FButton(
            style: isDestructive
                ? FButtonStyle.destructive()
                : FButtonStyle.primary(),
            onPress: () => Navigator.of(context).pop(true),
            child: Text(positiveLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
