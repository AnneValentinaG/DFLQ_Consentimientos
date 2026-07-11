import 'dart:io';

import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<ShareResult> sharePdf({
    required File file,
    String subject = 'Consentimiento informado',
    String text = 'Adjunto consentimiento informado en formato PDF.',
  }) async {
    await _validatePdfFile(file);

    return SharePlus.instance.share(
      ShareParams(
        subject: subject,
        text: text,
        files: <XFile>[
          XFile(
            file.path,
            mimeType: 'application/pdf',
            name: file.uri.pathSegments.last,
          ),
        ],
      ),
    );
  }

  Future<ShareResult> shareConsentPdf({
    required File file,
    required String patientName,
  }) async {
    final String cleanPatientName = patientName.trim();

    return sharePdf(
      file: file,
      subject: cleanPatientName.isEmpty
          ? 'Consentimiento informado'
          : 'Consentimiento informado - $cleanPatientName',
      text: cleanPatientName.isEmpty
          ? 'Adjunto consentimiento informado en formato PDF.'
          : 'Adjunto consentimiento informado del paciente $cleanPatientName.',
    );
  }

  Future<void> _validatePdfFile(File file) async {
    final bool exists = await file.exists();

    if (!exists) {
      throw FileSystemException(
        'El archivo no existe y no puede ser compartido.',
        file.path,
      );
    }

    if (!file.path.toLowerCase().endsWith('.pdf')) {
      throw ArgumentError('Solo se permite compartir archivos PDF.');
    }

    final int size = await file.length();

    if (size == 0) {
      throw FileSystemException(
        'El archivo PDF está vacío y no puede ser compartido.',
        file.path,
      );
    }
  }
}