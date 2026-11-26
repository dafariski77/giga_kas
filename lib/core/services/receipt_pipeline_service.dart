import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../database/app_database.dart';
import 'image_preprocessor.dart';
import 'onnx_ai_service.dart';
import 'receipt_parser.dart';

enum ClassificationSource {
  userMemory('Memori Koreksi Lokal'),
  onnxModel('ONNX Scikit-Learn'),
  keywordFallback('Aturan Lokal');

  const ClassificationSource(this.label);
  final String label;
}

class ReceiptScanResult {
  const ReceiptScanResult({
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.categoryLabel,
    required this.confidence,
    required this.source,
    required this.inferenceMs,
    required this.rawOcrText,
    this.processedImagePath,
  });

  final String merchantName;
  final int? amount;
  final DateTime date;
  final String categoryLabel;
  final double confidence;
  final ClassificationSource source;
  final double inferenceMs;
  final String rawOcrText;
  final String? processedImagePath;
}

/// Orchestrates the complete Fase 2 Smart Receipt Scanner pipeline:
/// 1. Background Isolate resize (<= 1024px, JPEG 85%)
/// 2. Offline Google ML Kit OCR
/// 3. Spatial Bounding-Box ReceiptParser
/// 4. Drift `merchant_overrides` memory lookup -> `gigakas_receipt_pipeline.onnx`
class ReceiptPipelineService {
  ReceiptPipelineService({
    required AppDatabase database,
    OnnxAiService? onnxService,
  })  : _db = database,
        _onnx = onnxService ?? OnnxAiService();

  final AppDatabase _db;
  final OnnxAiService _onnx;
  TextRecognizer? _recognizer;

  Future<ReceiptScanResult> processImageFile(String sourceImagePath) async {
    final processedPath =
        await ImagePreprocessor.preprocessReceiptImage(sourceImagePath);

    _recognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(processedPath);
    final recognized = await _recognizer!.processImage(inputImage);

    final parsed = ReceiptParser.parseRecognizedText(recognized);
    return _classifyParsedReceipt(
      parsed,
      processedImagePath: processedPath,
    );
  }

  Future<ReceiptScanResult> processRawText(String rawText) async {
    final parsed = ReceiptParser.parseRawText(rawText);
    return _classifyParsedReceipt(parsed);
  }

  Future<ReceiptScanResult> _classifyParsedReceipt(
    ParsedReceiptData parsed, {
    String? processedImagePath,
  }) async {
    final sw = Stopwatch()..start();

    // 1. Cek kamus koreksi pengguna (On-Device Continual Learning) terlebih dahulu
    final overridden = await _db.getOverriddenCategory(parsed.merchantName);
    if (overridden != null) {
      sw.stop();
      return ReceiptScanResult(
        merchantName: parsed.merchantName,
        amount: parsed.amount,
        date: parsed.date ?? DateTime.now(),
        categoryLabel: overridden,
        confidence: 1.0,
        source: ClassificationSource.userMemory,
        inferenceMs: sw.elapsedMicroseconds / 1000.0,
        rawOcrText: parsed.rawText,
        processedImagePath: processedImagePath,
      );
    }

    // 2. Jalankan inferensi model ONNX Scikit-Learn offline
    try {
      final result = await _onnx.predictReceiptCategory(parsed.rawText);
      final category = (result['category'] as String?) ?? 'Lain-lain';
      final confidence = (result['confidence'] as num?)?.toDouble() ?? 0.0;
      final latency = (result['latencyMs'] as num?)?.toDouble() ??
          (sw.elapsedMicroseconds / 1000.0);

      return ReceiptScanResult(
        merchantName: parsed.merchantName,
        amount: parsed.amount,
        date: parsed.date ?? DateTime.now(),
        categoryLabel: category,
        confidence: confidence,
        source: ClassificationSource.onnxModel,
        inferenceMs: latency,
        rawOcrText: parsed.rawText,
        processedImagePath: processedImagePath,
      );
    } catch (_) {
      // Safe deterministic fallback if ONNX runtime is unavailable (e.g. unit test host)
      sw.stop();
      return ReceiptScanResult(
        merchantName: parsed.merchantName,
        amount: parsed.amount,
        date: parsed.date ?? DateTime.now(),
        categoryLabel: _keywordFallback(parsed.rawText),
        confidence: 0.72,
        source: ClassificationSource.keywordFallback,
        inferenceMs: sw.elapsedMicroseconds / 1000.0,
        rawOcrText: parsed.rawText,
        processedImagePath: processedImagePath,
      );
    }
  }

  String _keywordFallback(String rawText) {
    final lower = rawText.toLowerCase();
    if (RegExp(r'kopi|coffee|cafe|starbucks|kenangan|makan|resto|warung')
        .hasMatch(lower)) {
      return 'Client Meeting & F&B';
    }
    if (RegExp(r'biznet|indihome|telkomsel|kuota|figma|adobe|zoom|cloud|aws|github|chatgpt')
        .hasMatch(lower)) {
      return 'Internet & Software';
    }
    if (RegExp(r'gojek|grab|goride|gocar|pertamina|pertalite|bensin|tol|parkir|kai|garuda')
        .hasMatch(lower)) {
      return 'Transportasi & Perjalanan';
    }
    if (RegExp(r'atk|gramedia|mouse|keyboard|laptop|kertas|tokopedia|monitor')
        .hasMatch(lower)) {
      return 'Peralatan Kerja & ATK';
    }
    return 'Lain-lain';
  }

  Future<void> dispose() async {
    await _recognizer?.close();
    _recognizer = null;
  }
}
