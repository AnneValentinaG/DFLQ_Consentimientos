import 'dart:io';

import '../models/surgery_consent.dart';
import 'local_storage_service.dart';
import 'pdf_service.dart';
import 'print_service.dart';
import 'share_service.dart';

class ConsentDocumentService {
  ConsentDocumentService({
    PdfService? pdfService,
    LocalStorageService? localStorageService,
    ShareService? shareService,
    PrintService? printService,
  })  : _pdfService = pdfService ?? PdfService(),
        _localStorageService = localStorageService ?? LocalStorageService(),
        _shareService = shareService ?? ShareService(),
        _printService = printService ?? PrintService();

  final PdfService _pdfService;
  final LocalStorageService _localStorageService;
  final ShareService _shareService;
  final PrintService _printService;

  Future<File> generateAndSaveSurgeryConsent({
    required SurgeryConsent consent,
  }) async {
    final DateTime createdAt = DateTime.now();

    final pdfBytes = await _pdfService.generateSurgeryConsentPdf(
      consent: consent,
    );

    return _localStorageService.saveConsentPdf(
      pdfBytes: pdfBytes,
      documentNumber: consent.patient.documentNumber,
      createdAt: createdAt,
    );
  }

  Future<File> generateSaveAndShareSurgeryConsent({
    required SurgeryConsent consent,
  }) async {
    final File file = await generateAndSaveSurgeryConsent(
      consent: consent,
    );

    await _shareService.shareConsentPdf(
      file: file,
      patientName: consent.patient.fullName,
    );

    return file;
  }

  Future<File> generateSaveAndPrintSurgeryConsent({
    required SurgeryConsent consent,
  }) async {
    final File file = await generateAndSaveSurgeryConsent(
      consent: consent,
    );

    await _printService.printPdfFile(
      file: file,
      documentName: 'Consentimiento cirugía - ${consent.patient.fullName}',
    );

    return file;
  }

  Future<void> shareExistingPdf({
    required File file,
    required String patientName,
  }) async {
    await _shareService.shareConsentPdf(
      file: file,
      patientName: patientName,
    );
  }

  Future<void> printExistingPdf({
    required File file,
    String documentName = 'Consentimiento informado',
  }) async {
    await _printService.printPdfFile(
      file: file,
      documentName: documentName,
    );
  }
}