import 'package:flutter/material.dart';

void main() {
  runApp(const DentalConsentApp());
}

class DentalConsentApp extends StatelessWidget {
  const DentalConsentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consentimiento Informado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Etapa 1: Arquitectura lista',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}