import 'dart:io';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// 1. Tabel Transaksi Utama (Pemasukan & Pengeluaran)
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'INCOME' atau 'EXPENSE'
  TextColumn get merchantOrClient => text()();
  TextColumn get subtitle => text().withDefault(const Constant(''))();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get emergencyFundAllocated =>
      real().withDefault(const Constant(0.0))();
  BoolColumn get isDeductibleBusinessExpense =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isPendingSync =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get rawOcrText => text().nullable()();
}

/// 2. Tabel Kantong Dana Darurat (Antisipasi Bulan Sepi)
class EmergencyVaults extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label =>
      text().withDefault(const Constant('Dana Darurat Bulan Sepi'))();
  RealColumn get lockedAmount => real().withDefault(const Constant(0.0))();
  RealColumn get targetAmount => real().withDefault(const Constant(0.0))();
  IntColumn get allocationPercent => integer().withDefault(const Constant(15))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 3. Tabel Memori Koreksi User (On-Device Continual Learning)
class MerchantOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get normalizedMerchant => text().unique()();
  TextColumn get correctedCategory => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// 4. Tabel Invoice Offline
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  TextColumn get clientName => text()();
  TextColumn get projectTitle => text()();
  RealColumn get amount => real()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => text()(); // 'paid' | 'pending' | 'overdue'
  TextColumn get clientPhone => text().withDefault(const Constant(''))();
}

/// Aggregated 7-feature vector ready for `gigakas_income_predictor.onnx`.
class IncomePredictorFeatures {
  const IncomePredictorFeatures({
    required this.incomeM1,
    required this.incomeM2,
    required this.incomeM3,
    required this.avgExpense3M,
    required this.activeClients,
    required this.nextMonth,
    required this.incomeCv,
    required this.usedColdStartFallback,
    required this.hasIncomeHistory,
  });

  final double incomeM1;
  final double incomeM2;
  final double incomeM3;
  final double avgExpense3M;
  final int activeClients;
  final int nextMonth;
  final double incomeCv;
  final bool usedColdStartFallback;
  final bool hasIncomeHistory;

  double get averageRecentIncome => (incomeM1 + incomeM2 + incomeM3) / 3.0;
}

@DriftDatabase(
  tables: [Transactions, EmergencyVaults, MerchantOverrides, Invoices],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(emergencyVaults);
            await m.createTable(invoices);
            try {
              await m.addColumn(transactions, transactions.subtitle);
            } catch (_) {}
            try {
              await m.addColumn(
                transactions,
                transactions.isDeductibleBusinessExpense,
              );
            } catch (_) {}
            try {
              await m.addColumn(transactions, transactions.isPendingSync);
            } catch (_) {}
          }
        },
      );

  // ---- Transactions ----

  Future<List<Transaction>> getAllTransactionsOrdered() {
    return (select(transactions)
          ..orderBy([
            (t) => OrderingTerm.desc(t.transactionDate),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .get();
  }

  Future<int> insertTransactionEntry(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }

  Future<void> markAllTransactionsSynced() async {
    await (update(transactions)..where((t) => t.isPendingSync.equals(true)))
        .write(const TransactionsCompanion(isPendingSync: Value(false)));
  }

  // ---- Emergency Vaults ----

  Future<EmergencyVault> getOrCreateEmergencyVault() async {
    final existing = await select(emergencyVaults).get();
    if (existing.isNotEmpty) return existing.first;

    final id = await into(emergencyVaults).insert(
      EmergencyVaultsCompanion.insert(
        lockedAmount: const Value(0.0),
        targetAmount: const Value(0.0),
        allocationPercent: const Value(15),
      ),
    );
    return (select(emergencyVaults)..where((v) => v.id.equals(id))).getSingle();
  }

  Future<void> updateEmergencyVault({
    required int id,
    double? lockedAmount,
    double? targetAmount,
    int? allocationPercent,
  }) async {
    await (update(emergencyVaults)..where((v) => v.id.equals(id))).write(
      EmergencyVaultsCompanion(
        lockedAmount:
            lockedAmount != null ? Value(lockedAmount) : const Value.absent(),
        targetAmount:
            targetAmount != null ? Value(targetAmount) : const Value.absent(),
        allocationPercent: allocationPercent != null
            ? Value(allocationPercent)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ---- Merchant Overrides (On-Device Continual Learning) ----

  Future<void> saveMerchantOverride(String merchant, String category) async {
    final normalized = normalizeMerchantKey(merchant);
    if (normalized.isEmpty) return;
    await into(merchantOverrides).insertOnConflictUpdate(
      MerchantOverridesCompanion.insert(
        normalizedMerchant: normalized,
        correctedCategory: category,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<String?> getOverriddenCategory(String merchant) async {
    final normalized = normalizeMerchantKey(merchant);
    if (normalized.isEmpty) return null;
    final query = select(merchantOverrides)
      ..where((t) => t.normalizedMerchant.equals(normalized));
    final result = await query.getSingleOrNull();
    return result?.correctedCategory;
  }

  Future<List<MerchantOverride>> getAllMerchantOverrides() {
    return (select(merchantOverrides)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<void> deleteMerchantOverride(int id) async {
    await (delete(merchantOverrides)..where((t) => t.id.equals(id))).go();
  }

  static String normalizeMerchantKey(String merchant) {
    return merchant.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  // ---- Invoices ----

  Future<List<Invoice>> getAllInvoicesOrdered() {
    return (select(invoices)..orderBy([(i) => OrderingTerm.desc(i.id)])).get();
  }

  Future<int> insertInvoiceEntry(InvoicesCompanion entry) {
    return into(invoices).insert(entry);
  }

  Future<void> updateInvoiceStatus(int id, String status) async {
    await (update(invoices)..where((i) => i.id.equals(id))).write(
      InvoicesCompanion(status: Value(status)),
    );
  }

  // ---- Reset Local Data ----

  Future<void> clearAllLocalData() async {
    await transaction(() async {
      await delete(transactions).go();
      await delete(invoices).go();
      await delete(merchantOverrides).go();
      await delete(emergencyVaults).go();
    });
  }

  // ---- SQLite Aggregation for ONNX Income Predictor (with Cold-Start Handling) ----

  Future<IncomePredictorFeatures> computeIncomePredictorFeatures({
    DateTime? referenceDate,
  }) async {
    final now = referenceDate ?? DateTime.now();
    final allTx = await getAllTransactionsOrdered();

    final monthKeys = <String>[];
    for (var offset = 0; offset < 3; offset++) {
      final dt = DateTime(now.year, now.month - offset, 1);
      monthKeys.add('${dt.year}-${dt.month}');
    }

    final incomeByMonth = <String, double>{for (final k in monthKeys) k: 0.0};
    final expenseByMonth = <String, double>{for (final k in monthKeys) k: 0.0};
    final activeClientSet = <String>{};

    for (final tx in allTx) {
      final key = '${tx.transactionDate.year}-${tx.transactionDate.month}';
      if (!incomeByMonth.containsKey(key)) continue;

      if (tx.type == 'INCOME') {
        incomeByMonth[key] = (incomeByMonth[key] ?? 0.0) + tx.amount;
        activeClientSet.add(tx.merchantOrClient.trim().toLowerCase());
      } else {
        expenseByMonth[key] = (expenseByMonth[key] ?? 0.0) + tx.amount;
      }
    }

    final rawIncomes = monthKeys.map((k) => incomeByMonth[k] ?? 0.0).toList();
    final nonZeroIncomes = rawIncomes.where((v) => v > 0).toList();
    final hasHistory = nonZeroIncomes.isNotEmpty;
    final usedColdStart = hasHistory && nonZeroIncomes.length < 3;

    double m1 = rawIncomes[0];
    double m2 = rawIncomes[1];
    double m3 = rawIncomes[2];

    if (usedColdStart) {
      final fallbackAvg =
          nonZeroIncomes.reduce((a, b) => a + b) / nonZeroIncomes.length;
      if (m1 <= 0) m1 = fallbackAvg;
      if (m2 <= 0) m2 = fallbackAvg;
      if (m3 <= 0) m3 = fallbackAvg;
    }

    final rawExpenses = monthKeys.map((k) => expenseByMonth[k] ?? 0.0).toList();
    final nonZeroExpenses = rawExpenses.where((v) => v > 0).toList();
    final avgExpense3M = nonZeroExpenses.isEmpty
        ? 0.0
        : nonZeroExpenses.reduce((a, b) => a + b) / nonZeroExpenses.length;

    final mean = (m1 + m2 + m3) / 3.0;
    final variance = (math.pow(m1 - mean, 2) +
            math.pow(m2 - mean, 2) +
            math.pow(m3 - mean, 2)) /
        3.0;
    final cv = mean > 0 ? math.sqrt(variance) / mean : 0.0;

    final nextMonth = now.month == 12 ? 1 : now.month + 1;

    return IncomePredictorFeatures(
      incomeM1: m1,
      incomeM2: m2,
      incomeM3: m3,
      avgExpense3M: avgExpense3M,
      activeClients: activeClientSet.length,
      nextMonth: nextMonth,
      incomeCv: cv,
      usedColdStartFallback: usedColdStart,
      hasIncomeHistory: hasHistory,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gigakas_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
