// --------------------------------
// FILE: lib/pages/inscripcion_page.dart
// --------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/materia.dart';
import '../models/grupo.dart';
import '../providers/inscripcion_provider.dart';
import 'estado_page.dart';

class InscripcionPage extends ConsumerWidget {
  final Materia materia;
  final Grupo grupo;

  const InscripcionPage({
    required this.materia,
    required this.grupo,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(inscripcionActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Inscripción')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Materia: ${materia.nombre}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Grupo: ${grupo.codigo} • ${grupo.turno}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final notifier = ref.read(inscripcionActionProvider.notifier);

                // 🔹 Ejemplo de cuerpo que envías al backend
                final body = {
                  'estudiante_id': 1,
                  'grupo_id': grupo.id,
                  'gestion_id': 5,
                };

                await notifier.iniciar(body);

                final result = ref
                    .read(inscripcionActionProvider)
                    .maybeWhen(data: (d) => d, orElse: () => {});

                final transactionId =
                    (result as Map)['transaction_id'] as String?;

                if (transactionId != null) {
                  // 🔹 Empieza el polling y navega a la página de estado
                  notifier.startPolling(transactionId);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EstadoPage(transactionId: transactionId),
                    ),
                  );
                } else {
                  // 🔹 Si la API no devolvió transaction_id
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Respuesta inesperada del servidor'),
                    ),
                  );
                }
              },
              child: const Text('Confirmar inscripción'),
            ),
            const SizedBox(height: 20),
            actionState.when(
              data: (d) => d.isNotEmpty
                  ? Text(
                      'Respuesta: ${d['status'] ?? d['message'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    )
                  : const SizedBox.shrink(),
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: LinearProgressIndicator(),
              ),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
