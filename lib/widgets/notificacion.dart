import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/models/transacion_inscripcion.dart';
import '../providers/inscripcion_provider.dart';
import '../app.dart'; // <-- trae navigatorKey y scaffoldMessengerKey

class NotificacionListener extends StatefulWidget {
  final Widget child;

  const NotificacionListener({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificacionListener> createState() => _NotificacionListenerState();
}

class _NotificacionListenerState extends State<NotificacionListener> {
  TransaccionInscripcion? _last;

  @override
  Widget build(BuildContext context) {
    // Usar Consumer para asegurarnos que el provider ya está disponible
    return Consumer<InscripcionProvider>(
      builder: (context, provider, _) {
        // registrar callback (idempotente)
        provider.onTransaccionCompletada = _mostrarNotificacion;
        return widget.child;
      },
    );
  }

  void _mostrarNotificacion(TransaccionInscripcion transaccion) {
    // evitar mostrar la misma notificación repetida
    if (!mounted) return;
    if (_last != null && _last!.transactionId == transaccion.transactionId) return;
    _last = transaccion;

    final esExitosa = transaccion.estaProcesado;
    final cantidadMaterias = transaccion.gruposIds.length;

    // obtener un context válido desde la navigatorKey (MaterialApp tiene la key)
    final ctx = navigatorKey.currentContext ?? context;

    // Dialog
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: esExitosa ? Colors.green.shade100 : Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                esExitosa ? Icons.check_circle : Icons.warning,
                color: esExitosa ? Colors.green.shade700 : Colors.orange.shade700,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                esExitosa ? '¡Inscripción Exitosa!' : 'Inscripción Procesada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: esExitosa ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              esExitosa
                  ? 'Tu inscripción de $cantidadMaterias ${cantidadMaterias == 1 ? 'materia' : 'materias'} se completó correctamente.'
                  : transaccion.mensaje ?? 'Tu inscripción ha sido procesada con observaciones.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            /*Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              /*child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ID: ${transaccion.transactionId.substring(0, 8)}...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),*/
            ),*/
          ],
        ),
        actions: [
          if (!esExitosa)
            TextButton(
              onPressed: () => navigatorKey.currentState?.pop(),
              child: const Text('Ver detalles'),
            ),
          ElevatedButton(
            onPressed: () => navigatorKey.currentState?.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: esExitosa ? Colors.green : Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    // Snack via scaffoldMessengerKey
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(esExitosa ? Icons.check_circle : Icons.warning, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  esExitosa ? 'Inscripción completada exitosamente' : 'Inscripción procesada con observaciones',
                ),
              ),
            ],
          ),
          backgroundColor: esExitosa ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () {
              // ir a detalle si quieres
            },
          ),
        ),
      );
    }
  }
}