import 'package:flutter/material.dart';

/// Muestra el logo y los títulos.
class EncabezadoWidget extends StatelessWidget {
  const EncabezadoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo o título
        Icon(
          Icons.school,
          size: 80,
          color: Colors.blue.shade700,
        ),
        const SizedBox(height: 24),
        const Text(
          'Sistema de Inscripciones',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Universidad UAGRM',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}