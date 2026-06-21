import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/theme/app_colors.dart';

/// Centralized template utility for unified PDF generation.
class PdfTemplate {
  // Theme Colors sourced from AppColors
  static final primaryColor = PdfColor.fromInt(AppColors.primaryLight.toARGB32()); // Brand Blue (#3580FF)
  static final accentColor = PdfColor.fromInt(AppColors.onSurfaceVariant.toARGB32()); // Slate Grey
  static final dividerColor = PdfColor.fromInt(AppColors.surfaceVariant.toARGB32()); // Light Grey
  static final successColor = PdfColor.fromInt(AppColors.success.toARGB32()); // Green
  static final errorColor = PdfColor.fromInt(AppColors.error.toARGB32()); // Red

  /// Loads the standard theme with bundled offline fonts
  static Future<pw.ThemeData> loadTheme() async {
    final regularData = await rootBundle.load('assets/google_fonts/Inter-Regular.ttf');
    final boldData = await rootBundle.load('assets/google_fonts/Inter-Bold.ttf');
    
    final fontRegular = pw.Font.ttf(regularData);
    final fontBold = pw.Font.ttf(boldData);

    return pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      fontFallback: [fontRegular],
    );
  }

  /// Loads the primary logo with background as bytes
  static Future<Uint8List> loadPrimaryLogo() async {
    final data = await rootBundle.load('assets/logo/logo_primary_with_bg.png');
    return data.buffer.asUint8List();
  }

  /// Loads the transparent logo as bytes
  static Future<Uint8List> loadTransparentLogo() async {
    final data = await rootBundle.load('assets/logo/logo_transparent_dark.png');
    return data.buffer.asUint8List();
  }

  /// Builds a dark, premium brand header
  static pw.Widget buildDarkHeader({
    required String title,
    required String subtitle,
    required String landlordName,
    required Uint8List logoBytes,
    String? landlordPhone,
    String? landlordAddress,
  }) {

    return pw.Container(
      width: double.infinity,
      color: primaryColor,
      padding: const pw.EdgeInsets.all(30),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Landlord Details
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  landlordName.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                pw.SizedBox(height: 6),
                if (landlordPhone != null && landlordPhone.isNotEmpty)
                  pw.Text(
                    landlordPhone,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey300,
                    ),
                  ),
                if (landlordAddress != null && landlordAddress.isNotEmpty)
                  pw.Text(
                    landlordAddress,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey300,
                    ),
                  ),
              ],
            ),
          ),
          
          // Right Side: Document Title & Logo
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 2.0,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                subtitle,
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey300,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              // Logo
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: 80,
                fit: pw.BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a modern, clean header with a solid background logo
  static pw.Widget buildModernHeader({
    required String title,
    required String subtitle,
    required String landlordName,
    required Uint8List logoBytes,
    String? landlordPhone,
    String? landlordAddress,
    bool isSmallPage = false,
    double? titleFontSize,
  }) {
    return pw.Container(
      width: double.infinity,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Logo & Landlord Details
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Logo
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: isSmallPage ? 40 : 50,
                height: isSmallPage ? 40 : 50,
                fit: pw.BoxFit.contain,
              ),
              pw.SizedBox(width: 6),
              // Landlord Details
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    landlordName,
                    style: pw.TextStyle(
                      fontSize: isSmallPage ? 16 : 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey900,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  if (landlordPhone != null && landlordPhone.isNotEmpty)
                    pw.Text(
                      landlordPhone,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  if (landlordAddress != null && landlordAddress.isNotEmpty)
                    pw.Text(
                      landlordAddress,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          // Right Side: Document Title
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: titleFontSize ?? (isSmallPage ? 20 : 24),
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                  letterSpacing: 1.0,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                subtitle,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildMarketingFooter() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(top: 20),
      decoration: const pw.BoxDecoration(),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'Generated via ',
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 9,
            ),
          ),
          pw.Text(
            'RentKhata',
            style: pw.TextStyle(
              color: primaryColor,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Standard Section Title
  static pw.Widget buildSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          color: accentColor,
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
