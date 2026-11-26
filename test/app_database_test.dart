import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giga_kas/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('saves and looks up MerchantOverrides case-insensitively', () async {
    await db.saveMerchantOverride('  Kopi Kenangan  ', 'Client Meeting & F&B');
    final found = await db.getOverriddenCategory('kopi kenangan');
    expect(found, 'Client Meeting & F&B');
  });

  test('applies cold-start fallback when fewer than 3 months of income exist', () async {
    final refDate = DateTime(2026, 11, 26);
    await db.insertTransactionEntry(
      TransactionsCompanion.insert(
        type: 'INCOME',
        merchantOrClient: 'Klien Pertama',
        category: 'Pembayaran Klien',
        amount: 12000000,
        transactionDate: refDate,
      ),
    );

    final features = await db.computeIncomePredictorFeatures(
      referenceDate: refDate,
    );

    expect(features.usedColdStartFallback, isTrue);
    expect(features.incomeM1, 12000000);
    expect(features.incomeM2, 12000000);
    expect(features.incomeM3, 12000000);
    expect(features.activeClients, 1);
    expect(features.nextMonth, 12);
  });

  test('creates and updates EmergencyVault balance', () async {
    final vault = await db.getOrCreateEmergencyVault();
    await db.updateEmergencyVault(
      id: vault.id,
      lockedAmount: 5500000,
      allocationPercent: 25,
    );

    final updated = await db.getOrCreateEmergencyVault();
    expect(updated.lockedAmount, 5500000);
    expect(updated.allocationPercent, 25);
  });
}
