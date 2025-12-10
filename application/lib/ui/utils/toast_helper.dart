import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ToastHelper {
  /// 基本的なトーストを表示
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    Widget? icon,
    FToastAlignment alignment = FToastAlignment.bottomCenter,
  }) {
    showRawFToast(
      context: context,
      alignment: alignment,
      duration: duration,
      builder: (context, entry) => FToast(
        title: Text(message),
        icon: icon,
      ),
    );
  }

  /// エラーメッセージを表示
  static void showError(
    BuildContext context,
    Object error, {
    Duration duration = const Duration(seconds: 4),
    FToastAlignment alignment = FToastAlignment.bottomCenter,
  }) {
    showRawFToast(
      context: context,
      alignment: alignment,
      duration: duration,
      builder: (context, entry) => FToast(
        title: Text(error.toString()),
        icon: Icon(
          Iconsax.warning_2,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  /// 成功メッセージを表示
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    FToastAlignment alignment = FToastAlignment.bottomCenter,
  }) {
    showRawFToast(
      context: context,
      alignment: alignment,
      duration: duration,
      builder: (context, entry) => FToast(
        title: Text(message),
        icon: Icon(
          Iconsax.tick_circle,
          color: Colors.green,
        ),
      ),
    );
  }
}
