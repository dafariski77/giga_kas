import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Preprocesses receipt images off the UI thread using [Isolate.run].
abstract final class ImagePreprocessor {
  /// Resizes [sourcePath] to a maximum width of [maxWidth] (default 1024px)
  /// and compresses it as JPEG ([quality] = 85) inside a background isolate.
  static Future<String> preprocessReceiptImage(
    String sourcePath, {
    int maxWidth = 1024,
    int quality = 85,
  }) async {
    final sourceBytes = await File(sourcePath).readAsBytes();

    final compressedBytes = await Isolate.run<Uint8List>(
      () => _resizeAndEncode(sourceBytes, maxWidth: maxWidth, quality: quality),
    );

    final tempDir = await getTemporaryDirectory();
    final outPath = p.join(
      tempDir.path,
      'gigakas_receipt_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await File(outPath).writeAsBytes(compressedBytes, flush: true);
    return outPath;
  }

  static Uint8List _resizeAndEncode(
    Uint8List input, {
    required int maxWidth,
    required int quality,
  }) {
    final decoded = img.decodeImage(input);
    if (decoded == null) return input;

    final oriented = img.bakeOrientation(decoded);
    final resized = oriented.width > maxWidth
        ? img.copyResize(oriented, width: maxWidth)
        : oriented;

    return Uint8List.fromList(img.encodeJpg(resized, quality: quality));
  }
}
