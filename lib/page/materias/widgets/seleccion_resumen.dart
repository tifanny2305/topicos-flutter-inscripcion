import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class SeleccionMateria extends StatelessWidget {
  final MateriaProvider provider;
  const SeleccionMateria({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  '${provider.materiasSeleccionadas.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${provider.materiasSeleccionadas.length} materia(s) seleccionada(s)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          TextButton(
            onPressed: provider.clearSelection,
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }
}
