import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class ResumenSeleccionWidget extends StatelessWidget {
  final MateriaProvider provider;
  const ResumenSeleccionWidget({Key? key, required this.provider})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cantidad = provider.materiasSeleccionadas.length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // Ajuste de padding
      color: Colors.blue.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar con el contador de materias
              CircleAvatar(
                backgroundColor: Colors.blue.shade700,
                child: Text(
                  '$cantidad',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Texto del resumen
              Text(
                '$cantidad materia(s) seleccionada(s)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          // Botón para limpiar la selección
          TextButton(
            // Usamos el método en español
            onPressed: provider.limpiarSeleccion,
            child: Text(
              'Limpiar',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
