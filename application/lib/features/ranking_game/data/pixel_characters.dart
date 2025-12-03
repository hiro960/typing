/// ランキングゲーム用ドット絵キャラクターデータ
///
/// トッポギ進化システム:
/// 0: 生トック (Raw Tteok) - 0点〜
/// 1: 茹でトック (Boiled Tteok) - 100点〜
/// 2: ソースがけ (Sauced Tteok) - 250点〜
/// 3: トッポギ (Tteokbokki) - 450点〜
/// 4: チーズトッポギ (Cheese Tteokbokki) - 700点〜
/// 5: 王様トッポギ (King Tteokbokki) - 1,000点〜
///
/// 32×32 ドット絵、かわいい癒し系デザイン
library;

/// カラーパレット
class PixelColors {
  PixelColors._();

  // 透明
  static const int T = 0x00000000;

  // 輪郭・目
  static const int K = 0xFF000000; // 黒（輪郭）
  static const int W = 0xFFFFFFFF; // 白（ハイライト）

  // トック（餅）の色
  static const int M = 0xFFFFF8E7; // 餅クリーム色（メイン）
  static const int m = 0xFFFFEED4; // 餅の影

  // ソース（赤）
  static const int R = 0xFFE53935; // 赤ソース
  static const int r = 0xFFB71C1C; // 濃い赤
  static const int O = 0xFFFF7043; // オレンジ赤（ハイライト）

  // ほっぺ
  static const int C = 0xFFFFCDD2; // ピンク（ほっぺ）

  // チーズ
  static const int Y = 0xFFFFD54F; // チーズ黄色
  static const int y = 0xFFFFCA28; // 濃いチーズ

  // 王冠
  static const int G = 0xFFFFD700; // 金色
  static const int g = 0xFFDAA520; // 濃い金色

  // 宝石（王冠用）
  static const int J = 0xFFE91E63; // ルビー
  static const int B = 0xFF2196F3; // サファイア

  // マント
  static const int P = 0xFF7B1FA2; // 紫（マント）
  static const int p = 0xFF4A148C; // 濃い紫（マント影）
}

/// ドット絵キャラクターデータ（32×32）
class PixelCharacters {
  PixelCharacters._();

  // エイリアス
  static const int T = PixelColors.T;
  static const int K = PixelColors.K;
  static const int W = PixelColors.W;
  static const int M = PixelColors.M;
  static const int m = PixelColors.m;
  static const int R = PixelColors.R;
  static const int r = PixelColors.r;
  static const int O = PixelColors.O;
  static const int C = PixelColors.C;
  static const int Y = PixelColors.Y;
  static const int y = PixelColors.y;
  static const int G = PixelColors.G;
  static const int g = PixelColors.g;
  static const int J = PixelColors.J;
  static const int B = PixelColors.B;
  static const int P = PixelColors.P;
  static const int p = PixelColors.p;

  /// ピクセルサイズ（32×32）
  static const int pixelGridSize = 32;

  /// 進化レベルからキャラクターデータを取得
  static List<List<int>> getCharacter(int level) {
    return switch (level) {
      0 => rawTteok,
      1 => boiledTteok,
      2 => saucedTteok,
      3 => tteokbokki,
      4 => cheeseTteokbokki,
      5 => kingTteokbokki,
      _ => rawTteok,
    };
  }

  /// 進化閾値（難易度別）
  static const Map<String, List<int>> evolutionThresholdsByDifficulty = {
    'beginner': [0, 200, 500, 900, 1400, 2000],
    'intermediate': [0, 300, 750, 1350, 2100, 3000],
    'advanced': [0, 400, 1000, 1800, 3000, 4000],
  };

  /// 後方互換性のための閾値（初級と同じ）
  static const List<int> evolutionThresholds = [0, 200, 500, 900, 1400, 2000];
 //
  /// スコアから進化レベルを計算（難易度別）
  static int getEvolutionLevel(int score, {String difficulty = 'beginner'}) {
    final thresholds = evolutionThresholdsByDifficulty[difficulty] ?? evolutionThresholds;
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (score >= thresholds[i]) return i;
    }
    return 0;
  }

  /// キャラクター名
  static String getCharacterName(int level) {
    return switch (level) {
      0 => '生トック',
      1 => '茹でトック',
      2 => 'ソースがけ',
      3 => 'トッポギ',
      4 => 'チーズトッポギ',
      5 => '王様トッポギ',
      _ => '生トック',
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 0: 生トック (Raw Tteok)
  // シンプルな縦長の白い餅、点の目、手足なし
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> rawTteok = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, m, m, M, M, M, M, m, m, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, m, m, m, m, m, m, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 1: 茹でトック (Boiled Tteok)
  // ぷっくり縦長餅、点目、ほっぺ、口、手足なし
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> boiledTteok = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, m, m, M, M, M, M, m, m, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, m, m, m, m, m, m, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 2: ソースがけ (Sauced Tteok)
  // ソース付き、小さな手の芽
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> saucedTteok = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, M, M, M, M, M, M, M, M, K, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, M, K, M, M, M, M, M, M, K, M, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, K, M, M, M, M, M, M, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, O, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, r, r, R, R, R, R, r, r, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, r, r, r, r, r, r, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 3: トッポギ (Tteokbokki)
  // ソースたっぷり、小さな手
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> tteokbokki = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, O, O, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, M, M, M, M, M, M, M, M, K, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, M, M, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, K, R, R, R, R, R, R, K, K, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, O, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, r, r, R, R, R, R, r, r, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, r, r, r, r, r, r, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 4: チーズトッポギ (Cheese Tteokbokki)
  // チーズ付き、しっかりした手と足
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> cheeseTteokbokki = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, Y, Y, Y, Y, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, Y, Y, Y, Y, Y, Y, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, Y, Y, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, O, O, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, K, K, M, M, M, M, M, M, M, M, K, K, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, M, M, M, K, M, M, M, M, M, M, K, M, M, M, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, K, K, K, R, R, R, R, R, R, K, K, K, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, O, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, r, r, R, R, R, R, r, r, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, r, r, r, r, r, r, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, T, T, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, R, R, K, K, R, R, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, T, T, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 5: 王様トッポギ (King Tteokbokki)
  // 王冠付き、立派な手足
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> kingTteokbokki = [
    [T, T, T, T, T, T, T, T, T, T, T, G, T, T, T, G, T, T, T, G, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, G, G, T, G, G, G, T, G, G, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, G, G, G, G, J, G, G, G, G, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, G, G, G, G, G, G, G, G, G, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, O, O, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, K, K, K, M, M, M, M, M, M, M, M, K, K, K, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, M, M, M, M, K, M, M, M, M, M, M, K, M, M, M, M, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, K, K, K, K, R, R, R, R, R, R, K, K, K, K, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, O, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, R, R, R, R, R, R, R, R, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, r, r, R, R, R, R, r, r, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, r, r, r, r, r, r, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, T, T, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, R, R, K, K, R, R, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, R, R, K, K, R, R, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, T, T, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];
}
