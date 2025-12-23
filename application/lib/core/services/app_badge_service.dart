import 'package:app_badge_plus/app_badge_plus.dart';

import '../utils/logger.dart';

class AppBadgeService {
  static Future<void> updateBadge(int count) async {
    try {
      final isSupported = await AppBadgePlus.isSupported();
      if (!isSupported) return;

      if (count > 0) {
        await AppBadgePlus.updateBadge(count);
      } else {
        await AppBadgePlus.updateBadge(0);
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to update app badge',
        tag: 'AppBadgeService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> removeBadge() async {
    try {
      final isSupported = await AppBadgePlus.isSupported();
      if (!isSupported) return;
      await AppBadgePlus.updateBadge(0);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to remove app badge',
        tag: 'AppBadgeService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
