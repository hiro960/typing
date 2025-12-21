/// プラットフォーム別のバージョン情報
class PlatformVersionInfo {
  final String minimumVersion;
  final String latestVersion;
  final String storeUrl;

  const PlatformVersionInfo({
    required this.minimumVersion,
    required this.latestVersion,
    required this.storeUrl,
  });

  factory PlatformVersionInfo.fromJson(Map<String, dynamic> json) {
    return PlatformVersionInfo(
      minimumVersion: json['minimumVersion'] as String,
      latestVersion: json['latestVersion'] as String,
      storeUrl: json['storeUrl'] as String,
    );
  }
}

/// GET /api/app-version のレスポンス型
class AppVersionResponse {
  final PlatformVersionInfo ios;
  final PlatformVersionInfo android;

  const AppVersionResponse({
    required this.ios,
    required this.android,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionResponse(
      ios: PlatformVersionInfo.fromJson(json['ios'] as Map<String, dynamic>),
      android:
          PlatformVersionInfo.fromJson(json['android'] as Map<String, dynamic>),
    );
  }

  /// 現在のプラットフォームのバージョン情報を取得
  PlatformVersionInfo forCurrentPlatform(bool isIOS) {
    return isIOS ? ios : android;
  }
}

/// バージョンチェック状態
class VersionCheckState {
  final bool needsForceUpdate;
  final String? storeUrl;
  final String? minimumVersion;
  final String? currentVersion;
  final String? errorMessage;

  const VersionCheckState({
    this.needsForceUpdate = false,
    this.storeUrl,
    this.minimumVersion,
    this.currentVersion,
    this.errorMessage,
  });

  const VersionCheckState.initial()
      : needsForceUpdate = false,
        storeUrl = null,
        minimumVersion = null,
        currentVersion = null,
        errorMessage = null;

  const VersionCheckState.forceUpdate({
    required String storeUrl,
    required String minimumVersion,
    required String currentVersion,
  })  : needsForceUpdate = true,
        this.storeUrl = storeUrl,
        this.minimumVersion = minimumVersion,
        this.currentVersion = currentVersion,
        errorMessage = null;

  const VersionCheckState.failed(String error)
      : needsForceUpdate = false,
        storeUrl = null,
        minimumVersion = null,
        currentVersion = null,
        errorMessage = error;
}
