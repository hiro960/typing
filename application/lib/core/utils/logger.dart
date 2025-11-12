import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// アプリ全体で使用するロガー
class AppLogger {
  AppLogger._();

  /// デバッグログ出力
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'DEBUG',
        level: 500,
      );
    }
  }

  /// 情報ログ出力
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'INFO',
        level: 800,
      );
    }
  }

  /// 警告ログ出力
  static void warning(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'WARNING',
      level: 900,
    );
  }

  /// エラーログ出力
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'ERROR',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// APIリクエストログ
  static void apiRequest({
    required String method,
    required String path,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (kDebugMode) {
      final buffer = StringBuffer()
        ..writeln('┌─────────────────────────────────')
        ..writeln('│ API Request')
        ..writeln('├─────────────────────────────────')
        ..writeln('│ Method: $method')
        ..writeln('│ Path: $path');

      if (headers != null && headers.isNotEmpty) {
        buffer.writeln('│ Headers: $headers');
      }

      if (body != null) {
        buffer.writeln('│ Body: $body');
      }

      buffer.write('└─────────────────────────────────');

      developer.log(
        buffer.toString(),
        name: 'API',
        level: 500,
      );
    }
  }

  /// APIレスポンスログ
  static void apiResponse({
    required String method,
    required String path,
    required int statusCode,
    dynamic body,
  }) {
    if (kDebugMode) {
      final buffer = StringBuffer()
        ..writeln('┌─────────────────────────────────')
        ..writeln('│ API Response')
        ..writeln('├─────────────────────────────────')
        ..writeln('│ Method: $method')
        ..writeln('│ Path: $path')
        ..writeln('│ Status: $statusCode');

      if (body != null) {
        buffer.writeln('│ Body: $body');
      }

      buffer.write('└─────────────────────────────────');

      developer.log(
        buffer.toString(),
        name: 'API',
        level: statusCode >= 400 ? 1000 : 500,
      );
    }
  }

  /// Auth関連のログ
  static void auth(String message, {String? detail}) {
    if (kDebugMode) {
      final buffer = StringBuffer()
        ..write('[AUTH] $message');

      if (detail != null) {
        buffer.write(' - $detail');
      }

      developer.log(
        buffer.toString(),
        name: 'AUTH',
        level: 500,
      );
    }
  }
}
