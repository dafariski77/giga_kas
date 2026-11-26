import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:giga_kas/app.dart';
import 'package:giga_kas/core/database/app_database.dart';
import 'package:giga_kas/core/providers/core_providers.dart';
import 'package:giga_kas/core/services/onnx_ai_service.dart';
import 'package:giga_kas/core/theme/theme.dart';
import 'package:giga_kas/core/utils/currency_formatter.dart';

class _FakeOnnxAiService extends OnnxAiService {
  _FakeOnnxAiService() : super.forTesting();

  @override
  bool get isReady => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> tryInitialize() async => true;

  @override
  Future<Map<String, dynamic>> predictReceiptCategory(String rawOcrText) async {
    return {
      'category': 'Client Meeting & F&B',
      'confidence': 0.94,
      'latencyMs': 1.4,
    };
  }

  @override
  Future<double> predictNextMonthIncome({
    required double incomeM1,
    required double incomeM2,
    required double incomeM3,
    required double avgExpense3M,
    required int activeClients,
    required int nextMonth,
    required double incomeCv,
  }) async {
    return 9500000;
  }
}

void main() {
  testWidgets('Starts clean with zero dummy data and navigates across all tabs',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          onnxAiServiceProvider.overrideWithValue(_FakeOnnxAiService()),
        ],
        child: const GigaKasApp(),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 150)),
    );
    await tester.pumpAndSettle();

    // Clean production empty state (no seeded dummy data)
    expect(find.text('GigaKas'), findsOneWidget);
    expect(find.text('DANA SIAP PAKAI'), findsOneWidget);
    expect(find.text('Rp 0'), findsWidgets);
    expect(find.text('AI Prediktor Bulan Sepi'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada transaksi tercatat'), findsOneWidget);

    // Navigate to Scan tab (production camera/gallery flow, no sample chips)
    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();
    expect(find.text('Smart Receipt Scanner'), findsOneWidget);
    expect(find.text('Kamera'), findsOneWidget);
    expect(find.text('Galeri'), findsOneWidget);
    expect(find.text('Kopi Kenangan'), findsNothing);

    // Navigate to Brankas tab
    await tester.tap(find.text('Brankas'));
    await tester.pumpAndSettle();
    expect(find.text('Tax Vault & Dana Darurat'), findsOneWidget);
    expect(find.text('Target belum diatur'), findsOneWidget);

    // Navigate to Invoice tab (clean empty state)
    await tester.tap(find.text('Invoice'));
    await tester.pumpAndSettle();
    expect(find.text('Invoice & Tagihan'), findsOneWidget);
    expect(find.text('Belum ada invoice dibuat'), findsOneWidget);

    // Return to Beranda and open Settings
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('ONNX Runtime Offline'), findsOneWidget);
    expect(find.text('Hapus Semua Data Lokal'), findsOneWidget);
  });

  test('CurrencyFormatter formats IDR cleanly', () {
    expect(CurrencyFormatter.formatIdr(14500000), 'Rp 14.500.000');
    expect(CurrencyFormatter.formatCompactIdr(8900000), 'Rp 8.9jt');
    expect(AppSpacing.lg, 16);
    expect(AppRadius.md, 12);
  });
}
