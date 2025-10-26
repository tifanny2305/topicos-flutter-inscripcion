import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class BotonContinuarWidget extends StatelessWidget {
  final MateriaProvider provider;
  const BotonContinuarWidget({Key? key, required this.provider})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      // Sombra fuerte para destacarlo como un área de acción
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, -3), // Sombra hacia arriba
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // El botón se deshabilita si no hay selecciones
            onPressed: provider.materiasSeleccionadas.isEmpty
                ? null
                : () => Navigator.pushNamed(
                    context,
                    '/grupos',
                    // Usamos el getter en español
                    arguments: provider.materiasSeleccionadas,
                  ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue.shade600,
              // Gris oscuro para deshabilitado (mejor UX)
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'CONTINUAR A GRUPOS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
