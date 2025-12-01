/// ランキングゲーム用ドット絵キャラクターデータ
///
/// たまごっち風の進化システム:
/// 0: たまご (Egg) - 0点〜
/// 1: ベビー (Baby) - 100点〜
/// 2: こども (Child) - 250点〜
/// 3: ヤング (Young) - 450点〜
/// 4: アダルト (Adult) - 700点〜
/// 5: エンジェル (Angel) - 1,000点〜
///
/// 32×32 ドット絵、サンプル画像参考のかわいいデザイン
library;

/// カラーパレット（サンプル画像参考）
class PixelColors {
  PixelColors._();

  // 透明
  static const int T = 0x00000000;

  // 輪郭・目
  static const int K = 0xFF000000; // 黒（輪郭）
  static const int D = 0xFF1A1A2E; // 濃紺（目の色）
  static const int W = 0xFFFFFFFF; // 白（ハイライト）

  // 顔・肌
  static const int Y = 0xFFFFF9C4; // 薄い黄色（顔）
  static const int y = 0xFFFFEB3B; // 黄色（顔のメイン）
  static const int C = 0xFFFFCDD2; // ピンク（ほっぺ）

  // 耳・羽（水色系）
  static const int B = 0xFF81D4FA; // 水色（メイン）
  static const int b = 0xFF4FC3F7; // 濃い水色
  static const int L = 0xFFB3E5FC; // 薄い水色

  // 体（白・水色ストライプ）
  static const int S = 0xFFE3F2FD; // 薄い青白
  static const int s = 0xFFBBDEFB; // ストライプ用水色

  // 葉っぱ・装飾
  static const int G = 0xFF81C784; // 緑
  static const int g = 0xFF4CAF50; // 濃い緑

  // たまご
  static const int E = 0xFFFFFDE7; // たまごクリーム
  static const int e = 0xFFFFF8E1; // たまご影

  // 光輪（天使用）
  static const int H = 0xFFFFD54F; // 金色
  static const int h = 0xFFFFCA28; // 濃い金色
}

/// ドット絵キャラクターデータ（32×32）
class PixelCharacters {
  PixelCharacters._();

  // エイリアス
  static const int T = PixelColors.T;
  static const int K = PixelColors.K;
  static const int D = PixelColors.D;
  static const int W = PixelColors.W;
  static const int Y = PixelColors.Y;
  static const int y = PixelColors.y;
  static const int C = PixelColors.C;
  static const int B = PixelColors.B;
  static const int b = PixelColors.b;
  static const int L = PixelColors.L;
  static const int S = PixelColors.S;
  static const int s = PixelColors.s;
  static const int G = PixelColors.G;
  static const int g = PixelColors.g;
  static const int E = PixelColors.E;
  static const int e = PixelColors.e;
  static const int H = PixelColors.H;
  static const int h = PixelColors.h;

  /// ピクセルサイズ（32×32）
  static const int pixelGridSize = 32;

  /// 進化レベルからキャラクターデータを取得
  static List<List<int>> getCharacter(int level) {
    return switch (level) {
      0 => egg,
      1 => baby,
      2 => child,
      3 => young,
      4 => adult,
      5 => angel,
      _ => egg,
    };
  }

  /// 進化閾値（難易度別）
  /// 初級: 基準
  /// 中級: 2倍
  /// 上級: 3倍
  static const Map<String, List<int>> evolutionThresholdsByDifficulty = {
    'beginner': [0, 100, 250, 450, 700, 1000],
    'intermediate': [0, 200, 500, 900, 1400, 2000],
    'advanced': [0, 300, 750, 1350, 2100, 3000],
  };

  /// 後方互換性のための閾値（初級と同じ）
  static const List<int> evolutionThresholds = [0, 100, 250, 450, 700, 1000];

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
      0 => 'たまご',
      1 => 'ベビー',
      2 => 'こども',
      3 => 'ヤング',
      4 => 'アダルト',
      5 => 'エンジェル',
      _ => 'たまご',
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 0: たまご (Egg)
  // シンプルな白いたまご、少し模様入り
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> egg = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, K, E, E, E, E, E, E, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, E, E, W, W, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, E, E, W, W, W, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, E, E, W, W, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, B, B, B, B, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, B, B, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, E, E, E, E, E, E, E, E, E, E, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, K, e, e, e, e, e, e, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 1: ベビー (Baby)
  // 孵化直後、丸い体に大きな目、小さな耳の芽
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> baby = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, K, y, y, y, y, y, y, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, K, K, K, K, y, y, K, K, K, K, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, K, K, K, K, y, y, K, K, K, K, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, C, C, y, y, y, y, y, y, y, y, y, y, C, C, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, C, C, y, y, y, K, K, K, K, y, y, y, C, C, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, K, K, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, K, y, y, y, y, y, y, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 2: こども (Child)
  // 小さな耳が生え、体に模様、手足の芽
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> child = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, B, B, T, T, T, T, B, B, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, B, B, B, B, T, T, B, B, B, B, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, B, B, K, K, K, K, B, B, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, K, K, y, y, y, y, y, y, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, K, K, K, K, y, y, K, K, K, K, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, K, K, K, K, y, y, K, K, K, K, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, C, C, y, y, y, y, y, y, y, y, y, y, C, C, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, C, C, y, y, y, K, K, K, K, y, y, y, C, C, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, B, K, y, y, y, y, y, y, y, K, K, y, y, y, y, y, y, y, K, B, T, T, T, T, T, T],
    [T, T, T, T, T, T, B, T, K, S, S, S, S, S, S, S, S, S, S, S, S, S, S, K, T, B, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, s, S, S, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 3: ヤング (Young)
  // 耳が大きくなり、葉っぱ装飾、小さな羽の芽
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> young = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, G, G, G, G, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, B, B, T, g, G, G, g, T, B, B, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, B, B, B, B, T, G, G, T, B, B, B, B, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, B, B, K, K, K, K, K, K, B, B, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, y, y, y, y, y, y, y, y, K, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, K, K, K, K, y, y, K, K, K, K, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, K, K, K, K, y, y, K, K, K, K, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, C, C, y, y, y, y, y, y, y, y, y, y, C, C, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, C, C, y, y, y, K, K, K, K, y, y, y, C, C, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, B, K, y, y, y, y, y, y, y, K, K, y, y, y, y, y, y, y, K, B, T, T, T, T, T, T],
    [T, T, T, T, T, B, B, T, K, S, S, S, S, S, S, S, S, S, S, S, S, S, S, K, T, B, B, T, T, T, T, T],
    [T, T, T, T, T, T, B, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, B, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, s, S, S, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, s, S, S, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 4: アダルト (Adult)
  // 立派な耳、2枚の羽、完全な体
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> adult = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, G, G, G, G, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, B, B, T, g, G, G, g, T, B, B, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, B, b, B, B, T, G, G, T, B, B, b, B, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, B, b, b, B, K, K, K, K, K, K, B, b, b, B, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, B, B, K, y, y, y, y, y, y, K, B, B, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, K, y, y, y, y, y, y, y, y, y, y, K, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, K, K, K, K, y, y, K, K, K, K, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, D, D, K, K, D, D, D, D, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, D, D, W, W, K, K, D, D, W, W, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, K, K, K, K, y, y, K, K, K, K, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, C, C, y, y, y, y, y, y, y, y, y, y, C, C, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, B, B, K, y, C, C, y, y, y, K, K, K, K, y, y, y, C, C, y, K, B, B, T, T, T, T, T],
    [T, T, T, T, B, b, B, K, y, y, y, y, y, y, y, K, K, y, y, y, y, y, y, y, K, B, b, B, T, T, T, T],
    [T, T, T, T, B, B, T, T, K, S, S, S, S, S, S, S, S, S, S, S, S, S, S, K, T, T, B, B, T, T, T, T],
    [T, T, T, T, T, B, T, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, T, B, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, s, S, S, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, s, S, S, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Stage 5: エンジェル (Angel)
  // 4枚の羽、光輪、完全体
  // ═══════════════════════════════════════════════════════════════════════════
  static const List<List<int>> angel = [
    [T, T, T, T, T, T, T, T, T, T, T, T, T, H, H, H, H, H, H, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, H, h, T, T, T, T, h, H, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, H, T, G, G, G, G, T, H, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, B, B, T, g, G, G, g, T, B, B, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, B, b, B, B, T, G, G, T, B, B, b, B, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, B, b, b, B, K, K, K, K, K, K, B, b, b, B, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, B, B, K, y, y, y, y, y, y, K, B, B, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, K, y, y, y, y, y, y, y, y, y, y, K, K, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, K, K, K, y, y, y, y, K, K, K, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, K, D, D, D, D, K, y, y, K, D, D, D, D, K, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, K, D, D, D, D, K, y, y, K, D, D, D, D, K, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, K, D, D, W, W, K, y, y, K, D, D, W, W, K, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, K, y, y, K, K, K, K, y, y, y, y, K, K, K, K, y, y, K, T, T, T, T, T, T, T],
    [T, T, T, T, B, B, T, K, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, y, K, T, B, B, T, T, T, T],
    [T, T, T, B, b, B, T, K, C, C, y, y, y, y, y, y, y, y, y, y, y, y, C, C, K, T, B, b, B, T, T, T],
    [T, T, B, b, b, B, B, K, C, C, y, y, y, K, K, K, K, K, K, y, y, y, C, C, K, B, B, b, b, B, T, T],
    [T, T, B, B, B, T, T, K, y, y, y, y, y, y, y, K, K, y, y, y, y, y, y, y, K, T, T, B, B, B, T, T],
    [T, T, T, B, T, T, T, T, K, S, S, S, S, S, S, S, S, S, S, S, S, S, S, K, T, T, T, B, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, s, S, S, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, S, s, s, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, K, S, S, s, s, S, S, s, s, S, S, s, s, S, S, K, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, K, s, s, S, S, s, s, S, S, s, s, S, K, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
    [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  ];
}
