// lib/models/signature_data.dart

import 'dart:typed_data';

class SignatureData {
  const SignatureData({
    required this.pngBytes,
    required this.signedAt,
  });

  final Uint8List pngBytes;
  final DateTime signedAt;
}