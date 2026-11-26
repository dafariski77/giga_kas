import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../services/onnx_ai_service.dart';
import '../services/receipt_pipeline_service.dart';

/// Provides the local Drift SQLite database (override in tests with in-memory DB).
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Provides the singleton OnnxAiService.
final onnxAiServiceProvider = Provider<OnnxAiService>((ref) {
  return OnnxAiService();
});

/// Provides the Fase 2 Smart Receipt Pipeline (Isolate resize -> ML Kit -> Parser -> Override/ONNX).
final receiptPipelineProvider = Provider<ReceiptPipelineService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final onnx = ref.watch(onnxAiServiceProvider);
  final service = ReceiptPipelineService(database: db, onnxService: onnx);
  ref.onDispose(service.dispose);
  return service;
});
