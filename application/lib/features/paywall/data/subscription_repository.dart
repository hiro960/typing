import 'package:chaletta/features/auth/data/models/user_model.dart';
import 'package:chaletta/features/auth/data/services/api_client_service.dart';
import 'package:dio/dio.dart';


/// サブスクリプションの検証とユーザー更新を担うリポジトリ
class SubscriptionRepository {
  SubscriptionRepository({required ApiClientService apiClient})
      : _apiClient = apiClient;

  final ApiClientService _apiClient;

  /// バックエンドに購入情報を送り、検証＆ユーザー更新を行う
  ///
  /// サーバ側で検証後、最新ユーザー情報を返すAPIを想定。
  /// エンドポイントやペイロードはバックエンド実装に合わせて調整してください。
  Future<UserModel> verifyAndActivate({
    required String productId,
    required String platform,
    required String transactionId,
    required String verificationData,
  }) async {
    try {
      final Response response = await _apiClient.dio.post(
        '/api/billing/verify',
        data: {
          'productId': productId,
          'platform': platform,
          'transactionId': transactionId,
          'verificationData': verificationData,
        },
      );

      final data = response.data;
      final userJson = (data is Map<String, dynamic>)
          ? data['user'] as Map<String, dynamic>?
          : null;

      if (userJson == null) {
        throw Exception('検証に失敗しました（ユーザー情報がありません）');
      }

      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      final message = 'verify failed status=$status body=$body error=$e';
      throw Exception(message);
    }
  }
}
