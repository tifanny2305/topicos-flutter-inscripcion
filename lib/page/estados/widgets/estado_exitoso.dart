import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/models/transacion_inscripcion.dart';

class EstadoExitoso extends StatelessWidget {
  final TransaccionInscripcion transaccion;

  const EstadoExitoso({Key? key, required this.transaccion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _construirIconoExito(),
            const SizedBox(height: 32),
            _construirTitulo(),
            const SizedBox(height: 16),
            _construirMensaje(),
            const SizedBox(height: 32),
            _construirCardDetalles(),
            const SizedBox(height: 32),
            _construirBotones(context),
          ],
        ),
      ),
    );
  }

  Widget _construirIconoExito() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle,
        size: 80,
        color: Colors.green.shade600,
      ),
    );
  }

  Widget _construirTitulo() {
    return const Text(
      '¡Inscripción Exitosa!',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _construirMensaje() {
    return Text(
      'Tu inscripción ha sido procesada correctamente.',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade700,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _construirCardDetalles() {
    final datos = transaccion.datos;
    debugPrint('Transaccion.datos: $datos');

    // si la API devuelve { success, message, data: { ... } } usamos data
    final payload = (datos != null && datos['data'] != null)
        ? datos['data'] as Map<String, dynamic>
        : datos as Map<String, dynamic>?;

    final detalle = (payload?['detalle'] as List<dynamic>?) ?? [];
    final fechaRaw = payload?['fecha'] ?? payload?['created_at'];
    final gestionMap = payload?['gestion'] as Map<String, dynamic>?;

    final fechaStr = _formatearFecha(fechaRaw);
    final gestionStr = (gestionMap != null)
        ? '${gestionMap['periodo'] ?? ''}${(gestionMap['periodo'] != null && gestionMap['ano'] != null) ? '/' : ''}${gestionMap['ano'] ?? ''}'
        : '';

    final estudianteNombre = payload?['estudiante'] != null
        ? (payload!['estudiante']?['nombre'] ?? '')
        : '';
        
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment_turned_in, color: Colors.green.shade700),
                const SizedBox(width: 12),
                const Text(
                  'Detalles de la inscripción',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _construirFilaDetalle(
              Icons.school,
              'Materias inscritas',
              '${detalle.length} ${detalle.length == 1 ? 'materia' : 'materias'}',
            ),
            const SizedBox(height: 12),
            _construirFilaDetalle(
              Icons.person,
              'Estudiante',
              estudianteNombre,
            ),
            const SizedBox(height: 12),
            _construirFilaDetalle(
              Icons.calendar_today,
              'Fecha',
              fechaStr.isNotEmpty ? fechaStr : '',
            ),
            const SizedBox(height: 12),
            _construirFilaDetalle(
              Icons.event,
              'Gestión',
              gestionStr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirFilaDetalle(IconData icono, String etiqueta, String valor) {
    return Row(
      children: [
        Icon(icono, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirBotones(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            label: const Text('Volver al inicio'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  String _formatearFecha(dynamic fechaStr) {
    if (fechaStr == null) return '';
    try {
      final fecha = DateTime.parse(fechaStr);
      return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    } catch (_) {
      return fechaStr.toString();
    }
  }
}