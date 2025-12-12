import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  final files = [
    'assets/launcher_icon/ios_icon.png',
    'assets/launcher_icon/android_icon.png',
  ];

  // #2DBFBF -> R=45, G=191, B=191
  final bgColor = img.ColorRgb8(0x2D, 0xBF, 0xBF);

  for (final path in files) {
    final file = File(path);
    if (!file.existsSync()) {
      print('File not found: $path');
      continue;
    }

    final bytes = await file.readAsBytes();
    final image = img.decodePng(bytes);

    if (image == null) {
      print('Could not decode $path');
      continue;
    }

    // Create a new image with the background color
    final newImage = img.Image(width: image.width, height: image.height);
    img.fill(newImage, color: bgColor);

    // Composite the original image on top
    img.compositeImage(newImage, image);

    // Save the file
    await file.writeAsBytes(img.encodePng(newImage));
    print('Updated $path');
  }
}
