/// セマンティックバージョン比較サービス
class VersionCheckerService {
  VersionCheckerService._();

  /// バージョン文字列を比較
  /// 戻り値:
  ///   - 負の値: v1 < v2
  ///   - 0: v1 == v2
  ///   - 正の値: v1 > v2
  static int compareVersions(String v1, String v2) {
    final parts1 = _parseVersion(v1);
    final parts2 = _parseVersion(v2);

    for (int i = 0; i < 3; i++) {
      final p1 = parts1.length > i ? parts1[i] : 0;
      final p2 = parts2.length > i ? parts2[i] : 0;

      if (p1 != p2) {
        return p1 - p2;
      }
    }

    return 0;
  }

  /// バージョン文字列をパース
  /// "1.2.3" -> [1, 2, 3]
  /// "1.2.3+4" -> [1, 2, 3] (ビルド番号は無視)
  static List<int> _parseVersion(String version) {
    // ビルド番号を除去 (例: "1.2.3+4" -> "1.2.3")
    final versionOnly = version.split('+').first;

    return versionOnly
        .split('.')
        .map((part) => int.tryParse(part) ?? 0)
        .toList();
  }

  /// 現在のバージョンが最小バージョン以上かチェック
  /// true: アップデート不要
  /// false: 強制アップデート必要
  static bool isVersionSatisfied(String currentVersion, String minimumVersion) {
    return compareVersions(currentVersion, minimumVersion) >= 0;
  }
}
