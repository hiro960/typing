import 'dart:io' show Platform;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/logger.dart';
import '../../data/models/app_version_info.dart';
import '../../data/repositories/app_version_repository.dart';
import '../services/version_checker_service.dart';

part 'app_version_providers.g.dart';

/// AppVersionRepository のプロバイダー
@riverpod
AppVersionRepository appVersionRepository(Ref ref) {
  return AppVersionRepository();
}

/// バージョンチェック状態を管理するNotifier
@Riverpod(keepAlive: true)
class VersionCheckNotifier extends _$VersionCheckNotifier {
  @override
  VersionCheckState build() {
    return const VersionCheckState.initial();
  }

  /// バージョンチェックを実行
  Future<void> checkVersion() async {
    try {
      AppLogger.info('Starting version check', tag: 'VersionCheck');

      // 現在のアプリバージョンを取得
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version; // "1.2.8"

      AppLogger.debug(
        'Current app version: $currentVersion',
        tag: 'VersionCheck',
      );

      // サーバーからバージョン情報を取得
      final repository = ref.read(appVersionRepositoryProvider);
      final versionInfo = await repository.getAppVersion();

      // プラットフォームに応じたバージョン情報を取得
      final platformInfo = versionInfo.forCurrentPlatform(Platform.isIOS);

      AppLogger.debug(
        'Minimum version required: ${platformInfo.minimumVersion}',
        tag: 'VersionCheck',
      );

      // バージョン比較
      final isSatisfied = VersionCheckerService.isVersionSatisfied(
        currentVersion,
        platformInfo.minimumVersion,
      );

      if (isSatisfied) {
        AppLogger.info(
          'Version check passed: $currentVersion >= ${platformInfo.minimumVersion}',
          tag: 'VersionCheck',
        );
        state = const VersionCheckState.initial();
      } else {
        AppLogger.warning(
          'Force update required: $currentVersion < ${platformInfo.minimumVersion}',
          tag: 'VersionCheck',
        );
        state = VersionCheckState.forceUpdate(
          storeUrl: platformInfo.storeUrl,
          minimumVersion: platformInfo.minimumVersion,
          currentVersion: currentVersion,
        );
      }
    } catch (e) {
      AppLogger.error(
        'Version check failed',
        tag: 'VersionCheck',
        error: e,
      );
      // エラー時はアプリを使い続けられるようにする（オフライン対応）
      state = VersionCheckState.failed(e.toString());
    }
  }

  /// 状態をリセット（主にテスト用）
  void reset() {
    state = const VersionCheckState.initial();
  }
}

/// 強制アップデートが必要かどうか
@riverpod
bool needsForceUpdate(Ref ref) {
  return ref.watch(versionCheckProvider).needsForceUpdate;
}

/// ストアURLを取得
@riverpod
String? updateStoreUrl(Ref ref) {
  return ref.watch(versionCheckProvider).storeUrl;
}
