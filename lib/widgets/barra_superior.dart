import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/providers/inscripcion_provider.dart';
import 'package:topicos_inscripciones/page/estados/list_estado_page.dart';

class BarraSuperior extends StatelessWidget
  implements PreferredSizeWidget {
  
  // Título fijo para mantener la identidad de la aplicación
  static const String tituloFijo = 'UAGRM - Sistema de Inscripciones';

  @override
  final Size preferredSize; 

  const BarraSuperior({
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        tituloFijo,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      // Color fijo
      backgroundColor: Colors.blue.shade800, 
      elevation: 4,
      actions: [
        // Widget encapsulado para la notificación
        const _BotonNotificacionEstados(), 
        const SizedBox(width: 8),
      ],
    );
  }
}

/// Widget Privado y Encapsulado: Muestra el ícono de lista con la burbuja de notificación.
class _BotonNotificacionEstados extends StatelessWidget {
  const _BotonNotificacionEstados();

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para escuchar solo los cambios relevantes del Provider.
    return Consumer<InscripcionProvider>(
      builder: (context, inscripcionProvider, _) {
        final cantidadPendientes = inscripcionProvider.cantidadPendientes;

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white), // Usamos un icono de notificación más estándar
              onPressed: () {
                // Navegación
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListaEstadosPage(),
                  ),
                );
              },
              tooltip: 'Ver notificaciones y estados de inscripciones',
            ),
            if (cantidadPendientes > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red, // Rojo para urgencia (mejor UX para notificar)
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$cantidadPendientes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}