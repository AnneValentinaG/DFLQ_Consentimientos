import 'package:pdf/pdf.dart';

import 'pdf_field_position.dart';

enum ConsentTemplateType {
  surgery,
  orthodontics,
  endodontics,
  implants,
}

class PdfTemplateConfig {
  final ConsentTemplateType type;
  final String assetPath;
  final double renderDpi;
  final Map<String, PdfFieldPosition> fields;

  const PdfTemplateConfig({
    required this.type,
    required this.assetPath,
    required this.renderDpi,
    required this.fields,
  });

  static PdfTemplateConfig surgeryConsent() {
    return const PdfTemplateConfig(
      type: ConsentTemplateType.surgery,
      assetPath: 'lib/assets/templates/consentimiento_cirugia.pdf',
      renderDpi: 144,
      fields: <String, PdfFieldPosition>{
        'date': PdfFieldPosition(
          left: 88,
          top: 116,
          width: 120,
          height: 16,
          fontSize: 10,
        ),

        'patientName': PdfFieldPosition(
          left: 70,
          top: 144,
          width: 330,
          height: 16,
          fontSize: 10,
        ),

        'patientDocument': PdfFieldPosition(
          left: 58,
          top: 158,
          width: 128,
          height: 16,
          fontSize: 10,
        ),

        'patientIssuePlace': PdfFieldPosition(
          left: 202,
          top: 158,
          width: 104,
          height: 16,
          fontSize: 10,
        ),

        'representativeName': PdfFieldPosition(
          left: 74,
          top: 186,
          width: 185,
          height: 16,
          fontSize: 9,
        ),

        'representativeDocument': PdfFieldPosition(
          left: 337,
          top: 186,
          width: 90,
          height: 16,
          fontSize: 9,
        ),

        'doctorName': PdfFieldPosition(
          left: 270,
          top: 214,
          width: 216,
          height: 16,
          fontSize: 10,
        ),

        'procedure': PdfFieldPosition(
          left: 386,
          top: 228,
          width: 84,
          height: 16,
          fontSize: 9,
        ),

        'teeth': PdfFieldPosition(
          left: 58,
          top: 242,
          width: 198,
          height: 16,
          fontSize: 10,
        ),

        'patientSignature': PdfFieldPosition(
          left: 60,
          top: 623,
          width: 132,
          height: 42,
          fontSize: 10,
        ),

        'patientSignatureDocument': PdfFieldPosition(
          left: 73,
          top: 680,
          width: 120,
          height: 14,
          fontSize: 8,
        ),
      },
    );
  }

  PdfFieldPosition getFieldPosition(String fieldName) {
    final PdfFieldPosition? position = fields[fieldName];

    if (position == null) {
      throw ArgumentError(
        'No existe una posición configurada para el campo: $fieldName',
      );
    }

    return position;
  }

  PdfPageFormat resolvePageFormat({
    required int rasterWidth,
    required int rasterHeight,
  }) {
    return PdfPageFormat(
      rasterWidth / renderDpi * PdfPageFormat.inch,
      rasterHeight / renderDpi * PdfPageFormat.inch,
    );
  }
}