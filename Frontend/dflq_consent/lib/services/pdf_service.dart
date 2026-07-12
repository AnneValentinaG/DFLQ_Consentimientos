import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/surgery_consent.dart';
import '../utils/date_utils.dart';
import 'pdf_field_position.dart';
import 'pdf_template_config.dart';

class PdfService {
  Future<Uint8List> generateSurgeryConsentPdf({
    required SurgeryConsent consent,
  }) async {
    _validateConsent(consent);

    final PdfTemplateConfig template = PdfTemplateConfig.surgeryConsent();

    final Uint8List templateBytes = await _loadTemplateFromAssets(
      template.assetPath,
    );

    final _RenderedTemplate renderedTemplate = await _renderTemplateFirstPage(
      pdfBytes: templateBytes,
      dpi: template.renderDpi,
    );

    final PdfPageFormat pageFormat = template.resolvePageFormat(
      rasterWidth: renderedTemplate.width,
      rasterHeight: renderedTemplate.height,
    );

    final pw.Document document = pw.Document(
      title: 'Consentimiento informado cirugía',
      author: 'DFLQ Consent',
      creator: 'Aplicación offline Flutter',
      producer: 'Flutter PDF',
    );

    document.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: <pw.Widget>[
              _buildTemplateBackground(renderedTemplate.pngBytes),

              _buildTextField(
                position: template.getFieldPosition('date'),
                value: AppDateUtils.formatDocumentDate(consent.date),
              ),

              _buildTextField(
                position: template.getFieldPosition('patientName'),
                value: consent.patientName,
              ),

              _buildTextField(
                position: template.getFieldPosition('documentNumber'),
                value: consent.documentNumber,
              ),

              _buildTextField(
                position: template.getFieldPosition('expeditionPlace'),
                value: consent.expeditionPlace,
              ),

              _buildTextField(
                position: template.getFieldPosition('doctorName'),
                value: consent.doctorName,
              ),

              _buildTextField(
                position: template.getFieldPosition('procedure'),
                value: consent.procedure,
                maxLines: 2,
              ),

              _buildTextField(
                position: template.getFieldPosition('teeth'),
                value: consent.teeth,
              ),

              _buildSignatureField(
                position: template.getFieldPosition('signature'),
                signatureBytes: consent.SignatureData,
              ),
            ],
          );
        },
      ),
    );

    return document.save();
  }

  Future<Uint8List> _loadTemplateFromAssets(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);

    return data.buffer.asUint8List();
  }

  Future<_RenderedTemplate> _renderTemplateFirstPage({
    required Uint8List pdfBytes,
    required double dpi,
  }) async {
    final Stream<PdfRaster> pages = Printing.raster(
      pdfBytes,
      pages: const <int>[0],
      dpi: dpi,
    );

    final PdfRaster raster = await pages.first;
    final Uint8List pngBytes = await raster.toPng();

    return _RenderedTemplate(
      pngBytes: pngBytes,
      width: raster.width,
      height: raster.height,
    );
  }

  pw.Widget _buildTemplateBackground(Uint8List imageBytes) {
    return pw.Positioned.fill(
      child: pw.Image(
        pw.MemoryImage(imageBytes),
        fit: pw.BoxFit.fill,
      ),
    );
  }

  pw.Widget _buildTextField({
    required PdfFieldPosition position,
    required String value,
    int maxLines = 1,
  }) {
    return pw.Positioned(
      left: position.left,
      top: position.top,
      child: pw.Container(
        width: position.width,
        height: position.height,
        child: pw.Text(
          value.trim(),
          maxLines: maxLines,
          overflow: pw.TextOverflow.clip,
          style: pw.TextStyle(
            font: pw.Font.helvetica(),
            fontSize: position.fontSize,
            color: PdfColors.black,
          ),
        ),
      ),
    );
  }

  pw.Widget _buildSignatureField({
    required PdfFieldPosition position,
    required Uint8List signatureBytes,
  }) {
    if (signatureBytes.isEmpty) {
      return pw.SizedBox();
    }

    return pw.Positioned(
      left: position.left,
      top: position.top,
      child: pw.Container(
        width: position.width,
        height: position.height,
        child: pw.Image(
          pw.MemoryImage(signatureBytes),
          fit: pw.BoxFit.contain,
        ),
      ),
    );
  }

  void _validateConsent(SurgeryConsent consent) {
    if (consent.patientName.trim().isEmpty) {
      throw ArgumentError('El nombre del paciente no puede estar vacío.');
    }

    if (consent.documentNumber.trim().isEmpty) {
      throw ArgumentError('El documento del paciente no puede estar vacío.');
    }

    if (consent.doctorName.trim().isEmpty) {
      throw ArgumentError('El nombre del doctor no puede estar vacío.');
    }

    if (consent.procedure.trim().isEmpty) {
      throw ArgumentError('El procedimiento no puede estar vacío.');
    }

    if (consent.SignatureData.isEmpty) {
      throw ArgumentError('La firma del paciente no puede estar vacía.');
    }
  }
}

class _RenderedTemplate {
  final Uint8List pngBytes;
  final int width;
  final int height;

  const _RenderedTemplate({
    required this.pngBytes,
    required this.width,
    required this.height,
  });
}