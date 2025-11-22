import 'package:flutter/material.dart';

/// 選択肢アイテムのデータクラス
class DialogChoice<T> {
  const DialogChoice({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final T value;
  final IconData? icon;
}

/// Dialog/ModalBottomSheetを表示するための共通ヘルパークラス
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
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        // FButtonの利用を想定（プロジェクトの既存パターンを踏襲）
        // 実際のボタンウィジェットは各画面で使われているものに合わせる
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(negativeLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: isDestructive
                  ? TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    )
                  : null,
              child: Text(positiveLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// 選択肢のモーダルボトムシートを表示
  ///
  /// [context] - 表示に使用するBuildContext
  /// [choices] - 選択肢のリスト
  /// [builder] - 各選択肢をウィジェットに変換するビルダー関数
  ///
  /// 戻り値: 選択された値、キャンセルされた場合はnull
  static Future<T?> showChoiceBottomSheet<T>(
    BuildContext context, {
    required List<DialogChoice<T>> choices,
    required Widget Function(BuildContext, DialogChoice<T>, VoidCallback) builder,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: choices.map((choice) {
            return builder(
              context,
              choice,
              () => Navigator.of(context).pop(choice.value),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 選択肢のモーダルボトムシート（シンプル版）
  ///
  /// 選択肢をラベル文字列のリストで指定する簡易版です。
  ///
  /// [context] - 表示に使用するBuildContext
  /// [choices] - 選択肢のリスト（表示ラベル, 値）のペア
  ///
  /// 戻り値: 選択された値、キャンセルされた場合はnull
  static Future<T?> showSimpleChoiceBottomSheet<T>(
    BuildContext context, {
    required List<DialogChoice<T>> choices,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: choices.map((choice) {
            return ListTile(
              leading: choice.icon != null ? Icon(choice.icon) : null,
              title: Text(choice.label),
              onTap: () => Navigator.of(context).pop(choice.value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
