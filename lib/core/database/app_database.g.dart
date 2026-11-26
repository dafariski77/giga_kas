// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantOrClientMeta = const VerificationMeta(
    'merchantOrClient',
  );
  @override
  late final GeneratedColumn<String> merchantOrClient = GeneratedColumn<String>(
    'merchant_or_client',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _emergencyFundAllocatedMeta =
      const VerificationMeta('emergencyFundAllocated');
  @override
  late final GeneratedColumn<double> emergencyFundAllocated =
      GeneratedColumn<double>(
        'emergency_fund_allocated',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _isDeductibleBusinessExpenseMeta =
      const VerificationMeta('isDeductibleBusinessExpense');
  @override
  late final GeneratedColumn<bool> isDeductibleBusinessExpense =
      GeneratedColumn<bool>(
        'is_deductible_business_expense',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_deductible_business_expense" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _isPendingSyncMeta = const VerificationMeta(
    'isPendingSync',
  );
  @override
  late final GeneratedColumn<bool> isPendingSync = GeneratedColumn<bool>(
    'is_pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _rawOcrTextMeta = const VerificationMeta(
    'rawOcrText',
  );
  @override
  late final GeneratedColumn<String> rawOcrText = GeneratedColumn<String>(
    'raw_ocr_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    merchantOrClient,
    subtitle,
    category,
    amount,
    taxAmount,
    emergencyFundAllocated,
    isDeductibleBusinessExpense,
    isPendingSync,
    transactionDate,
    rawOcrText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('merchant_or_client')) {
      context.handle(
        _merchantOrClientMeta,
        merchantOrClient.isAcceptableOrUnknown(
          data['merchant_or_client']!,
          _merchantOrClientMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantOrClientMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    }
    if (data.containsKey('emergency_fund_allocated')) {
      context.handle(
        _emergencyFundAllocatedMeta,
        emergencyFundAllocated.isAcceptableOrUnknown(
          data['emergency_fund_allocated']!,
          _emergencyFundAllocatedMeta,
        ),
      );
    }
    if (data.containsKey('is_deductible_business_expense')) {
      context.handle(
        _isDeductibleBusinessExpenseMeta,
        isDeductibleBusinessExpense.isAcceptableOrUnknown(
          data['is_deductible_business_expense']!,
          _isDeductibleBusinessExpenseMeta,
        ),
      );
    }
    if (data.containsKey('is_pending_sync')) {
      context.handle(
        _isPendingSyncMeta,
        isPendingSync.isAcceptableOrUnknown(
          data['is_pending_sync']!,
          _isPendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('raw_ocr_text')) {
      context.handle(
        _rawOcrTextMeta,
        rawOcrText.isAcceptableOrUnknown(
          data['raw_ocr_text']!,
          _rawOcrTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      merchantOrClient: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_or_client'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      )!,
      emergencyFundAllocated: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}emergency_fund_allocated'],
      )!,
      isDeductibleBusinessExpense: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deductible_business_expense'],
      )!,
      isPendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pending_sync'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      rawOcrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_ocr_text'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String type;
  final String merchantOrClient;
  final String subtitle;
  final String category;
  final double amount;
  final double taxAmount;
  final double emergencyFundAllocated;
  final bool isDeductibleBusinessExpense;
  final bool isPendingSync;
  final DateTime transactionDate;
  final String? rawOcrText;
  const Transaction({
    required this.id,
    required this.type,
    required this.merchantOrClient,
    required this.subtitle,
    required this.category,
    required this.amount,
    required this.taxAmount,
    required this.emergencyFundAllocated,
    required this.isDeductibleBusinessExpense,
    required this.isPendingSync,
    required this.transactionDate,
    this.rawOcrText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['merchant_or_client'] = Variable<String>(merchantOrClient);
    map['subtitle'] = Variable<String>(subtitle);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['emergency_fund_allocated'] = Variable<double>(emergencyFundAllocated);
    map['is_deductible_business_expense'] = Variable<bool>(
      isDeductibleBusinessExpense,
    );
    map['is_pending_sync'] = Variable<bool>(isPendingSync);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || rawOcrText != null) {
      map['raw_ocr_text'] = Variable<String>(rawOcrText);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      merchantOrClient: Value(merchantOrClient),
      subtitle: Value(subtitle),
      category: Value(category),
      amount: Value(amount),
      taxAmount: Value(taxAmount),
      emergencyFundAllocated: Value(emergencyFundAllocated),
      isDeductibleBusinessExpense: Value(isDeductibleBusinessExpense),
      isPendingSync: Value(isPendingSync),
      transactionDate: Value(transactionDate),
      rawOcrText: rawOcrText == null && nullToAbsent
          ? const Value.absent()
          : Value(rawOcrText),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      merchantOrClient: serializer.fromJson<String>(json['merchantOrClient']),
      subtitle: serializer.fromJson<String>(json['subtitle']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      emergencyFundAllocated: serializer.fromJson<double>(
        json['emergencyFundAllocated'],
      ),
      isDeductibleBusinessExpense: serializer.fromJson<bool>(
        json['isDeductibleBusinessExpense'],
      ),
      isPendingSync: serializer.fromJson<bool>(json['isPendingSync']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      rawOcrText: serializer.fromJson<String?>(json['rawOcrText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'merchantOrClient': serializer.toJson<String>(merchantOrClient),
      'subtitle': serializer.toJson<String>(subtitle),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'emergencyFundAllocated': serializer.toJson<double>(
        emergencyFundAllocated,
      ),
      'isDeductibleBusinessExpense': serializer.toJson<bool>(
        isDeductibleBusinessExpense,
      ),
      'isPendingSync': serializer.toJson<bool>(isPendingSync),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'rawOcrText': serializer.toJson<String?>(rawOcrText),
    };
  }

  Transaction copyWith({
    int? id,
    String? type,
    String? merchantOrClient,
    String? subtitle,
    String? category,
    double? amount,
    double? taxAmount,
    double? emergencyFundAllocated,
    bool? isDeductibleBusinessExpense,
    bool? isPendingSync,
    DateTime? transactionDate,
    Value<String?> rawOcrText = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    type: type ?? this.type,
    merchantOrClient: merchantOrClient ?? this.merchantOrClient,
    subtitle: subtitle ?? this.subtitle,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    taxAmount: taxAmount ?? this.taxAmount,
    emergencyFundAllocated:
        emergencyFundAllocated ?? this.emergencyFundAllocated,
    isDeductibleBusinessExpense:
        isDeductibleBusinessExpense ?? this.isDeductibleBusinessExpense,
    isPendingSync: isPendingSync ?? this.isPendingSync,
    transactionDate: transactionDate ?? this.transactionDate,
    rawOcrText: rawOcrText.present ? rawOcrText.value : this.rawOcrText,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      merchantOrClient: data.merchantOrClient.present
          ? data.merchantOrClient.value
          : this.merchantOrClient,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      emergencyFundAllocated: data.emergencyFundAllocated.present
          ? data.emergencyFundAllocated.value
          : this.emergencyFundAllocated,
      isDeductibleBusinessExpense: data.isDeductibleBusinessExpense.present
          ? data.isDeductibleBusinessExpense.value
          : this.isDeductibleBusinessExpense,
      isPendingSync: data.isPendingSync.present
          ? data.isPendingSync.value
          : this.isPendingSync,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      rawOcrText: data.rawOcrText.present
          ? data.rawOcrText.value
          : this.rawOcrText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('merchantOrClient: $merchantOrClient, ')
          ..write('subtitle: $subtitle, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('emergencyFundAllocated: $emergencyFundAllocated, ')
          ..write('isDeductibleBusinessExpense: $isDeductibleBusinessExpense, ')
          ..write('isPendingSync: $isPendingSync, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('rawOcrText: $rawOcrText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    merchantOrClient,
    subtitle,
    category,
    amount,
    taxAmount,
    emergencyFundAllocated,
    isDeductibleBusinessExpense,
    isPendingSync,
    transactionDate,
    rawOcrText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.type == this.type &&
          other.merchantOrClient == this.merchantOrClient &&
          other.subtitle == this.subtitle &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.taxAmount == this.taxAmount &&
          other.emergencyFundAllocated == this.emergencyFundAllocated &&
          other.isDeductibleBusinessExpense ==
              this.isDeductibleBusinessExpense &&
          other.isPendingSync == this.isPendingSync &&
          other.transactionDate == this.transactionDate &&
          other.rawOcrText == this.rawOcrText);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> merchantOrClient;
  final Value<String> subtitle;
  final Value<String> category;
  final Value<double> amount;
  final Value<double> taxAmount;
  final Value<double> emergencyFundAllocated;
  final Value<bool> isDeductibleBusinessExpense;
  final Value<bool> isPendingSync;
  final Value<DateTime> transactionDate;
  final Value<String?> rawOcrText;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.merchantOrClient = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.emergencyFundAllocated = const Value.absent(),
    this.isDeductibleBusinessExpense = const Value.absent(),
    this.isPendingSync = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.rawOcrText = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String merchantOrClient,
    this.subtitle = const Value.absent(),
    required String category,
    required double amount,
    this.taxAmount = const Value.absent(),
    this.emergencyFundAllocated = const Value.absent(),
    this.isDeductibleBusinessExpense = const Value.absent(),
    this.isPendingSync = const Value.absent(),
    required DateTime transactionDate,
    this.rawOcrText = const Value.absent(),
  }) : type = Value(type),
       merchantOrClient = Value(merchantOrClient),
       category = Value(category),
       amount = Value(amount),
       transactionDate = Value(transactionDate);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? merchantOrClient,
    Expression<String>? subtitle,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<double>? taxAmount,
    Expression<double>? emergencyFundAllocated,
    Expression<bool>? isDeductibleBusinessExpense,
    Expression<bool>? isPendingSync,
    Expression<DateTime>? transactionDate,
    Expression<String>? rawOcrText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (merchantOrClient != null) 'merchant_or_client': merchantOrClient,
      if (subtitle != null) 'subtitle': subtitle,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (emergencyFundAllocated != null)
        'emergency_fund_allocated': emergencyFundAllocated,
      if (isDeductibleBusinessExpense != null)
        'is_deductible_business_expense': isDeductibleBusinessExpense,
      if (isPendingSync != null) 'is_pending_sync': isPendingSync,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (rawOcrText != null) 'raw_ocr_text': rawOcrText,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? merchantOrClient,
    Value<String>? subtitle,
    Value<String>? category,
    Value<double>? amount,
    Value<double>? taxAmount,
    Value<double>? emergencyFundAllocated,
    Value<bool>? isDeductibleBusinessExpense,
    Value<bool>? isPendingSync,
    Value<DateTime>? transactionDate,
    Value<String?>? rawOcrText,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      merchantOrClient: merchantOrClient ?? this.merchantOrClient,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      taxAmount: taxAmount ?? this.taxAmount,
      emergencyFundAllocated:
          emergencyFundAllocated ?? this.emergencyFundAllocated,
      isDeductibleBusinessExpense:
          isDeductibleBusinessExpense ?? this.isDeductibleBusinessExpense,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      transactionDate: transactionDate ?? this.transactionDate,
      rawOcrText: rawOcrText ?? this.rawOcrText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (merchantOrClient.present) {
      map['merchant_or_client'] = Variable<String>(merchantOrClient.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (emergencyFundAllocated.present) {
      map['emergency_fund_allocated'] = Variable<double>(
        emergencyFundAllocated.value,
      );
    }
    if (isDeductibleBusinessExpense.present) {
      map['is_deductible_business_expense'] = Variable<bool>(
        isDeductibleBusinessExpense.value,
      );
    }
    if (isPendingSync.present) {
      map['is_pending_sync'] = Variable<bool>(isPendingSync.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (rawOcrText.present) {
      map['raw_ocr_text'] = Variable<String>(rawOcrText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('merchantOrClient: $merchantOrClient, ')
          ..write('subtitle: $subtitle, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('emergencyFundAllocated: $emergencyFundAllocated, ')
          ..write('isDeductibleBusinessExpense: $isDeductibleBusinessExpense, ')
          ..write('isPendingSync: $isPendingSync, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('rawOcrText: $rawOcrText')
          ..write(')'))
        .toString();
  }
}

class $EmergencyVaultsTable extends EmergencyVaults
    with TableInfo<$EmergencyVaultsTable, EmergencyVault> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyVaultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Dana Darurat Bulan Sepi'),
  );
  static const VerificationMeta _lockedAmountMeta = const VerificationMeta(
    'lockedAmount',
  );
  @override
  late final GeneratedColumn<double> lockedAmount = GeneratedColumn<double>(
    'locked_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _allocationPercentMeta = const VerificationMeta(
    'allocationPercent',
  );
  @override
  late final GeneratedColumn<int> allocationPercent = GeneratedColumn<int>(
    'allocation_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    lockedAmount,
    targetAmount,
    allocationPercent,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_vaults';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyVault> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('locked_amount')) {
      context.handle(
        _lockedAmountMeta,
        lockedAmount.isAcceptableOrUnknown(
          data['locked_amount']!,
          _lockedAmountMeta,
        ),
      );
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    }
    if (data.containsKey('allocation_percent')) {
      context.handle(
        _allocationPercentMeta,
        allocationPercent.isAcceptableOrUnknown(
          data['allocation_percent']!,
          _allocationPercentMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyVault map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyVault(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      lockedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}locked_amount'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_amount'],
      )!,
      allocationPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocation_percent'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmergencyVaultsTable createAlias(String alias) {
    return $EmergencyVaultsTable(attachedDatabase, alias);
  }
}

class EmergencyVault extends DataClass implements Insertable<EmergencyVault> {
  final int id;
  final String label;
  final double lockedAmount;
  final double targetAmount;
  final int allocationPercent;
  final DateTime updatedAt;
  const EmergencyVault({
    required this.id,
    required this.label,
    required this.lockedAmount,
    required this.targetAmount,
    required this.allocationPercent,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['locked_amount'] = Variable<double>(lockedAmount);
    map['target_amount'] = Variable<double>(targetAmount);
    map['allocation_percent'] = Variable<int>(allocationPercent);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmergencyVaultsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyVaultsCompanion(
      id: Value(id),
      label: Value(label),
      lockedAmount: Value(lockedAmount),
      targetAmount: Value(targetAmount),
      allocationPercent: Value(allocationPercent),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmergencyVault.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyVault(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      lockedAmount: serializer.fromJson<double>(json['lockedAmount']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      allocationPercent: serializer.fromJson<int>(json['allocationPercent']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'lockedAmount': serializer.toJson<double>(lockedAmount),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'allocationPercent': serializer.toJson<int>(allocationPercent),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EmergencyVault copyWith({
    int? id,
    String? label,
    double? lockedAmount,
    double? targetAmount,
    int? allocationPercent,
    DateTime? updatedAt,
  }) => EmergencyVault(
    id: id ?? this.id,
    label: label ?? this.label,
    lockedAmount: lockedAmount ?? this.lockedAmount,
    targetAmount: targetAmount ?? this.targetAmount,
    allocationPercent: allocationPercent ?? this.allocationPercent,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmergencyVault copyWithCompanion(EmergencyVaultsCompanion data) {
    return EmergencyVault(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      lockedAmount: data.lockedAmount.present
          ? data.lockedAmount.value
          : this.lockedAmount,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      allocationPercent: data.allocationPercent.present
          ? data.allocationPercent.value
          : this.allocationPercent,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyVault(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('lockedAmount: $lockedAmount, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('allocationPercent: $allocationPercent, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    lockedAmount,
    targetAmount,
    allocationPercent,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyVault &&
          other.id == this.id &&
          other.label == this.label &&
          other.lockedAmount == this.lockedAmount &&
          other.targetAmount == this.targetAmount &&
          other.allocationPercent == this.allocationPercent &&
          other.updatedAt == this.updatedAt);
}

class EmergencyVaultsCompanion extends UpdateCompanion<EmergencyVault> {
  final Value<int> id;
  final Value<String> label;
  final Value<double> lockedAmount;
  final Value<double> targetAmount;
  final Value<int> allocationPercent;
  final Value<DateTime> updatedAt;
  const EmergencyVaultsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.lockedAmount = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.allocationPercent = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmergencyVaultsCompanion.insert({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.lockedAmount = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.allocationPercent = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<EmergencyVault> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<double>? lockedAmount,
    Expression<double>? targetAmount,
    Expression<int>? allocationPercent,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (lockedAmount != null) 'locked_amount': lockedAmount,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (allocationPercent != null) 'allocation_percent': allocationPercent,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmergencyVaultsCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<double>? lockedAmount,
    Value<double>? targetAmount,
    Value<int>? allocationPercent,
    Value<DateTime>? updatedAt,
  }) {
    return EmergencyVaultsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      lockedAmount: lockedAmount ?? this.lockedAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      allocationPercent: allocationPercent ?? this.allocationPercent,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (lockedAmount.present) {
      map['locked_amount'] = Variable<double>(lockedAmount.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (allocationPercent.present) {
      map['allocation_percent'] = Variable<int>(allocationPercent.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyVaultsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('lockedAmount: $lockedAmount, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('allocationPercent: $allocationPercent, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MerchantOverridesTable extends MerchantOverrides
    with TableInfo<$MerchantOverridesTable, MerchantOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _normalizedMerchantMeta =
      const VerificationMeta('normalizedMerchant');
  @override
  late final GeneratedColumn<String> normalizedMerchant =
      GeneratedColumn<String>(
        'normalized_merchant',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      );
  static const VerificationMeta _correctedCategoryMeta = const VerificationMeta(
    'correctedCategory',
  );
  @override
  late final GeneratedColumn<String> correctedCategory =
      GeneratedColumn<String>(
        'corrected_category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    normalizedMerchant,
    correctedCategory,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('normalized_merchant')) {
      context.handle(
        _normalizedMerchantMeta,
        normalizedMerchant.isAcceptableOrUnknown(
          data['normalized_merchant']!,
          _normalizedMerchantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedMerchantMeta);
    }
    if (data.containsKey('corrected_category')) {
      context.handle(
        _correctedCategoryMeta,
        correctedCategory.isAcceptableOrUnknown(
          data['corrected_category']!,
          _correctedCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctedCategoryMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MerchantOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      normalizedMerchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_merchant'],
      )!,
      correctedCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}corrected_category'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MerchantOverridesTable createAlias(String alias) {
    return $MerchantOverridesTable(attachedDatabase, alias);
  }
}

class MerchantOverride extends DataClass
    implements Insertable<MerchantOverride> {
  final int id;
  final String normalizedMerchant;
  final String correctedCategory;
  final DateTime updatedAt;
  const MerchantOverride({
    required this.id,
    required this.normalizedMerchant,
    required this.correctedCategory,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['normalized_merchant'] = Variable<String>(normalizedMerchant);
    map['corrected_category'] = Variable<String>(correctedCategory);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MerchantOverridesCompanion toCompanion(bool nullToAbsent) {
    return MerchantOverridesCompanion(
      id: Value(id),
      normalizedMerchant: Value(normalizedMerchant),
      correctedCategory: Value(correctedCategory),
      updatedAt: Value(updatedAt),
    );
  }

  factory MerchantOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantOverride(
      id: serializer.fromJson<int>(json['id']),
      normalizedMerchant: serializer.fromJson<String>(
        json['normalizedMerchant'],
      ),
      correctedCategory: serializer.fromJson<String>(json['correctedCategory']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'normalizedMerchant': serializer.toJson<String>(normalizedMerchant),
      'correctedCategory': serializer.toJson<String>(correctedCategory),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MerchantOverride copyWith({
    int? id,
    String? normalizedMerchant,
    String? correctedCategory,
    DateTime? updatedAt,
  }) => MerchantOverride(
    id: id ?? this.id,
    normalizedMerchant: normalizedMerchant ?? this.normalizedMerchant,
    correctedCategory: correctedCategory ?? this.correctedCategory,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MerchantOverride copyWithCompanion(MerchantOverridesCompanion data) {
    return MerchantOverride(
      id: data.id.present ? data.id.value : this.id,
      normalizedMerchant: data.normalizedMerchant.present
          ? data.normalizedMerchant.value
          : this.normalizedMerchant,
      correctedCategory: data.correctedCategory.present
          ? data.correctedCategory.value
          : this.correctedCategory,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantOverride(')
          ..write('id: $id, ')
          ..write('normalizedMerchant: $normalizedMerchant, ')
          ..write('correctedCategory: $correctedCategory, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, normalizedMerchant, correctedCategory, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantOverride &&
          other.id == this.id &&
          other.normalizedMerchant == this.normalizedMerchant &&
          other.correctedCategory == this.correctedCategory &&
          other.updatedAt == this.updatedAt);
}

class MerchantOverridesCompanion extends UpdateCompanion<MerchantOverride> {
  final Value<int> id;
  final Value<String> normalizedMerchant;
  final Value<String> correctedCategory;
  final Value<DateTime> updatedAt;
  const MerchantOverridesCompanion({
    this.id = const Value.absent(),
    this.normalizedMerchant = const Value.absent(),
    this.correctedCategory = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MerchantOverridesCompanion.insert({
    this.id = const Value.absent(),
    required String normalizedMerchant,
    required String correctedCategory,
    this.updatedAt = const Value.absent(),
  }) : normalizedMerchant = Value(normalizedMerchant),
       correctedCategory = Value(correctedCategory);
  static Insertable<MerchantOverride> custom({
    Expression<int>? id,
    Expression<String>? normalizedMerchant,
    Expression<String>? correctedCategory,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (normalizedMerchant != null) 'normalized_merchant': normalizedMerchant,
      if (correctedCategory != null) 'corrected_category': correctedCategory,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MerchantOverridesCompanion copyWith({
    Value<int>? id,
    Value<String>? normalizedMerchant,
    Value<String>? correctedCategory,
    Value<DateTime>? updatedAt,
  }) {
    return MerchantOverridesCompanion(
      id: id ?? this.id,
      normalizedMerchant: normalizedMerchant ?? this.normalizedMerchant,
      correctedCategory: correctedCategory ?? this.correctedCategory,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (normalizedMerchant.present) {
      map['normalized_merchant'] = Variable<String>(normalizedMerchant.value);
    }
    if (correctedCategory.present) {
      map['corrected_category'] = Variable<String>(correctedCategory.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantOverridesCompanion(')
          ..write('id: $id, ')
          ..write('normalizedMerchant: $normalizedMerchant, ')
          ..write('correctedCategory: $correctedCategory, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectTitleMeta = const VerificationMeta(
    'projectTitle',
  );
  @override
  late final GeneratedColumn<String> projectTitle = GeneratedColumn<String>(
    'project_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientPhoneMeta = const VerificationMeta(
    'clientPhone',
  );
  @override
  late final GeneratedColumn<String> clientPhone = GeneratedColumn<String>(
    'client_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    clientName,
    projectTitle,
    amount,
    dueDate,
    status,
    clientPhone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    } else if (isInserting) {
      context.missing(_clientNameMeta);
    }
    if (data.containsKey('project_title')) {
      context.handle(
        _projectTitleMeta,
        projectTitle.isAcceptableOrUnknown(
          data['project_title']!,
          _projectTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_projectTitleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('client_phone')) {
      context.handle(
        _clientPhoneMeta,
        clientPhone.isAcceptableOrUnknown(
          data['client_phone']!,
          _clientPhoneMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      )!,
      projectTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      clientPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_phone'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final String invoiceNumber;
  final String clientName;
  final String projectTitle;
  final double amount;
  final DateTime dueDate;
  final String status;
  final String clientPhone;
  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.projectTitle,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.clientPhone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['client_name'] = Variable<String>(clientName);
    map['project_title'] = Variable<String>(projectTitle);
    map['amount'] = Variable<double>(amount);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['status'] = Variable<String>(status);
    map['client_phone'] = Variable<String>(clientPhone);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      clientName: Value(clientName),
      projectTitle: Value(projectTitle),
      amount: Value(amount),
      dueDate: Value(dueDate),
      status: Value(status),
      clientPhone: Value(clientPhone),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      clientName: serializer.fromJson<String>(json['clientName']),
      projectTitle: serializer.fromJson<String>(json['projectTitle']),
      amount: serializer.fromJson<double>(json['amount']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: serializer.fromJson<String>(json['status']),
      clientPhone: serializer.fromJson<String>(json['clientPhone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'clientName': serializer.toJson<String>(clientName),
      'projectTitle': serializer.toJson<String>(projectTitle),
      'amount': serializer.toJson<double>(amount),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer.toJson<String>(status),
      'clientPhone': serializer.toJson<String>(clientPhone),
    };
  }

  Invoice copyWith({
    int? id,
    String? invoiceNumber,
    String? clientName,
    String? projectTitle,
    double? amount,
    DateTime? dueDate,
    String? status,
    String? clientPhone,
  }) => Invoice(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    clientName: clientName ?? this.clientName,
    projectTitle: projectTitle ?? this.projectTitle,
    amount: amount ?? this.amount,
    dueDate: dueDate ?? this.dueDate,
    status: status ?? this.status,
    clientPhone: clientPhone ?? this.clientPhone,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      projectTitle: data.projectTitle.present
          ? data.projectTitle.value
          : this.projectTitle,
      amount: data.amount.present ? data.amount.value : this.amount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      clientPhone: data.clientPhone.present
          ? data.clientPhone.value
          : this.clientPhone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('clientName: $clientName, ')
          ..write('projectTitle: $projectTitle, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('clientPhone: $clientPhone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceNumber,
    clientName,
    projectTitle,
    amount,
    dueDate,
    status,
    clientPhone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.clientName == this.clientName &&
          other.projectTitle == this.projectTitle &&
          other.amount == this.amount &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.clientPhone == this.clientPhone);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<String> invoiceNumber;
  final Value<String> clientName;
  final Value<String> projectTitle;
  final Value<double> amount;
  final Value<DateTime> dueDate;
  final Value<String> status;
  final Value<String> clientPhone;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.clientName = const Value.absent(),
    this.projectTitle = const Value.absent(),
    this.amount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.clientPhone = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNumber,
    required String clientName,
    required String projectTitle,
    required double amount,
    required DateTime dueDate,
    required String status,
    this.clientPhone = const Value.absent(),
  }) : invoiceNumber = Value(invoiceNumber),
       clientName = Value(clientName),
       projectTitle = Value(projectTitle),
       amount = Value(amount),
       dueDate = Value(dueDate),
       status = Value(status);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<String>? invoiceNumber,
    Expression<String>? clientName,
    Expression<String>? projectTitle,
    Expression<double>? amount,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<String>? clientPhone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (clientName != null) 'client_name': clientName,
      if (projectTitle != null) 'project_title': projectTitle,
      if (amount != null) 'amount': amount,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (clientPhone != null) 'client_phone': clientPhone,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceNumber,
    Value<String>? clientName,
    Value<String>? projectTitle,
    Value<double>? amount,
    Value<DateTime>? dueDate,
    Value<String>? status,
    Value<String>? clientPhone,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientName: clientName ?? this.clientName,
      projectTitle: projectTitle ?? this.projectTitle,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      clientPhone: clientPhone ?? this.clientPhone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (projectTitle.present) {
      map['project_title'] = Variable<String>(projectTitle.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (clientPhone.present) {
      map['client_phone'] = Variable<String>(clientPhone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('clientName: $clientName, ')
          ..write('projectTitle: $projectTitle, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('clientPhone: $clientPhone')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $EmergencyVaultsTable emergencyVaults = $EmergencyVaultsTable(
    this,
  );
  late final $MerchantOverridesTable merchantOverrides =
      $MerchantOverridesTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    emergencyVaults,
    merchantOverrides,
    invoices,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required String type,
      required String merchantOrClient,
      Value<String> subtitle,
      required String category,
      required double amount,
      Value<double> taxAmount,
      Value<double> emergencyFundAllocated,
      Value<bool> isDeductibleBusinessExpense,
      Value<bool> isPendingSync,
      required DateTime transactionDate,
      Value<String?> rawOcrText,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> merchantOrClient,
      Value<String> subtitle,
      Value<String> category,
      Value<double> amount,
      Value<double> taxAmount,
      Value<double> emergencyFundAllocated,
      Value<bool> isDeductibleBusinessExpense,
      Value<bool> isPendingSync,
      Value<DateTime> transactionDate,
      Value<String?> rawOcrText,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantOrClient => $composableBuilder(
    column: $table.merchantOrClient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get emergencyFundAllocated => $composableBuilder(
    column: $table.emergencyFundAllocated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeductibleBusinessExpense => $composableBuilder(
    column: $table.isDeductibleBusinessExpense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawOcrText => $composableBuilder(
    column: $table.rawOcrText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantOrClient => $composableBuilder(
    column: $table.merchantOrClient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get emergencyFundAllocated => $composableBuilder(
    column: $table.emergencyFundAllocated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeductibleBusinessExpense => $composableBuilder(
    column: $table.isDeductibleBusinessExpense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawOcrText => $composableBuilder(
    column: $table.rawOcrText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get merchantOrClient => $composableBuilder(
    column: $table.merchantOrClient,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get emergencyFundAllocated => $composableBuilder(
    column: $table.emergencyFundAllocated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeductibleBusinessExpense => $composableBuilder(
    column: $table.isDeductibleBusinessExpense,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPendingSync => $composableBuilder(
    column: $table.isPendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawOcrText => $composableBuilder(
    column: $table.rawOcrText,
    builder: (column) => column,
  );
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> merchantOrClient = const Value.absent(),
                Value<String> subtitle = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> emergencyFundAllocated = const Value.absent(),
                Value<bool> isDeductibleBusinessExpense = const Value.absent(),
                Value<bool> isPendingSync = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> rawOcrText = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                merchantOrClient: merchantOrClient,
                subtitle: subtitle,
                category: category,
                amount: amount,
                taxAmount: taxAmount,
                emergencyFundAllocated: emergencyFundAllocated,
                isDeductibleBusinessExpense: isDeductibleBusinessExpense,
                isPendingSync: isPendingSync,
                transactionDate: transactionDate,
                rawOcrText: rawOcrText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String merchantOrClient,
                Value<String> subtitle = const Value.absent(),
                required String category,
                required double amount,
                Value<double> taxAmount = const Value.absent(),
                Value<double> emergencyFundAllocated = const Value.absent(),
                Value<bool> isDeductibleBusinessExpense = const Value.absent(),
                Value<bool> isPendingSync = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> rawOcrText = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                merchantOrClient: merchantOrClient,
                subtitle: subtitle,
                category: category,
                amount: amount,
                taxAmount: taxAmount,
                emergencyFundAllocated: emergencyFundAllocated,
                isDeductibleBusinessExpense: isDeductibleBusinessExpense,
                isPendingSync: isPendingSync,
                transactionDate: transactionDate,
                rawOcrText: rawOcrText,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, Transaction>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TransactionsTable,
                    Transaction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$EmergencyVaultsTableCreateCompanionBuilder =
    EmergencyVaultsCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<double> lockedAmount,
      Value<double> targetAmount,
      Value<int> allocationPercent,
      Value<DateTime> updatedAt,
    });
typedef $$EmergencyVaultsTableUpdateCompanionBuilder =
    EmergencyVaultsCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<double> lockedAmount,
      Value<double> targetAmount,
      Value<int> allocationPercent,
      Value<DateTime> updatedAt,
    });

class $$EmergencyVaultsTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyVaultsTable> {
  $$EmergencyVaultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lockedAmount => $composableBuilder(
    column: $table.lockedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allocationPercent => $composableBuilder(
    column: $table.allocationPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmergencyVaultsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyVaultsTable> {
  $$EmergencyVaultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lockedAmount => $composableBuilder(
    column: $table.lockedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allocationPercent => $composableBuilder(
    column: $table.allocationPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmergencyVaultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyVaultsTable> {
  $$EmergencyVaultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get lockedAmount => $composableBuilder(
    column: $table.lockedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allocationPercent => $composableBuilder(
    column: $table.allocationPercent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmergencyVaultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyVaultsTable,
          EmergencyVault,
          $$EmergencyVaultsTableFilterComposer,
          $$EmergencyVaultsTableOrderingComposer,
          $$EmergencyVaultsTableAnnotationComposer,
          $$EmergencyVaultsTableCreateCompanionBuilder,
          $$EmergencyVaultsTableUpdateCompanionBuilder,
          (
            EmergencyVault,
            BaseReferences<
              _$AppDatabase,
              $EmergencyVaultsTable,
              EmergencyVault
            >,
          ),
          EmergencyVault,
          PrefetchHooks Function()
        > {
  $$EmergencyVaultsTableTableManager(
    _$AppDatabase db,
    $EmergencyVaultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyVaultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyVaultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyVaultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> lockedAmount = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<int> allocationPercent = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmergencyVaultsCompanion(
                id: id,
                label: label,
                lockedAmount: lockedAmount,
                targetAmount: targetAmount,
                allocationPercent: allocationPercent,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> lockedAmount = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<int> allocationPercent = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmergencyVaultsCompanion.insert(
                id: id,
                label: label,
                lockedAmount: lockedAmount,
                targetAmount: targetAmount,
                allocationPercent: allocationPercent,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmergencyVaultsTable, EmergencyVault>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EmergencyVaultsTable,
                    EmergencyVault
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmergencyVaultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyVaultsTable,
      EmergencyVault,
      $$EmergencyVaultsTableFilterComposer,
      $$EmergencyVaultsTableOrderingComposer,
      $$EmergencyVaultsTableAnnotationComposer,
      $$EmergencyVaultsTableCreateCompanionBuilder,
      $$EmergencyVaultsTableUpdateCompanionBuilder,
      (
        EmergencyVault,
        BaseReferences<_$AppDatabase, $EmergencyVaultsTable, EmergencyVault>,
      ),
      EmergencyVault,
      PrefetchHooks Function()
    >;
typedef $$MerchantOverridesTableCreateCompanionBuilder =
    MerchantOverridesCompanion Function({
      Value<int> id,
      required String normalizedMerchant,
      required String correctedCategory,
      Value<DateTime> updatedAt,
    });
typedef $$MerchantOverridesTableUpdateCompanionBuilder =
    MerchantOverridesCompanion Function({
      Value<int> id,
      Value<String> normalizedMerchant,
      Value<String> correctedCategory,
      Value<DateTime> updatedAt,
    });

class $$MerchantOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantOverridesTable> {
  $$MerchantOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedMerchant => $composableBuilder(
    column: $table.normalizedMerchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctedCategory => $composableBuilder(
    column: $table.correctedCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MerchantOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantOverridesTable> {
  $$MerchantOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedMerchant => $composableBuilder(
    column: $table.normalizedMerchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctedCategory => $composableBuilder(
    column: $table.correctedCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MerchantOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantOverridesTable> {
  $$MerchantOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get normalizedMerchant => $composableBuilder(
    column: $table.normalizedMerchant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correctedCategory => $composableBuilder(
    column: $table.correctedCategory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MerchantOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantOverridesTable,
          MerchantOverride,
          $$MerchantOverridesTableFilterComposer,
          $$MerchantOverridesTableOrderingComposer,
          $$MerchantOverridesTableAnnotationComposer,
          $$MerchantOverridesTableCreateCompanionBuilder,
          $$MerchantOverridesTableUpdateCompanionBuilder,
          (
            MerchantOverride,
            BaseReferences<
              _$AppDatabase,
              $MerchantOverridesTable,
              MerchantOverride
            >,
          ),
          MerchantOverride,
          PrefetchHooks Function()
        > {
  $$MerchantOverridesTableTableManager(
    _$AppDatabase db,
    $MerchantOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> normalizedMerchant = const Value.absent(),
                Value<String> correctedCategory = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MerchantOverridesCompanion(
                id: id,
                normalizedMerchant: normalizedMerchant,
                correctedCategory: correctedCategory,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String normalizedMerchant,
                required String correctedCategory,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MerchantOverridesCompanion.insert(
                id: id,
                normalizedMerchant: normalizedMerchant,
                correctedCategory: correctedCategory,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MerchantOverridesTable, MerchantOverride>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MerchantOverridesTable,
                    MerchantOverride
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MerchantOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantOverridesTable,
      MerchantOverride,
      $$MerchantOverridesTableFilterComposer,
      $$MerchantOverridesTableOrderingComposer,
      $$MerchantOverridesTableAnnotationComposer,
      $$MerchantOverridesTableCreateCompanionBuilder,
      $$MerchantOverridesTableUpdateCompanionBuilder,
      (
        MerchantOverride,
        BaseReferences<
          _$AppDatabase,
          $MerchantOverridesTable,
          MerchantOverride
        >,
      ),
      MerchantOverride,
      PrefetchHooks Function()
    >;
typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  required String invoiceNumber,
  required String clientName,
  required String projectTitle,
  required double amount,
  required DateTime dueDate,
  required String status,
  Value<String> clientPhone,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  Value<String> invoiceNumber,
  Value<String> clientName,
  Value<String> projectTitle,
  Value<double> amount,
  Value<DateTime> dueDate,
  Value<String> status,
  Value<String> clientPhone,
});

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectTitle => $composableBuilder(
    column: $table.projectTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientPhone => $composableBuilder(
    column: $table.clientPhone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectTitle => $composableBuilder(
    column: $table.projectTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientPhone => $composableBuilder(
    column: $table.clientPhone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectTitle => $composableBuilder(
    column: $table.projectTitle,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get clientPhone => $composableBuilder(
    column: $table.clientPhone,
    builder: (column) => column,
  );
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
          Invoice,
          PrefetchHooks Function()
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<String> clientName = const Value.absent(),
                Value<String> projectTitle = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> clientPhone = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                clientName: clientName,
                projectTitle: projectTitle,
                amount: amount,
                dueDate: dueDate,
                status: status,
                clientPhone: clientPhone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceNumber,
                required String clientName,
                required String projectTitle,
                required double amount,
                required DateTime dueDate,
                required String status,
                Value<String> clientPhone = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                clientName: clientName,
                projectTitle: projectTitle,
                amount: amount,
                dueDate: dueDate,
                status: status,
                clientPhone: clientPhone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoicesTable, Invoice>(table),
                  BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
      Invoice,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$EmergencyVaultsTableTableManager get emergencyVaults =>
      $$EmergencyVaultsTableTableManager(_db, _db.emergencyVaults);
  $$MerchantOverridesTableTableManager get merchantOverrides =>
      $$MerchantOverridesTableTableManager(_db, _db.merchantOverrides);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
}
