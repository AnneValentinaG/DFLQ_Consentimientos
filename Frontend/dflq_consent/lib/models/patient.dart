// lib/models/patient.dart

class Patient {
  const Patient({
    required this.fullName,
    required this.documentNumber,
    required this.documentIssuePlace,
    this.age,
    this.legalRepresentativeName,
    this.legalRepresentativeDocument,
  });

  final String fullName;
  final String documentNumber;
  final String documentIssuePlace;
  final int? age;
  final String? legalRepresentativeName;
  final String? legalRepresentativeDocument;

  bool get isMinor => age != null && age! < 18;

  bool get hasLegalRepresentative {
    return legalRepresentativeName != null &&
        legalRepresentativeName!.trim().isNotEmpty;
  }
}