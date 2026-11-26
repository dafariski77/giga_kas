import 'dart:typed_data';

import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

/// Singleton service managing on-device ONNX Runtime sessions for:
/// 1. `gigakas_receipt_pipeline.onnx` (Scikit-Learn TF-IDF + Linear classifier)
/// 2. `gigakas_income_predictor.onnx` (Tabular next-month income predictor)
class OnnxAiService {
  static final OnnxAiService _instance = OnnxAiService._internal();
  factory OnnxAiService() => _instance;
  OnnxAiService._internal();

  /// Subclassable constructor for deterministic unit/widget testing.
  OnnxAiService.forTesting();

  static const String receiptModelAsset =
      'assets/model/gigakas_receipt_pipeline.onnx';
  static const String incomeModelAsset =
      'assets/model/gigakas_income_predictor.onnx';

  OrtSession? _receiptSession;
  OrtSession? _incomeSession;
  bool _isInitialized = false;
  String? _lastInitError;

  final List<String> _categories = const [
    'Internet & Software',
    'Client Meeting & F&B',
    'Transportasi & Perjalanan',
    'Peralatan Kerja & ATK',
    'Lain-lain',
  ];

  bool get isReady => _isInitialized;
  String? get lastInitError => _lastInitError;
  List<String> get categories => _categories;

  /// Memuat kedua model ONNX dari assets ke dalam memori native.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final ort = OnnxRuntime();
      _receiptSession = await ort.createSessionFromAsset(receiptModelAsset);
      _incomeSession = await ort.createSessionFromAsset(incomeModelAsset);
      _isInitialized = true;
      _lastInitError = null;
    } catch (e) {
      _lastInitError = e.toString();
      rethrow;
    }
  }

  /// Safe initializer for app startup (never crashes the app if runtime is unavailable).
  Future<bool> tryInitialize() async {
    try {
      await initialize();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Klasifikasi kategori pengeluaran langsung dari String OCR.
  /// Native input/output tensors are always disposed immediately in `finally`.
  Future<Map<String, dynamic>> predictReceiptCategory(String rawOcrText) async {
    if (!_isInitialized) await initialize();

    final stopwatch = Stopwatch()..start();
    OrtValue? inputTensor;
    Map<String, OrtValue>? outputs;

    try {
      inputTensor = await OrtValue.fromList([rawOcrText], [1, 1]);
      outputs = await _receiptSession!.run({'string_input': inputTensor});

      final labelList = await outputs['output_label']!.asList();
      final probList = await outputs['output_probability']!.asList();

      final dynamic rawLabel = labelList.first;
      final String category;
      final int? idx;
      if (rawLabel is num) {
        idx = rawLabel.toInt();
        category = (idx >= 0 && idx < _categories.length)
            ? _categories[idx]
            : 'Lain-lain';
      } else {
        idx = null;
        category = rawLabel.toString();
      }

      double confidence = 0.0;
      final dynamic firstProb = probList.isNotEmpty ? probList[0] : null;
      if (firstProb is Map) {
        final key = idx ?? rawLabel;
        final dynamic val = firstProb[key] ?? firstProb[key.toString()];
        if (val is num) {
          confidence = val.toDouble();
        } else if (firstProb.values.isNotEmpty) {
          confidence = firstProb.values.whereType<num>().fold<double>(
                0.0,
                (max, v) => v.toDouble() > max ? v.toDouble() : max,
              );
        }
      } else if (firstProb is List && idx != null && idx < firstProb.length) {
        final probs =
            List<double>.from(firstProb.map((e) => (e as num).toDouble()));
        confidence = probs[idx];
      }

      stopwatch.stop();
      return {
        'category': category,
        'confidence': confidence,
        'latencyMs': stopwatch.elapsedMicroseconds / 1000.0,
      };
    } finally {
      // Wajib: Bebaskan memori native C++ tensor segera setelah inferensi
      await inputTensor?.dispose();
      if (outputs != null) {
        for (final out in outputs.values) {
          await out.dispose();
        }
      }
    }
  }

  /// Prediksi pemasukan bulan depan (satuan Rupiah).
  /// Native input/output tensors are always disposed immediately in `finally`.
  Future<double> predictNextMonthIncome({
    required double incomeM1,
    required double incomeM2,
    required double incomeM3,
    required double avgExpense3M,
    required int activeClients,
    required int nextMonth,
    required double incomeCv,
  }) async {
    if (!_isInitialized) await initialize();

    OrtValue? inputTensor;
    Map<String, OrtValue>? outputs;

    try {
      final features = Float32List.fromList([
        incomeM1 / 1e6,
        incomeM2 / 1e6,
        incomeM3 / 1e6,
        avgExpense3M / 1e6,
        activeClients.toDouble(),
        nextMonth.toDouble(),
        incomeCv,
      ]);

      inputTensor = await OrtValue.fromList(features, [1, 7]);
      outputs = await _incomeSession!.run({'float_input': inputTensor});

      final resultList = await outputs.values.first.asList();
      final double predictedJuta = (resultList[0][0] as num).toDouble();

      return (predictedJuta * 1_000_000).clamp(0.0, double.infinity);
    } finally {
      // Wajib: Bebaskan memori native C++ tensor segera setelah inferensi
      await inputTensor?.dispose();
      if (outputs != null) {
        for (final out in outputs.values) {
          await out.dispose();
        }
      }
    }
  }

  Future<void> dispose() async {
    await _receiptSession?.close();
    await _incomeSession?.close();
    _receiptSession = null;
    _incomeSession = null;
    _isInitialized = false;
  }
}
