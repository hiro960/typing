import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 環境変数を管理するクラス
class EnvConfig {
  EnvConfig._();

  /// Auth0のドメイン (例: your-tenant.us.auth0.com)
  static String get auth0Domain => dotenv.env['AUTH0_DOMAIN'] ?? '';

  /// Auth0のクライアントID
  static String get auth0ClientId => dotenv.env['AUTH0_CLIENT_ID'] ?? '';

  /// Auth0のAudience (APIのIdentifier)
  static String get auth0Audience => dotenv.env['AUTH0_AUDIENCE'] ?? '';

  /// バックエンドAPIのベースURL
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://in-eager-tahr.ngrok-free.app';

  /// 現在の環境 (development, staging, production)
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  /// 開発環境かどうか
  static bool get isDevelopment => environment == 'development';

  /// 本番環境かどうか
  static bool get isProduction => environment == 'production';

  /// OpenAI API Key
  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  /// OpenAI API Prompt Id
  static String get openAiPromptId => dotenv.env['OPENAI_PROMPT_ID'] ?? '';

  /// OpenAI API Prompt Version
  static String get openAiPromptVersion => dotenv.env['OPENAI_PROMPT_VERSION'] ?? '';


  /// 環境変数の検証
  /// 必要な環境変数が設定されているかチェック
  static void validate() {
    if (auth0Domain.isEmpty) {
      throw Exception('AUTH0_DOMAIN is not set in .env file');
    }
    if (auth0ClientId.isEmpty) {
      throw Exception('AUTH0_CLIENT_ID is not set in .env file');
    }
    if (apiBaseUrl.isEmpty) {
      throw Exception('API_BASE_URL is not set in .env file');
    }
    if (openAiApiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY is not set in .env file');
    }
    if (openAiPromptId.isEmpty) {
      throw Exception('OPENAI_PROMPT_ID is not set in .env file');
    }
    if (openAiPromptVersion.isEmpty) {
      throw Exception('OPENAI_PROMPT_VERSION is not set in .env file');
    }
  }
}
