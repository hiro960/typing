import 'package:flutter/material.dart';

/// SnackBarを表示するための共通ヘルパークラス
///
/// アプリ全体で一貫したSnackBar表示を提供します。
/// mounted確認とmaybeOfによる安全な実装を含みます。
class SnackBarHelper {
  /// 基本的なSnackBarを表示
  ///
  /// [context] - 表示に使用するBuildContext
  /// [message] - 表示するメッセージ
  /// [duration] - 表示時間（デフォルト: 4秒）
  /// [action] - オプションのアクションボタン
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// エラーメッセージを表示
  ///
  /// エラーオブジェクトをtoString()してSnackBarに表示します。
  /// [context] - 表示に使用するBuildContext
  /// [error] - エラーオブジェクト
  /// [duration] - 表示時間（デフォルト: 4秒）
  static void showError(
    BuildContext context,
    Object error, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(context, error.toString(), duration: duration);
  }

  /// 成功メッセージを表示（将来の拡張用）
  ///
  /// 成功時に特別なスタイルで表示する場合に使用します。
  /// 現在は通常のshowと同じ動作ですが、将来的にスタイルをカスタマイズ可能です。
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, duration: duration);
  }
}
