import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class BotonContinuar extends StatelessWidget {
  final MateriaProvider provider;
  const BotonContinuar({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: provider.materiasSeleccionadas.isEmpty
                ? null
                : () => Navigator.pushNamed(
                      context,
                      '/grupos',
                      arguments: provider.materiasSeleccionadas,
                    ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: const Text(
              'Continuar a grupos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
