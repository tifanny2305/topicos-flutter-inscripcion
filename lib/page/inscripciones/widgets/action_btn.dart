import 'package:flutter/material.dart';
import '../../../providers/inscripcion_provider.dart';

class ActionButtons extends StatelessWidget {
  final InscripcionProvider provider;
  final List<Map<String, dynamic>> gruposSeleccionados;

  const ActionButtons({
    Key? key,
    required this.provider,
    required this.gruposSeleccionados,
  }) : super(key: key);

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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: provider.isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Modificar selección'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () => _confirmarInscripcion(context, provider),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirmar Inscripción',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarInscripcion(
      BuildContext context, InscripcionProvider provider) async {
    final gruposIds = gruposSeleccionados.map((g) => g['grupoId'] as int).toList();

    await provider.crearInscripcion(gruposIds);

    if (provider.response != null && context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/estado',
        arguments: provider.response!.transactionId,
      );
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${provider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
