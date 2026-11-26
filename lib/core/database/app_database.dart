import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 1. Tabel Transaksi Utama (Pemasukan & Pengeluaran)
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'INCOME' atau 'EXPENSE'
  TextColumn get merchantOrClient => text()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get emergencyFundAllocated =>
      real().withDefault(const Constant(0.0))();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get rawOcrText => text().nullable()();
}

// 2. Tabel Memori Koreksi User (On-Device Continual Learning)
class MerchantOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get normalizedMerchant => text().unique()();
  TextColumn get correctedCategory => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Transactions, MerchantOverrides])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Simpan atau perbarui aturan koreksi kategori dari pengguna
  Future<void> saveMerchantOverride(String merchant, String category) async {
    final normalized = merchant.trim().toLowerCase();
    await into(merchantOverrides).insertOnConflictUpdate(
      MerchantOverridesCompanion.insert(
        normalizedMerchant: normalized,
        correctedCategory: category,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Cek apakah merchant sudah pernah dikoreksi pengguna sebelumnya
  Future<String?> getOverriddenCategory(String merchant) async {
    final normalized = merchant.trim().toLowerCase();
    final query = select(merchantOverrides)
      ..where((t) => t.normalizedMerchant.equals(normalized));
    final result = await query.getSingleOrNull();
    return result?.correctedCategory;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gigakas_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
