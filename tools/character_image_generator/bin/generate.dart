import 'dart:io';
import 'package:image/image.dart' as img;

/// カラーパレット（ARGB形式）
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

// エイリアス
const int T = PixelColors.T;
const int K = PixelColors.K;
const int W = PixelColors.W;
const int M = PixelColors.M;
const int m = PixelColors.m;
const int R = PixelColors.R;
const int r = PixelColors.r;
const int O = PixelColors.O;
const int C = PixelColors.C;
const int Y = PixelColors.Y;
const int y = PixelColors.y;
const int G = PixelColors.G;
const int g = PixelColors.g;
const int J = PixelColors.J;
const int B = PixelColors.B;
const int P = PixelColors.P;
const int p = PixelColors.p;

/// キャラクターデータ
final Map<String, List<List<int>>> characters = {
  '0_raw_tteok': rawTteok,
  '1_boiled_tteok': boiledTteok,
  '2_sauced_tteok': saucedTteok,
  '3_tteokbokki': tteokbokki,
  '4_cheese_tteokbokki': cheeseTteokbokki,
  '5_king_tteokbokki': kingTteokbokki,
};

/// 日本語名
final Map<String, String> characterNames = {
  '0_raw_tteok': '生トック',
  '1_boiled_tteok': '茹でトック',
  '2_sauced_tteok': 'ソースがけ',
  '3_tteokbokki': 'トッポギ',
  '4_cheese_tteokbokki': 'チーズトッポギ',
  '5_king_tteokbokki': '王様トッポギ',
};

void main() async {
  final outputDir = Directory('output');
  if (!outputDir.existsSync()) {
    outputDir.createSync();
  }

  const pixelSize = 16; // 1ピクセルを16x16に拡大（32x32 → 512x512）
  const gridSize = 32;

  print('トッポギキャラクター画像生成を開始します...\n');

  for (final entry in characters.entries) {
    final filename = entry.key;
    final data = entry.value;
    final japaneseName = characterNames[filename] ?? filename;

    // 画像を作成（拡大サイズ、アルファチャンネル付き）
    final image = img.Image(
      width: gridSize * pixelSize,
      height: gridSize * pixelSize,
      numChannels: 4, // RGBAで透明度をサポート
    );

    // 透明で初期化（全ピクセルを透明に）
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
      }
    }

    // ピクセルデータを描画
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final colorValue = data[y][x];
        if (colorValue == T) continue; // 透明はスキップ

        // ARGB → RGBA に変換
        final a = (colorValue >> 24) & 0xFF;
        final r = (colorValue >> 16) & 0xFF;
        final g = (colorValue >> 8) & 0xFF;
        final b = colorValue & 0xFF;

        final color = img.ColorRgba8(r, g, b, a);

        // 拡大して描画
        for (int py = 0; py < pixelSize; py++) {
          for (int px = 0; px < pixelSize; px++) {
            image.setPixel(x * pixelSize + px, y * pixelSize + py, color);
          }
        }
      }
    }

    // PNGとして保存
    final pngBytes = img.encodePng(image);
    final file = File('output/$filename.png');
    await file.writeAsBytes(pngBytes);

    print('  $japaneseName → output/$filename.png');
  }

  print('\n完了! output/ ディレクトリに6つの画像が生成されました。');
}

// ═══════════════════════════════════════════════════════════════════════════
// Stage 0: 生トック (Raw Tteok)
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> rawTteok = [
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
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> boiledTteok = [
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
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> saucedTteok = [
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
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> tteokbokki = [
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
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> cheeseTteokbokki = [
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
// ═══════════════════════════════════════════════════════════════════════════
const List<List<int>> kingTteokbokki = [
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
