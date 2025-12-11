/// APIエンドポイントの定数を管理するクラス
class ApiConstants {
  ApiConstants._();

  // ==================== Auth関連 ====================

  /// ユーザー登録状況確認
  /// GET /api/users/status
  /// 認証必須
  static const String userStatus = '/api/users/status';

  /// ユーザー初回登録
  /// POST /api/users/setup
  /// 認証必須
  static const String userSetup = '/api/users/setup';

  /// ユーザー名重複チェック
  /// GET /api/users/check-username?username=xxx
  /// 認証不要
  static String checkUsername(String username) =>
      '/api/users/check-username?username=$username';

  // ==================== User関連 ====================

  /// 現在のユーザー情報取得
  /// GET /api/users/me
  /// 認証必須
  static const String currentUser = '/api/users/me';

  /// 特定ユーザー情報取得
  /// GET /api/users/:id
  static String userById(String userId) => '/api/users/$userId';

  /// ユーザーの投稿一覧取得
  /// GET /api/users/:id/posts
  static String userPosts(String userId) => '/api/users/$userId/posts';

  /// ユーザーの統計情報取得
  /// GET /api/users/:id/stats
  static String userStats(String userId) => '/api/users/$userId/stats';

  // ==================== Post関連 ====================

  /// 投稿一覧取得
  /// GET /api/posts
  static const String posts = '/api/posts';

  /// 投稿作成
  /// POST /api/posts
  static const String createPost = '/api/posts';

  /// 特定投稿取得
  /// GET /api/posts/:id
  static String postById(String postId) => '/api/posts/$postId';

  /// 投稿更新
  /// PUT /api/posts/:id
  static String updatePost(String postId) => '/api/posts/$postId';

  /// 投稿削除
  /// DELETE /api/posts/:id
  static String deletePost(String postId) => '/api/posts/$postId';

  /// 投稿にいいね
  /// POST /api/posts/:id/like
  static String likePost(String postId) => '/api/posts/$postId/like';

  /// 投稿のいいねを解除
  /// DELETE /api/posts/:id/like
  static String unlikePost(String postId) => '/api/posts/$postId/like';

  // ==================== Comment関連 ====================

  /// コメント一覧取得
  /// GET /api/posts/:id/comments
  static String postComments(String postId) => '/api/posts/$postId/comments';

  /// コメント作成
  /// POST /api/posts/:id/comments
  static String createComment(String postId) => '/api/posts/$postId/comments';

  /// コメント削除
  /// DELETE /api/comments/:id
  static String deleteComment(String commentId) => '/api/comments/$commentId';

  // ==================== Follow関連 ====================

  /// フォロー
  /// POST /api/follows/:userId
  static String followUser(String userId) => '/api/follows/$userId';

  /// フォロー解除
  /// DELETE /api/follows/:userId
  static String unfollowUser(String userId) => '/api/follows/$userId';

  /// フォロワー一覧
  /// GET /api/users/:id/followers
  static String userFollowers(String userId) => '/api/users/$userId/followers';

  /// フォロー中一覧
  /// GET /api/users/:id/following
  static String userFollowing(String userId) => '/api/users/$userId/following';

  // ==================== Lesson関連 ====================

  /// レッスン一覧取得
  /// GET /api/lessons
  static const String lessons = '/api/lessons';

  /// レッスン完了送信
  /// POST /api/lessons/complete
  static const String lessonComplete = '/api/lessons/complete';

  /// レッスン統計取得
  /// GET /api/lessons/stats
  static const String lessonStats = '/api/lessons/stats';

  // ==================== Notification関連 ====================

  /// 通知一覧取得
  /// GET /api/notifications
  static const String notifications = '/api/notifications';

  /// 通知既読マーク
  /// PUT /api/notifications/:id/read
  static String markNotificationRead(String notificationId) =>
      '/api/notifications/$notificationId/read';

  /// 全通知既読マーク
  /// PUT /api/notifications/read-all
  static const String markAllNotificationsRead = '/api/notifications/read-all';

  // ==================== Analysis関連 ====================

  /// 分析ダッシュボード取得
  /// GET /api/analysis/dashboard
  static const String analysisDashboard = '/api/analysis/dashboard';

  // ==================== Ranking Game関連 ====================

  /// ランキングゲーム結果送信
  /// POST /api/ranking-game/results
  static const String rankingGameResults = '/api/ranking-game/results';

  /// ランキング取得
  /// GET /api/ranking-game/ranking
  static const String rankingGameRanking = '/api/ranking-game/ranking';

  /// 自分の統計取得
  /// GET /api/ranking-game/my-stats
  static const String rankingGameMyStats = '/api/ranking-game/my-stats';

  /// 自分の統計取得（軽量版・ホーム画面用）
  /// GET /api/ranking-game/my-stats/summary
  static const String rankingGameMyStatsSummary =
      '/api/ranking-game/my-stats/summary';

  // ==================== Pronunciation Game関連 ====================

  /// 発音ゲーム結果送信
  /// POST /api/pronunciation-game/results
  static const String pronunciationGameResults = '/api/pronunciation-game/results';

  /// 発音ゲームランキング取得
  /// GET /api/pronunciation-game/ranking
  static const String pronunciationGameRanking = '/api/pronunciation-game/ranking';

  /// 発音ゲーム統計取得
  /// GET /api/pronunciation-game/my-stats
  static const String pronunciationGameMyStats = '/api/pronunciation-game/my-stats';

  /// 発音ゲーム統計取得（軽量版・ホーム画面用）
  /// GET /api/pronunciation-game/my-stats/summary
  static const String pronunciationGameMyStatsSummary =
      '/api/pronunciation-game/my-stats/summary';

  // ==================== Stats関連 ====================

  /// 統合統計取得
  /// GET /api/stats/integrated
  static const String integratedStats = '/api/stats/integrated';

  // ==================== Activity関連 ====================

  /// アクティビティ記録
  /// POST /api/activity
  static const String recordActivity = '/api/activity';

  // ==================== ExchangeRate関連 ====================

  /// 為替レート取得
  /// GET /api/exchange-rate
  static const String exchangeRate = '/api/exchange-rate';
}
