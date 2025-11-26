import 'package:flutter/material.dart';
import 'package:chaletta/ui/utils/toast_helper.dart';

/// SnackBarを表示するための共通ヘルパークラス
///
/// アプリ全体で一貫したSnackBar表示を提供します。
/// 実装はFToastを使用するように変更されました。
class SnackBarHelper {
  /// 基本的なメッセージを表示
  ///
  /// [context] - 表示に使用するBuildContext
  /// [message] - 表示するメッセージ
  /// [duration] - 表示時間（デフォルト: 4秒）
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    // action parameter removed as it was unused and difficult to map to FToast directly without usage context
  }) {
    ToastHelper.show(context, message, duration: duration);
  }

  /// エラーメッセージを表示
  ///
  /// エラーオブジェクトをtoString()して表示します。
  /// [context] - 表示に使用するBuildContext
  /// [error] - エラーオブジェクト
  /// [duration] - 表示時間（デフォルト: 4秒）
  static void showError(
    BuildContext context,
    Object error, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ToastHelper.showError(context, error, duration: duration);
  }

  /// 成功メッセージを表示
  ///
  /// 成功時に特別なスタイルで表示する場合に使用します。
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ToastHelper.showSuccess(context, message, duration: duration);
  }
}
