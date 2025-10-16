// lib/page/inscripciones/widgets/action_btn.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/inscripcion_provider.dart';
import '../../estados/detalle_estado_page.dart';

class ActionButtons extends StatelessWidget {
  final List<Map<String, dynamic>> gruposSeleccionados;

  const ActionButtons({
    Key? key,
    required this.gruposSeleccionados,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InscripcionProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.estaCargando
                      ? null
                      : () => _confirmarInscripcion(context, provider),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: provider.estaCargando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 8),
                            Text(
                              'Confirmar Inscripción',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: provider.estaCargando
                      ? null
                      : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmarInscripcion(
    BuildContext context,
    InscripcionProvider provider,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Inscripción'),
        content: Text(
          '¿Deseas inscribir ${gruposSeleccionados.length} ${gruposSeleccionados.length == 1 ? 'materia' : 'materias'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final transactionId = await provider.crearInscripcion(gruposSeleccionados);

    if (!context.mounted) return;

    if (transactionId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Inscripción enviada',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    /*Text(
                      'ID: ${transactionId.substring(0, 8)}...',
                      style: const TextStyle(fontSize: 12),
                    ),*/
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navegar a detalle de estado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleEstadoPage(transactionId: transactionId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text('Error al crear la inscripción'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}