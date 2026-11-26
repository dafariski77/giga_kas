import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/finance/domain/finance_models.dart';
import '../utils/currency_formatter.dart';

/// Generates clean offline PDF invoices and opens WhatsApp/Email reminders.
abstract final class InvoicePdfService {
  static Future<File> generateInvoicePdf(InvoiceItem invoice) async {
    final doc = pw.Document();
    final primaryColor = PdfColor.fromHex('#0F6B54');
    final inkColor = PdfColor.fromHex('#14181F');
    final mutedColor = PdfColor.fromHex('#636973');
    final borderColor = PdfColor.fromHex('#E4E1D8');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'GigaKas',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Tagihan Jasa Pekerja Lepas',
                        style: pw.TextStyle(fontSize: 11, color: mutedColor),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: inkColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        invoice.invoiceNumber,
                        style: pw.TextStyle(fontSize: 11, color: mutedColor),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 28),
              pw.Divider(color: borderColor, thickness: 1),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'DITAGIHKAN KEPADA',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: mutedColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        invoice.clientName,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: inkColor,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        invoice.clientPhone,
                        style: pw.TextStyle(fontSize: 10, color: mutedColor),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'JATUH TEMPO',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: mutedColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        CurrencyFormatter.formatShortDate(invoice.dueDate),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: inkColor,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Status: ${invoice.status.label}',
                        style: pw.TextStyle(fontSize: 10, color: primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 28),
              pw.Container(
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: borderColor),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'DESKRIPSI PEKERJAAN',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: mutedColor,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            invoice.projectTitle,
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                              color: inkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'TOTAL TAGIHAN',
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: mutedColor,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          CurrencyFormatter.formatIdr(invoice.amount),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Divider(color: borderColor),
              pw.SizedBox(height: 8),
              pw.Text(
                'Dibuat secara offline melalui GigaKas · Terima kasih atas kerja samanya.',
                style: pw.TextStyle(fontSize: 9, color: mutedColor),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, '${invoice.invoiceNumber}.pdf'));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> shareInvoicePdf(InvoiceItem invoice) async {
    final file = await generateInvoicePdf(invoice);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Invoice ${invoice.invoiceNumber} — ${invoice.projectTitle}',
        text: buildReminderMessage(invoice),
      ),
    );
  }

  static String buildReminderMessage(InvoiceItem invoice) {
    return 'Halo ${invoice.clientName}, izin mengingatkan tagihan '
        '${invoice.invoiceNumber} untuk "${invoice.projectTitle}" sebesar '
        '${CurrencyFormatter.formatIdr(invoice.amount)} dengan jatuh tempo '
        '${CurrencyFormatter.formatShortDate(invoice.dueDate)}. Terima kasih.';
  }

  static Future<bool> openWhatsAppReminder(InvoiceItem invoice) async {
    final phoneDigits = invoice.clientPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final encoded = Uri.encodeComponent(buildReminderMessage(invoice));
    final uri = Uri.parse('https://wa.me/$phoneDigits?text=$encoded');
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static Future<bool> openEmailReminder(InvoiceItem invoice) async {
    final subject = Uri.encodeComponent(
      'Pengingat Tagihan ${invoice.invoiceNumber} — ${invoice.projectTitle}',
    );
    final body = Uri.encodeComponent(buildReminderMessage(invoice));
    final uri = Uri.parse('mailto:?subject=$subject&body=$body');
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }
}
