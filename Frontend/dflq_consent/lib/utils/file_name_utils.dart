import 'date_utils.dart';

class FileNameUtils {
  const FileNameUtils._();

  static String buildConsentPdfFileName({
    required String documentNumber,
    required DateTime createdAt,
  }) {
    final cleanDocument = sanitize(documentNumber);
    final date = AppDateUtils.formatFileDate(createdAt);
    final time = AppDateUtils.formatFileTime(createdAt);

    return '${cleanDocument}_${date}_$time.pdf';
  }

  static String sanitize(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w\-]'), '');
  }
}