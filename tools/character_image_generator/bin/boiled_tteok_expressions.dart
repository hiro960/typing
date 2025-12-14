/// 茹でトック（Boiled Tteok）の表情バリエーション
/// 32×32 ドット絵データ
library;

/// カラーパレット（ARGB形式）
class PixelColors {
  PixelColors._();

  static const int T = 0x00000000; // 透明
  static const int K = 0xFF000000; // 黒（輪郭）
  static const int W = 0xFFFFFFFF; // 白（ハイライト）
  static const int M = 0xFFFFF8E7; // 餅クリーム色（メイン）
  static const int m = 0xFFFFEED4; // 餅の影
  static const int C = 0xFFFFCDD2; // ピンク（ほっぺ）
  static const int H = 0xFFFF69B4; // ホットピンク（ハート）
  static const int R = 0xFFFF6B6B; // 赤（舌）
  static const int c = 0xFFFFB6C1; // ライトピンク（照れ）
}

// エイリアス
const int T = PixelColors.T;
const int K = PixelColors.K;
const int W = PixelColors.W;
const int M = PixelColors.M;
const int m = PixelColors.m;
const int C = PixelColors.C;
const int H = PixelColors.H;
const int R = PixelColors.R;
const int c = PixelColors.c;

/// キャラクターデータ
final Map<String, List<List<int>>> boiledTteokExpressions = {
  'boiled_looking_left': lookingLeft,
  'boiled_looking_right': lookingRight,
  'boiled_happy': happy,
  'boiled_sleepy': sleepy,
  'boiled_surprised': surprised,
  'boiled_wink': wink,
  'boiled_worried': worried,
  // 可愛い系
  'boiled_heart_eyes': heartEyes,
  'boiled_teehee': teehee,
  'boiled_shy': shy,
  'boiled_tilted': tilted,
  'boiled_puffed': puffed,
};

/// 日本語名
final Map<String, String> expressionNames = {
  'boiled_looking_left': '茹でトック（左向き）',
  'boiled_looking_right': '茹でトック（右向き）',
  'boiled_happy': '茹でトック（嬉しい）',
  'boiled_sleepy': '茹でトック（眠そう）',
  'boiled_surprised': '茹でトック（驚き）',
  'boiled_wink': '茹でトック（ウインク）',
  'boiled_worried': '茹でトック（困り顔）',
  // 可愛い系
  'boiled_heart_eyes': '茹でトック（ハート目）',
  'boiled_teehee': '茹でトック（てへぺろ）',
  'boiled_shy': '茹でトック（照れ）',
  'boiled_tilted': '茹でトック（首かしげ）',
  'boiled_puffed': '茹でトック（ぷくー）',
};

// ═══════════════════════════════════════════════════════════════════════════
// 左向き（Looking Left）
// 目、ほっぺ、口を左に寄せる
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> lookingLeft = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, M, M, K, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, C, M, M, M, M, C, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, C, M, K, K, M, C, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// 右向き（Looking Right）
// 目、ほっぺ、口を右に寄せる
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> lookingRight = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, W, W, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, W, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, K, M, M, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, C, M, M, M, M, C, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, C, M, K, K, M, C, K, T, T, T, T, T, T, T, T, T, T, T],
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
// 眠そう（Sleepy）
// 目を線にして半開き
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> sleepy = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, K, M, M, K, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// 驚き（Surprised）
// 目を大きく丸く、口も丸く開ける
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> surprised = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, K, M, M, K, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, K, M, M, K, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// ウインク（Wink）
// 片目を閉じる
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> wink = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, K, M, M, M, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// 困り顔（Worried）
// 汗マークを追加
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> worried = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, W, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, W, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, W, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, W, W, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// ハート目（Heart Eyes）
// 目がハート型でラブラブ
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> heartEyes = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, H, M, H, M, M, H, M, H, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, H, H, H, M, M, H, H, H, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, H, M, M, M, M, H, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, K, K, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// てへぺろ（Teehee）
// 片目ウインク＋舌をペロッ
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> teehee = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, K, M, M, K, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, R, R, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, R, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// 照れ（Shy）
// 目を伏せてほっぺを強調
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> shy = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, K, M, M, K, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, C, M, M, C, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, C, C, M, M, C, C, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// 首かしげ（Tilted）
// 体を傾けてきょとん
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> tilted = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, K, M, M, K, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, M, M, M, C, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, C, M, K, K, M, C, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, m, m, M, M, M, M, M, M, m, m, K, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, m, m, m, m, m, m, m, m, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
];

// ═══════════════════════════════════════════════════════════════════════════
// ぷくー（Puffed）
// ほっぺを膨らませて可愛い怒り
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> puffed = [
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
  [T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, K, M, C, C, M, M, M, M, M, C, C, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, K, M, C, C, M, K, K, K, M, C, C, M, K, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
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
// 嬉しそう（Happy）
// 目が ^^ 型（閉じた笑顔の目）
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> happy = [
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, T, K, K, K, K, K, K, T, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, W, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, W, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, M, M, M, M, M, M, M, K, T, T, T, T, T, T, T, T, T, T, T],
  [T, T, T, T, T, T, T, T, T, T, T, K, M, K, M, M, M, M, K, M, K, T, T, T, T, T, T, T, T, T, T, T],
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

