import 'dart:io';
import 'dart:typed_data';

import 'package:printing/printing.dart';

class PrintService {
    Future<void> printPdfFile({
        required File file,
        String documentName = 'Consentimiento informado',
    }) async {
        await _validatePdfFile(file);

        final Uint8List pdfBytes = await file.readAsBytes();

        await printPdfBytes(
        pdfBytes: pdfBytes,
        documentName: documentName,
        );
    }

    Future<void> printPdfBytes({
        required Uint8List pdfBytes,
        String documentName = 'Consentimiento informado',
    }) async {
        if (pdfBytes.isEmpty) {
        throw ArgumentError('No se puede imprimir un PDF vacío.');
        }

        await Printing.layoutPdf(
        name: documentName,
        onLayout: (_) async => pdfBytes,
        );
    }

    Future<void> _validatePdfFile(File file) async {
        final bool exists = await file.exists();

        if (!exists) {
        throw FileSystemException(
            'El archivo no existe y no puede ser impreso.',
            file.path,
        );
        }

        if (!file.path.toLowerCase().endsWith('.pdf')) {
        throw ArgumentError('Solo se permite imprimir archivos PDF.');
        }

        final int size = await file.length();

        if (size == 0) {
        throw FileSystemException(
            'El archivo PDF está vacío y no puede ser impreso.',
            file.path,
        );
        }
    }
}