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
    category,
    amount,
    taxAmount,
    emergencyFundAllocated,
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
  final String category;
  final double amount;
  final double taxAmount;
  final double emergencyFundAllocated;
  final DateTime transactionDate;
  final String? rawOcrText;
  const Transaction({
    required this.id,
    required this.type,
    required this.merchantOrClient,
    required this.category,
    required this.amount,
    required this.taxAmount,
    required this.emergencyFundAllocated,
    required this.transactionDate,
    this.rawOcrText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['merchant_or_client'] = Variable<String>(merchantOrClient);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['emergency_fund_allocated'] = Variable<double>(emergencyFundAllocated);
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
      category: Value(category),
      amount: Value(amount),
      taxAmount: Value(taxAmount),
      emergencyFundAllocated: Value(emergencyFundAllocated),
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
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      emergencyFundAllocated: serializer.fromJson<double>(
        json['emergencyFundAllocated'],
      ),
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
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'emergencyFundAllocated': serializer.toJson<double>(
        emergencyFundAllocated,
      ),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'rawOcrText': serializer.toJson<String?>(rawOcrText),
    };
  }

  Transaction copyWith({
    int? id,
    String? type,
    String? merchantOrClient,
    String? category,
    double? amount,
    double? taxAmount,
    double? emergencyFundAllocated,
    DateTime? transactionDate,
    Value<String?> rawOcrText = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    type: type ?? this.type,
    merchantOrClient: merchantOrClient ?? this.merchantOrClient,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    taxAmount: taxAmount ?? this.taxAmount,
    emergencyFundAllocated:
        emergencyFundAllocated ?? this.emergencyFundAllocated,
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
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      emergencyFundAllocated: data.emergencyFundAllocated.present
          ? data.emergencyFundAllocated.value
          : this.emergencyFundAllocated,
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
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('emergencyFundAllocated: $emergencyFundAllocated, ')
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
    category,
    amount,
    taxAmount,
    emergencyFundAllocated,
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
          other.category == this.category &&
          other.amount == this.amount &&
          other.taxAmount == this.taxAmount &&
          other.emergencyFundAllocated == this.emergencyFundAllocated &&
          other.transactionDate == this.transactionDate &&
          other.rawOcrText == this.rawOcrText);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> merchantOrClient;
  final Value<String> category;
  final Value<double> amount;
  final Value<double> taxAmount;
  final Value<double> emergencyFundAllocated;
  final Value<DateTime> transactionDate;
  final Value<String?> rawOcrText;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.merchantOrClient = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.emergencyFundAllocated = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.rawOcrText = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String merchantOrClient,
    required String category,
    required double amount,
    this.taxAmount = const Value.absent(),
    this.emergencyFundAllocated = const Value.absent(),
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
    Expression<String>? category,
    Expression<double>? amount,
    Expression<double>? taxAmount,
    Expression<double>? emergencyFundAllocated,
    Expression<DateTime>? transactionDate,
    Expression<String>? rawOcrText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (merchantOrClient != null) 'merchant_or_client': merchantOrClient,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (emergencyFundAllocated != null)
        'emergency_fund_allocated': emergencyFundAllocated,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (rawOcrText != null) 'raw_ocr_text': rawOcrText,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? merchantOrClient,
    Value<String>? category,
    Value<double>? amount,
    Value<double>? taxAmount,
    Value<double>? emergencyFundAllocated,
    Value<DateTime>? transactionDate,
    Value<String?>? rawOcrText,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      merchantOrClient: merchantOrClient ?? this.merchantOrClient,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      taxAmount: taxAmount ?? this.taxAmount,
      emergencyFundAllocated:
          emergencyFundAllocated ?? this.emergencyFundAllocated,
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
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('emergencyFundAllocated: $emergencyFundAllocated, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('rawOcrText: $rawOcrText')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $MerchantOverridesTable merchantOverrides =
      $MerchantOverridesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    merchantOverrides,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required String type,
      required String merchantOrClient,
      required String category,
      required double amount,
      Value<double> taxAmount,
      Value<double> emergencyFundAllocated,
      required DateTime transactionDate,
      Value<String?> rawOcrText,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> merchantOrClient,
      Value<String> category,
      Value<double> amount,
      Value<double> taxAmount,
      Value<double> emergencyFundAllocated,
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
                Value<String> category = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> emergencyFundAllocated = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> rawOcrText = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                merchantOrClient: merchantOrClient,
                category: category,
                amount: amount,
                taxAmount: taxAmount,
                emergencyFundAllocated: emergencyFundAllocated,
                transactionDate: transactionDate,
                rawOcrText: rawOcrText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String merchantOrClient,
                required String category,
                required double amount,
                Value<double> taxAmount = const Value.absent(),
                Value<double> emergencyFundAllocated = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> rawOcrText = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                merchantOrClient: merchantOrClient,
                category: category,
                amount: amount,
                taxAmount: taxAmount,
                emergencyFundAllocated: emergencyFundAllocated,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$MerchantOverridesTableTableManager get merchantOverrides =>
      $$MerchantOverridesTableTableManager(_db, _db.merchantOverrides);
}
