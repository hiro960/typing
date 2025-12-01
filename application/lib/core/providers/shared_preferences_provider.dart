import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferencesの共通プロバイダー
///
/// 複数箇所での getInstance() 呼び出しを防ぎ、
/// 初期化を1回に集約してパフォーマンスを向上させます。
///
/// 使用方法:
/// ```dart
/// // main.dart で初期化
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final prefs = await SharedPreferences.getInstance();
///   runApp(
///     ProviderScope(
///       overrides: [
///         sharedPreferencesProvider.overrideWithValue(AsyncData(prefs)),
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
///
/// // プロバイダー内で使用
/// final prefs = await ref.watch(sharedPreferencesProvider.future);
/// ```
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
