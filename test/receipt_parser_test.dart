import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:giga_kas/core/services/receipt_parser.dart';

void main() {
  group('ReceiptParser spatial extraction', () {
    test('extracts top-most merchant, date, and rightmost Y-aligned total', () {
      const lines = [
        OcrLineBox(
          text: 'STRUK PEMBAYARAN',
          boundingBox: Rect.fromLTWH(20, 10, 200, 20),
        ),
        OcrLineBox(
          text: 'KOPI KENANGAN SCBD',
          boundingBox: Rect.fromLTWH(20, 40, 220, 22),
        ),
        OcrLineBox(
          text: 'Tanggal: 26/11/2026',
          boundingBox: Rect.fromLTWH(20, 72, 180, 18),
        ),
        OcrLineBox(
          text: 'SUBTOTAL',
          boundingBox: Rect.fromLTWH(20, 140, 90, 18),
        ),
        OcrLineBox(
          text: 'Rp 75.000',
          boundingBox: Rect.fromLTWH(220, 140, 80, 18),
        ),
        OcrLineBox(
          text: 'GRAND TOTAL',
          boundingBox: Rect.fromLTWH(20, 175, 110, 20),
        ),
        OcrLineBox(
          text: 'Rp 85.000',
          boundingBox: Rect.fromLTWH(220, 176, 85, 20),
        ),
      ];

      final parsed = ReceiptParser.parseSpatialLines(lines);

      expect(parsed.merchantName, 'KOPI KENANGAN SCBD');
      expect(parsed.date, DateTime(2026, 11, 26));
      expect(parsed.amount, 85000);
    });

    test('parses plain text receipt cleanly', () {
      final parsed = ReceiptParser.parseRawText(
        'BIZNET HOME INTERNET\n25-11-2026\nTagihan Bulanan\nTOTAL Rp 450.000',
      );

      expect(parsed.merchantName, 'BIZNET HOME INTERNET');
      expect(parsed.date, DateTime(2026, 11, 25));
      expect(parsed.amount, 450000);
    });
  });
}
