import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../utils/date_utils.dart';
import '../utils/file_name_utils.dart';

class LocalStorageService {
  static const String _rootFolderName = 'Consentimientos';

  Future<File> saveConsentPdf({
    required Uint8List pdfBytes,
    required String documentNumber,
    required DateTime createdAt,
  }) async {
    if (pdfBytes.isEmpty) {
      throw ArgumentError('No se puede guardar un PDF vacío.');
    }

    if (documentNumber.trim().isEmpty) {
      throw ArgumentError('El número de documento no puede estar vacío.');
    }

    final Directory directory = await _getMonthlyConsentDirectory(createdAt);

    final String fileName = FileNameUtils.buildConsentPdfFileName(
      documentNumber: documentNumber,
      createdAt: createdAt,
    );

    final File file = File(
      '${directory.path}${Platform.pathSeparator}$fileName',
    );

    return file.writeAsBytes(pdfBytes, flush: true);
  }

  Future<Directory> _getMonthlyConsentDirectory(DateTime date) async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();

    final String yearMonth = AppDateUtils.formatYearMonthFolder(date);

    final Directory consentDirectory = Directory(
      '${appDirectory.path}'
      '${Platform.pathSeparator}$_rootFolderName'
      '${Platform.pathSeparator}$yearMonth',
    );

    if (!await consentDirectory.exists()) {
      await consentDirectory.create(recursive: true);
    }

    return consentDirectory;
  }

  Future<bool> exists(String path) async {
    if (path.trim().isEmpty) {
      return false;
    }

    return File(path).exists();
  }

  Future<List<File>> getConsentPdfsByMonth(DateTime date) async {
    final Directory directory = await _getMonthlyConsentDirectory(date);

    if (!await directory.exists()) {
      return <File>[];
    }

    final List<FileSystemEntity> entities = await directory.list().toList();

    return entities
        .whereType<File>()
        .where((File file) => file.path.toLowerCase().endsWith('.pdf'))
        .toList();
  }

  Future<Directory> getConsentRootDirectory() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();

    final Directory rootDirectory = Directory(
      '${appDirectory.path}${Platform.pathSeparator}$_rootFolderName',
    );

    if (!await rootDirectory.exists()) {
      await rootDirectory.create(recursive: true);
    }

    return rootDirectory;
  }
}