import 'dart:typed_data';

import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

class OnnxAiService {
  static final OnnxAiService _instance = OnnxAiService._internal();
  factory OnnxAiService() => _instance;
  OnnxAiService._internal();

  OrtSession? _receiptSession;
  OrtSession? _incomeSession;
  bool _isInitialized = false;

  final List<String> _categories = [
    'Internet & Software',
    'Client Meeting & F&B',
    'Transportasi & Perjalanan',
    'Peralatan Kerja & ATK',
    'Lain-lain',
  ];

  bool get isReady => _isInitialized;

  /// Memuat kedua model ONNX dari assets ke dalam memori native
  Future<void> initialize() async {
    if (_isInitialized) return;

    final ort = OnnxRuntime();
    _receiptSession = await ort.createSessionFromAsset(
      'assets/models/gigakas_receipt_pipeline.onnx',
    );
    _incomeSession = await ort.createSessionFromAsset(
      'assets/models/gigakas_income_predictor.onnx',
    );

    _isInitialized = true;
  }

  /// Klasifikasi kategori pengeluaran langsung dari String OCR
  Future<Map<String, dynamic>> predictReceiptCategory(String rawOcrText) async {
    if (!_isInitialized) await initialize();

    final inputTensor = await OrtValue.fromList([rawOcrText], [1, 1]);
    final outputs = await _receiptSession!.run({'string_input': inputTensor});

    final labelList = await outputs['output_label']!.asList();
    final probList = await outputs['output_probability']!.asList();

    final int idx = (labelList.first as num).toInt();
    final List<double> probs = List<double>.from(probList[0]);

    // Bebaskan memori native tensor
    await inputTensor.dispose();
    for (final out in outputs.values) {
      await out.dispose();
    }

    return {'category': _categories[idx], 'confidence': probs[idx]};
  }

  /// Prediksi pemasukan bulan depan (satuan Rupiah)
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

    final features = Float32List.fromList([
      incomeM1 / 1e6,
      incomeM2 / 1e6,
      incomeM3 / 1e6,
      avgExpense3M / 1e6,
      activeClients.toDouble(),
      nextMonth.toDouble(),
      incomeCv,
    ]);

    final inputTensor = await OrtValue.fromList(features, [1, 7]);
    final outputs = await _incomeSession!.run({'float_input': inputTensor});

    final resultList = await outputs.values.first.asList();
    final double predictedJuta = (resultList[0][0] as num).toDouble();

    // Bebaskan memori native tensor
    await inputTensor.dispose();
    for (final out in outputs.values) {
      await out.dispose();
    }

    return predictedJuta * 1_000_000;
  }

  Future<void> dispose() async {
    await _receiptSession?.close();
    await _incomeSession?.close();
    _isInitialized = false;
  }
}
