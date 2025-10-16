import 'package:flutter/material.dart';
import '../../../providers/grupo_provider.dart';

class BotonContinuar extends StatelessWidget {
  final GrupoProvider provider;

  const BotonContinuar({super.key, required this.provider});

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${provider.materiasConGrupos.length} materias',
                    style: const TextStyle(fontSize: 12)),
                Text(
                  provider.tieneAlMenosUnaSeleccionada
                      ? '${provider.materiasSeleccionadas} seleccionada(s)'
                      : 'Selecciona al menos un grupo',
                  style: TextStyle(
                    fontSize: 12,
                    color: provider.tieneAlMenosUnaSeleccionada
                        ? Colors.green
                        : Colors.amber.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.tieneAlMenosUnaSeleccionada
                    ? () {
                        final gruposSeleccionados = provider.obtenerGruposSeleccionados();
                        Navigator.pushNamed(context, '/inscripcion',
                            arguments: gruposSeleccionados);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  'Continuar a inscripción',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
