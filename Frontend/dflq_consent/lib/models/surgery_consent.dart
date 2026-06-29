// lib/models/surgery_consent.dart

import 'package:dflq_consent/models/patient.dart';
import 'package:dflq_consent/models/signature_data.dart';

class SurgeryConsent {
  const SurgeryConsent({
    required this.date,
    required this.patient,
    required this.doctorName,
    required this.procedure,
    required this.teeth,
    required this.signature,
  });

  final DateTime date;
  final Patient patient;
  final String doctorName;
  final String procedure;
  final String teeth;
  final SignatureData signature;
}