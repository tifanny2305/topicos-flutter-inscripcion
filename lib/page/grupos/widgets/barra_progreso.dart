import 'package:flutter/material.dart';
import '../../../providers/grupo_provider.dart';

class BarraProgreso extends StatelessWidget {
  final GrupoProvider provider;

  const BarraProgreso({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progreso de selección',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${provider.progresoSeleccion}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: provider.progresoSeleccion / 100,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blue,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${provider.materiasSeleccionadas} de ${provider.materiasConGrupos.length} materias con grupo seleccionado',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
