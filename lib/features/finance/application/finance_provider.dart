import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/finance_models.dart';

class FinanceNotifier extends Notifier<FinanceState> {
  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  FinanceState build() {
    Future.microtask(refreshAll);
    return FinanceState.initial();
  }

  /// Reloads all tables from local SQLite and runs `gigakas_income_predictor.onnx`
  /// whenever income history is available.
  Future<void> refreshAll() async {
    final db = ref.read(appDatabaseProvider);
    final onnx = ref.read(onnxAiServiceProvider);

    final txRows = await db.getAllTransactionsOrdered();
    final vault = await db.getOrCreateEmergencyVault();
    final overrideRows = await db.getAllMerchantOverrides();
    final invoiceRows = await db.getAllInvoicesOrdered();
    final features = await db.computeIncomePredictorFeatures();

    final transactions = txRows
        .map(
          (row) => TransactionItem(
            id: row.id,
            title: row.merchantOrClient,
            subtitle: row.subtitle.isNotEmpty ? row.subtitle : row.category,
            amount: row.amount.round(),
            type: row.type == 'INCOME'
                ? TransactionType.income
                : TransactionType.expense,
            category: ExpenseCategory.fromLabel(row.category),
            date: row.transactionDate,
            taxAmount: row.taxAmount.round(),
            emergencyAllocated: row.emergencyFundAllocated.round(),
            isDeductibleBusinessExpense: row.isDeductibleBusinessExpense,
            isPendingSync: row.isPendingSync,
            rawOcrText: row.rawOcrText,
          ),
        )
        .toList();

    final overrides = overrideRows
        .map(
          (row) => MerchantOverrideItem(
            id: row.id,
            normalizedMerchant: row.normalizedMerchant,
            correctedCategory: row.correctedCategory,
            updatedAt: row.updatedAt,
          ),
        )
        .toList();

    final now = DateTime.now();
    final invoices = invoiceRows.map((row) {
      var status = InvoiceStatus.fromStorage(row.status);
      if (status == InvoiceStatus.pending &&
          row.dueDate.isBefore(DateTime(now.year, now.month, now.day))) {
        status = InvoiceStatus.overdue;
      }
      return InvoiceItem(
        id: row.id,
        invoiceNumber: row.invoiceNumber,
        clientName: row.clientName,
        projectTitle: row.projectTitle,
        amount: row.amount.round(),
        dueDate: row.dueDate,
        status: status,
        clientPhone: row.clientPhone,
      );
    }).toList();

    final forecast = features.hasIncomeHistory
        ? await _runIncomeForecast(features)
        : null;
    final history = _buildMonthlyHistory(transactions, forecast);

    state = state.copyWith(
      isLoading: false,
      transactions: transactions,
      monthlyHistory: history,
      invoices: invoices,
      merchantOverrides: overrides,
      emergencyVaultId: vault.id,
      emergencyLockedAmount: vault.lockedAmount.round(),
      emergencyTargetAmount: vault.targetAmount.round(),
      emergencyLockedPercent: vault.allocationPercent,
      onnxReady: onnx.isReady,
      incomeForecast: forecast,
      clearForecast: forecast == null,
    );
  }

  Future<IncomeForecast> _runIncomeForecast(
    IncomePredictorFeatures features,
  ) async {
    final onnx = ref.read(onnxAiServiceProvider);
    final avgRecent = features.averageRecentIncome;
    final nextMonthName = _monthNames[(features.nextMonth - 1).clamp(0, 11)];

    double predicted;
    bool usedOnnx = false;

    try {
      if (!onnx.isReady) {
        await onnx.tryInitialize();
      }
      if (onnx.isReady) {
        predicted = await onnx.predictNextMonthIncome(
          incomeM1: features.incomeM1,
          incomeM2: features.incomeM2,
          incomeM3: features.incomeM3,
          avgExpense3M: features.avgExpense3M,
          activeClients: features.activeClients > 0 ? features.activeClients : 1,
          nextMonth: features.nextMonth,
          incomeCv: features.incomeCv,
        );
        usedOnnx = true;
      } else {
        predicted = _statisticalFallbackIncome(features);
      }
    } catch (_) {
      predicted = _statisticalFallbackIncome(features);
    }

    final predictedInt = predicted.round();
    final avgInt = avgRecent.round();
    final isLeanRisk = avgInt > 0 && predictedInt < (avgInt * 0.85);
    final recPercent =
        isLeanRisk ? 25 : (features.incomeCv > 0.2 ? 20 : 15);
    final recAmount = ((features.incomeM1 > 0 ? features.incomeM1 : avgRecent) *
            (recPercent / 100.0))
        .round();

    return IncomeForecast(
      predictedAmount: predictedInt,
      nextMonthLabel: nextMonthName,
      averageRecentIncome: avgInt,
      recommendedLockPercent: recPercent,
      recommendedLockAmount: recAmount,
      isLeanMonthRisk: isLeanRisk,
      usedOnnxModel: usedOnnx,
      usedColdStartFallback: features.usedColdStartFallback,
      activeClients: features.activeClients,
      incomeCv: features.incomeCv,
    );
  }

  double _statisticalFallbackIncome(IncomePredictorFeatures features) {
    final avg = features.averageRecentIncome;
    if (avg <= 0) return 0;
    final volatilityDiscount = (features.incomeCv * 0.65).clamp(0.05, 0.35);
    return avg * (1.0 - volatilityDiscount);
  }

  List<MonthlyCashFlowPoint> _buildMonthlyHistory(
    List<TransactionItem> transactions,
    IncomeForecast? forecast,
  ) {
    final now = DateTime.now();
    final points = <MonthlyCashFlowPoint>[];

    for (var offset = 4; offset >= 0; offset--) {
      final monthDate = DateTime(now.year, now.month - offset, 1);
      final monthIncome = transactions
          .where(
            (t) =>
                t.type == TransactionType.income &&
                t.date.year == monthDate.year &&
                t.date.month == monthDate.month,
          )
          .fold<int>(0, (sum, t) => sum + t.amount);
      final monthExpense = transactions
          .where(
            (t) =>
                t.type == TransactionType.expense &&
                t.date.year == monthDate.year &&
                t.date.month == monthDate.month,
          )
          .fold<int>(0, (sum, t) => sum + t.amount);

      points.add(
        MonthlyCashFlowPoint(
          monthLabel: _monthNames[monthDate.month - 1],
          income: monthIncome,
          expense: monthExpense,
        ),
      );
    }

    if (forecast != null) {
      final nonZeroExp = points.where((p) => p.expense > 0).toList();
      final avgExp = nonZeroExp.isEmpty
          ? 0
          : (nonZeroExp.fold<int>(0, (s, p) => s + p.expense) /
                  nonZeroExp.length)
              .round();

      points.add(
        MonthlyCashFlowPoint(
          monthLabel: '${forecast.nextMonthLabel}*',
          income: forecast.predictedAmount,
          expense: avgExp,
          isProjectedLean: true,
        ),
      );
    }

    return points;
  }

  /// Adds a transaction to local SQLite and updates EmergencyVault if income allocates savings.
  Future<void> addTransaction({
    required String title,
    required String subtitle,
    required int amount,
    required TransactionType type,
    required ExpenseCategory category,
    DateTime? date,
    bool isDeductibleBusinessExpense = false,
    bool consumeFreeScan = false,
    String? rawOcrText,
    double? customTaxRate,
    int? customEmergencyPercent,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final isIncome = type == TransactionType.income;
    final taxRate = customTaxRate ?? state.taxScheme.rate;
    final emPercent = customEmergencyPercent ?? state.emergencyLockedPercent;

    final taxAllocated = isIncome ? (amount * taxRate) : 0.0;
    final emAllocated = isIncome ? (amount * (emPercent / 100.0)) : 0.0;

    await db.insertTransactionEntry(
      TransactionsCompanion.insert(
        type: isIncome ? 'INCOME' : 'EXPENSE',
        merchantOrClient: title.trim(),
        subtitle: Value(subtitle.trim()),
        category: category.label,
        amount: amount.toDouble(),
        taxAmount: Value(taxAllocated),
        emergencyFundAllocated: Value(emAllocated),
        isDeductibleBusinessExpense: Value(isDeductibleBusinessExpense),
        transactionDate: date ?? DateTime.now(),
        rawOcrText: Value(rawOcrText),
      ),
    );

    if (isIncome && emAllocated > 0) {
      await db.updateEmergencyVault(
        id: state.emergencyVaultId,
        lockedAmount: state.emergencyLockedAmount + emAllocated,
      );
    }

    final nextFreeScans = consumeFreeScan && !state.isProMember
        ? (state.freeScansRemaining - 1).clamp(0, 99)
        : state.freeScansRemaining;

    state = state.copyWith(freeScansRemaining: nextFreeScans);
    await refreshAll();
  }

  /// Saves a scanned receipt and records a MerchantOverride if the user corrected the AI category.
  Future<bool> saveScannedReceipt({
    required String merchant,
    required int amount,
    required DateTime date,
    required ExpenseCategory selectedCategory,
    required String? aiSuggestedCategory,
    required bool isDeductible,
    required String rawOcrText,
  }) async {
    final db = ref.read(appDatabaseProvider);
    var savedOverride = false;

    if (aiSuggestedCategory != null &&
        selectedCategory.label.toLowerCase() !=
            aiSuggestedCategory.trim().toLowerCase()) {
      await db.saveMerchantOverride(merchant, selectedCategory.label);
      savedOverride = true;
    }

    await addTransaction(
      title: merchant,
      subtitle: 'Scan Struk · ${selectedCategory.label}',
      amount: amount,
      type: TransactionType.expense,
      category: selectedCategory,
      date: date,
      isDeductibleBusinessExpense: isDeductible,
      consumeFreeScan: true,
      rawOcrText: rawOcrText,
    );

    return savedOverride;
  }

  Future<void> lockRecommendedToEmergencyVault() async {
    final db = ref.read(appDatabaseProvider);
    final recPercent = state.recommendedEmergencyPercent;
    final recDelta = state.incomeForecast?.recommendedLockAmount ?? 0;

    await db.updateEmergencyVault(
      id: state.emergencyVaultId,
      allocationPercent: recPercent,
      lockedAmount: (state.emergencyLockedAmount + recDelta).toDouble(),
    );
    await refreshAll();
  }

  Future<void> setEmergencyPercent(int percent) async {
    final db = ref.read(appDatabaseProvider);
    final clamped = percent.clamp(5, 40);
    await db.updateEmergencyVault(
      id: state.emergencyVaultId,
      allocationPercent: clamped,
    );
    state = state.copyWith(emergencyLockedPercent: clamped);
  }

  Future<void> setEmergencyTargetAmount(int targetAmount) async {
    if (targetAmount < 0) return;
    final db = ref.read(appDatabaseProvider);
    await db.updateEmergencyVault(
      id: state.emergencyVaultId,
      targetAmount: targetAmount.toDouble(),
    );
    await refreshAll();
  }

  Future<void> depositToEmergencyVault(int amount) async {
    if (amount <= 0) return;
    final db = ref.read(appDatabaseProvider);
    await db.updateEmergencyVault(
      id: state.emergencyVaultId,
      lockedAmount: (state.emergencyLockedAmount + amount).toDouble(),
    );
    await refreshAll();
  }

  void setTaxScheme(TaxScheme scheme) {
    state = state.copyWith(taxScheme: scheme);
  }

  void toggleBiometric(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }

  void activateProSubscription() {
    state = state.copyWith(isProMember: true);
  }

  Future<void> deleteMerchantOverride(int id) async {
    final db = ref.read(appDatabaseProvider);
    await db.deleteMerchantOverride(id);
    await refreshAll();
  }

  Future<void> clearAllLocalData() async {
    final db = ref.read(appDatabaseProvider);
    await db.clearAllLocalData();
    await refreshAll();
  }

  Future<void> addInvoice({
    required String clientName,
    required String projectTitle,
    required int amount,
    required DateTime dueDate,
    String clientPhone = '',
  }) async {
    final db = ref.read(appDatabaseProvider);
    final year = DateTime.now().year;
    final seq = (state.invoices.length + 1).toString().padLeft(3, '0');
    await db.insertInvoiceEntry(
      InvoicesCompanion.insert(
        invoiceNumber: 'INV-$year-$seq',
        clientName: clientName.trim(),
        projectTitle: projectTitle.trim(),
        amount: amount.toDouble(),
        dueDate: dueDate,
        status: 'pending',
        clientPhone: Value(clientPhone.trim()),
      ),
    );
    await refreshAll();
  }

  Future<void> markInvoicePaid(InvoiceItem invoice) async {
    final db = ref.read(appDatabaseProvider);
    await db.updateInvoiceStatus(invoice.id, 'paid');
    await addTransaction(
      title: invoice.clientName,
      subtitle: 'Pelunasan ${invoice.invoiceNumber}',
      amount: invoice.amount,
      type: TransactionType.income,
      category: ExpenseCategory.clientPayment,
    );
  }
}

final financeProvider = NotifierProvider<FinanceNotifier, FinanceState>(
  FinanceNotifier.new,
);
