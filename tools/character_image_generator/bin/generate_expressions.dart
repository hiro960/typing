import 'dart:io';
import 'package:image/image.dart' as img;
import 'boiled_tteok_expressions.dart';

void main() async {
  final outputDir = Directory('output/expressions');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  const pixelSize = 16; // 512x512
  const gridSize = 32;

  print('茹でトック表情バリエーション画像生成を開始します...\n');

  for (final entry in boiledTteokExpressions.entries) {
    final filename = entry.key;
    final data = entry.value;
    final japaneseName = expressionNames[filename] ?? filename;

    // 画像を作成（アルファチャンネル付き）
    final image = img.Image(
      width: gridSize * pixelSize,
      height: gridSize * pixelSize,
      numChannels: 4,
    );

    // 透明で初期化
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        image.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
      }
    }

    // ピクセルデータを描画
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final colorValue = data[y][x];
        if (colorValue == T) continue;

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
    final file = File('output/expressions/$filename.png');
    await file.writeAsBytes(pngBytes);

    print('  $japaneseName → output/expressions/$filename.png');
  }

  print('\n完了! output/expressions/ ディレクトリに5つの画像が生成されました。');
}
