import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/models/transacion_inscripcion.dart';
import '../detalle_estado_page.dart';

class TarjetaTransaccion extends StatelessWidget {
  final TransaccionInscripcion transaccion;

  const TarjetaTransaccion({Key? key, required this.transaccion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleEstadoPage(
                transactionId: transaccion.transactionId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _construirIconoEstado(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _obtenerTitulo(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatearFecha(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _construirBadge(),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.school, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    '${transaccion.gruposIds.length} ${transaccion.gruposIds.length == 1 ? 'materia' : 'materias'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirIconoEstado() {
    if (transaccion.esPendiente) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.schedule, color: Colors.orange.shade700, size: 24),
      );
    }

    if (transaccion.estaProcesado) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_circle, color: Colors.green.shade700, size: 24),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.error, color: Colors.red.shade700, size: 24),
    );
  }

  Widget _construirBadge() {
    Color color;
    String texto;

    if (transaccion.esPendiente) {
      color = Colors.orange;
      texto = 'En proceso';
    } else if (transaccion.estaProcesado) {
      color = Colors.green;
      texto = 'Completado';
    } else {
      color = Colors.red;
      texto = 'Rechazado';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _obtenerTitulo() {
    if (transaccion.esPendiente) {
      return 'Inscripción en proceso';
    }
    if (transaccion.estaProcesado) {
      return 'Inscripción completada';
    }
    return 'Inscripción rechazada';
  }

  String _formatearFecha() {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(transaccion.fechaCreacion);

    if (diferencia.inMinutes < 1) {
      return 'Hace unos segundos';
    } else if (diferencia.inHours < 1) {
      return 'Hace ${diferencia.inMinutes} min';
    } else if (diferencia.inDays < 1) {
      return 'Hace ${diferencia.inHours} horas';
    } else {
      return '${transaccion.fechaCreacion.day.toString().padLeft(2, '0')}/${transaccion.fechaCreacion.month.toString().padLeft(2, '0')}/${transaccion.fechaCreacion.year}';
    }
  }
}