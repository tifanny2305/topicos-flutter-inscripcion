// lib/page/estados/widgets/estado_pendiente.dart
import 'package:flutter/material.dart';

class EstadoPendiente extends StatelessWidget {
  final String transactionId;
  final VoidCallback onVolverInscribir;

  const EstadoPendiente({
    Key? key,
    required this.transactionId,
    required this.onVolverInscribir,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _construirAnimacion(),
            const SizedBox(height: 32),
            _construirTitulo(),
            const SizedBox(height: 16),
            _construirDescripcion(),
            const SizedBox(height: 32),
            //_construirCardInfo(),
            //const SizedBox(height: 24),
            _construirPasosProceso(),
            const SizedBox(height: 32),
            _construirBotones(context),
          ],
        ),
      ),
    );
  }

  Widget _construirAnimacion() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
          ),
        ),
        Icon(
          Icons.schedule,
          size: 48,
          color: Colors.blue.shade700,
        ),
      ],
    );
  }

  Widget _construirTitulo() {
    return const Text(
      'Inscripción en proceso',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _construirDescripcion() {
    return Text(
      'Tu solicitud está siendo procesada.\nPuedes continuar usando la aplicación.',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _construirCardInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          /*children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'ID de Transacción',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              transactionId,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontFamily: 'monospace',
              ),
            ),
          ],*/
        ),
      ),
    );
  }

  Widget _construirPasosProceso() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado del proceso:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _construirPaso(Icons.check_circle, 'Solicitud enviada', true),
            _construirPaso(Icons.pending, 'En cola de procesamiento', true),
            _construirPaso(Icons.circle_outlined, 'Validando disponibilidad', false),
            _construirPaso(Icons.circle_outlined, 'Confirmando inscripción', false),
          ],
        ),
      ),
    );
  }

  Widget _construirPaso(IconData icon, String texto, bool completado) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: completado ? Colors.blue : Colors.grey.shade400,
          ),
          const SizedBox(width: 12),
          Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              color: completado ? Colors.black87 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirBotones(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onVolverInscribir,
            icon: const Icon(Icons.add),
            label: const Text('Inscribir más materias'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.home),
            label: const Text('Ir al inicio'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}