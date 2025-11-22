import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

import '../../features/diary/domain/providers/diary_providers.dart';

class PushNotificationService {
  PushNotificationService(this._ref);

  final WidgetRef _ref;
  static bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
      );
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      final token = await messaging.getToken();
      if (token != null) {
        await _ref.read(diaryRepositoryProvider).updatePushToken(token);
      }
      messaging.onTokenRefresh.listen((token) {
        _ref.read(diaryRepositoryProvider).updatePushToken(token);
      });
      _initialized = true;
    } catch (error) {
      if (kDebugMode) {
        print('Push notification init failed: $error');
      }
    }
  }

  Future<void> clearToken() async {
    try {
      await _ref.read(diaryRepositoryProvider).clearPushToken();
    } catch (_) {}
  }
}
