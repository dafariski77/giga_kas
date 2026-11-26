import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Lightweight spatial OCR line representation for deterministic testing & parsing.
class OcrLineBox {
  const OcrLineBox({
    required this.text,
    required this.boundingBox,
  });

  final String text;
  final Rect boundingBox;

  double get centerY => boundingBox.top + (boundingBox.height / 2);
}

/// Structured receipt fields extracted from OCR text & spatial layout.
class ParsedReceiptData {
  const ParsedReceiptData({
    required this.merchantName,
    required this.amount,
    required this.date,
    required this.rawText,
  });

  final String merchantName;
  final int? amount;
  final DateTime? date;
  final String rawText;
}

/// Spatial bounding-box parser for Indonesian receipts.
///
/// 1. Merchant Name: top-most meaningful line (smallest `boundingBox.top`).
/// 2. Date: regex `\d{2}[/-]\d{2}[/-]\d{2,4}` or `yyyy-MM-dd`.
/// 3. Total Expense: finds `TOTAL` / `JUMLAH` / `BAYAR` keyword and extracts
///    the rightmost numeric token aligned on the same horizontal Y-axis band.
abstract final class ReceiptParser {
  static final RegExp _dateRegex = RegExp(
    r'(\d{2})[/-](\d{2})[/-](\d{2,4})|(\d{4})[/-](\d{2})[/-](\d{2})',
  );
  static final RegExp _totalKeywordRegex = RegExp(
    r'\b(grand\s*total|total\s*bayar|total|jumlah|tagihan|nett|net\s*total)\b',
    caseSensitive: false,
  );
  static final RegExp _subtotalRegex = RegExp(
    r'\bsub\s*total\b',
    caseSensitive: false,
  );
  static final RegExp _moneyTokenRegex = RegExp(
    r'(?:rp\.?\s*)?(\d{1,3}(?:[.,]\d{3})+|\d{4,})',
    caseSensitive: false,
  );
  static final RegExp _noiseHeaderRegex = RegExp(
    r'^[\W\d]+$|^(struk|receipt|nota|invoice|kwitansi|bill|tanggal|date|kasir|no\.)',
    caseSensitive: false,
  );

  /// Parses an ML Kit [RecognizedText] using its line bounding boxes.
  static ParsedReceiptData parseRecognizedText(RecognizedText recognizedText) {
    final lines = <OcrLineBox>[];
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final trimmed = line.text.trim();
        if (trimmed.isNotEmpty) {
          lines.add(
            OcrLineBox(text: trimmed, boundingBox: line.boundingBox),
          );
        }
      }
    }
    return parseSpatialLines(lines, rawText: recognizedText.text.trim());
  }

  /// Parses a list of spatially located [OcrLineBox] items.
  static ParsedReceiptData parseSpatialLines(
    List<OcrLineBox> lines, {
    String? rawText,
  }) {
    final sortedByTop = [...lines]
      ..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
    final joinedText =
        rawText ?? sortedByTop.map((e) => e.text).join('\n').trim();

    final merchant = _extractMerchant(sortedByTop);
    final date = _extractDate(joinedText);
    final total = _extractTotalSpatial(sortedByTop) ?? _extractFallbackAmount(joinedText);

    return ParsedReceiptData(
      merchantName: merchant,
      amount: total,
      date: date,
      rawText: joinedText,
    );
  }

  /// Fallback parser when only plain text (e.g., manual input or sample) is available.
  static ParsedReceiptData parseRawText(String rawText) {
    final rawLines = rawText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final syntheticBoxes = <OcrLineBox>[];
    for (var i = 0; i < rawLines.length; i++) {
      syntheticBoxes.add(
        OcrLineBox(
          text: rawLines[i],
          boundingBox: Rect.fromLTWH(0, i * 24.0, 300, 20),
        ),
      );
    }
    return parseSpatialLines(syntheticBoxes, rawText: rawText.trim());
  }

  static String _extractMerchant(List<OcrLineBox> sortedByTop) {
    for (final line in sortedByTop) {
      final cleaned = line.text.trim();
      if (cleaned.length < 3) continue;
      if (_noiseHeaderRegex.hasMatch(cleaned)) continue;
      if (_dateRegex.hasMatch(cleaned)) continue;
      return cleaned;
    }
    return sortedByTop.isNotEmpty ? sortedByTop.first.text : 'Merchant Tidak Diketahui';
  }

  static DateTime? _extractDate(String text) {
    final match = _dateRegex.firstMatch(text);
    if (match == null) return null;

    if (match.group(1) != null) {
      final day = int.tryParse(match.group(1)!);
      final month = int.tryParse(match.group(2)!);
      var year = int.tryParse(match.group(3)!);
      if (day == null || month == null || year == null) return null;
      if (year < 100) year += 2000;
      if (month < 1 || month > 12 || day < 1 || day > 31) return null;
      return DateTime(year, month, day);
    }

    if (match.group(4) != null) {
      final year = int.tryParse(match.group(4)!);
      final month = int.tryParse(match.group(5)!);
      final day = int.tryParse(match.group(6)!);
      if (day == null || month == null || year == null) return null;
      if (month < 1 || month > 12 || day < 1 || day > 31) return null;
      return DateTime(year, month, day);
    }

    return null;
  }

  static int? _extractTotalSpatial(List<OcrLineBox> sortedByTop) {
    final totalCandidates = sortedByTop
        .where(
          (line) =>
              _totalKeywordRegex.hasMatch(line.text) &&
              !_subtotalRegex.hasMatch(line.text),
        )
        .toList();

    // Check bottom-most TOTAL line first (grand total is typically near bottom)
    for (final totalLine in totalCandidates.reversed) {
      final yTolerance = (totalLine.boundingBox.height * 0.85).clamp(12.0, 40.0);

      // Find all lines aligned on the same horizontal Y band, sorted rightmost first
      final sameRowLines = sortedByTop
          .where((other) => (other.centerY - totalLine.centerY).abs() <= yTolerance)
          .toList()
        ..sort((a, b) => b.boundingBox.right.compareTo(a.boundingBox.right));

      for (final rowLine in sameRowLines) {
        final amount = _parseRightmostAmountInLine(rowLine.text);
        if (amount != null && amount >= 500) {
          return amount;
        }
      }
    }
    return null;
  }

  static int? _extractFallbackAmount(String text) {
    int? maxAmount;
    for (final match in _moneyTokenRegex.allMatches(text)) {
      final parsed = _digitsToRupiah(match.group(1));
      if (parsed != null && parsed >= 1000 && parsed <= 500000000) {
        if (maxAmount == null || parsed > maxAmount) {
          maxAmount = parsed;
        }
      }
    }
    return maxAmount;
  }

  static int? _parseRightmostAmountInLine(String line) {
    final matches = _moneyTokenRegex.allMatches(line).toList();
    if (matches.isEmpty) return null;
    for (final match in matches.reversed) {
      final parsed = _digitsToRupiah(match.group(1));
      if (parsed != null && parsed >= 500) {
        return parsed;
      }
    }
    return null;
  }

  static int? _digitsToRupiah(String? token) {
    if (token == null) return null;
    // Strip trailing decimal cents like ,00 or .00
    final withoutCents = token.replaceAll(RegExp(r'[.,]\d{2}$'), '');
    final digitsOnly = withoutCents.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digitsOnly);
  }
}
