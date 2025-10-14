// lib/page/estado_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inscripcion_provider.dart';

class EstadoPage extends StatefulWidget {
  final String transactionId;

  const EstadoPage({Key? key, required this.transactionId}) : super(key: key);

  @override
  State<EstadoPage> createState() => _EstadoPageState();
}

class _EstadoPageState extends State<EstadoPage> {
  @override
  void initState() {
    super.initState();
    // Iniciar polling al cargar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InscripcionProvider>().iniciarPolling(widget.transactionId);
    });
  }

  @override
  void dispose() {
    // Detener polling al salir
    context.read<InscripcionProvider>().detenerPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider = context.read<InscripcionProvider>();
        
        // Si está procesando, preguntar antes de salir
        if (provider.estadoActual?.isProcesando ?? false) {
          return await _mostrarDialogoSalir(context) ?? false;
        }
        
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estado de Inscripción'),
          backgroundColor: Colors.blue,
        ),
        body: Consumer<InscripcionProvider>(
          builder: (context, provider, child) {
            final estado = provider.estadoActual;

            if (estado == null) {
              return _buildLoadingState();
            }

            if (estado.isProcesando) {
              return _buildProcesandoState(widget.transactionId);
            }

            if (estado.isProcesado) {
              return _buildProcesadoState(estado);
            }

            if (estado.isRechazado) {
              return _buildRechazadoState(estado);
            }

            if (estado.isError) {
              return _buildErrorState(estado);
            }

            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          const Text(
            'Consultando estado...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildProcesandoState(String transactionId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animación de carga
            Stack(
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
                  Icons.school,
                  size: 48,
                  color: Colors.blue.shade700,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Título
            const Text(
              'Procesando tu inscripción',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Descripción
            Text(
              'Estamos validando tu inscripción.\nEsto puede tomar unos segundos.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Card de información
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pasos del proceso
            _buildProcesoSteps(),
          ],
        ),
      ),
    );
  }

  Widget _buildProcesoSteps() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Proceso de inscripción:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildStep(Icons.check_circle, 'Solicitud recibida', true),
            _buildStep(Icons.pending, 'Validando disponibilidad', true),
            _buildStep(Icons.circle_outlined, 'Confirmando inscripción', false),
            _buildStep(Icons.circle_outlined, 'Generando comprobante', false),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(IconData icon, String text, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: completed ? Colors.blue : Colors.grey.shade400,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: completed ? Colors.black87 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcesadoState(estado) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono de éxito
            Container(
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
            ),
            const SizedBox(height: 32),

            // Título
            const Text(
              '¡Inscripción Exitosa!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Mensaje
            Text(
              'Tu inscripción ha sido procesada correctamente.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Card con detalles
            Card(
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
                    _buildDetailRow(Icons.school, 'ID Inscripción', '${estado.datos['id']}'),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.person, 'Estudiante ID', '${estado.datos['estudiante_id']}'),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.event, 'Gestión ID', '${estado.datos['gestion_id']}'),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.calendar_today, 'Fecha', estado.datos['fecha']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Botones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Resetear provider y volver al inicio
                  context.read<InscripcionProvider>().reset();
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
        ),
      ),
    );
  }

  Widget _buildRechazadoState(estado) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono de rechazo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                size: 80,
                color: Colors.orange.shade600,
              ),
            ),
            const SizedBox(height: 32),

            // Título
            const Text(
              'Inscripción Rechazada',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Mensaje
            Text(
              estado.datos['message'] ?? 'No se pudo completar la inscripción',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Card de información
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Posibles razones:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Uno o más grupos no tienen cupos disponibles\n'
                      '• Conflicto de horarios\n'
                      '• Prerequisitos no cumplidos\n'
                      '• Error en la validación',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Botones
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<InscripcionProvider>().reset();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Intentar nuevamente'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<InscripcionProvider>().reset();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Volver al inicio'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(estado) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono de error
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 32),

            // Título
            const Text(
              'Error en la Inscripción',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Mensaje de error
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Mensaje de error:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      estado.error ?? 'Error desconocido',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Botones
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<InscripcionProvider>().reset();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Intentar nuevamente'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<InscripcionProvider>().reset();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Volver al inicio'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
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

  Future<bool?> _mostrarDialogoSalir(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir?'),
        content: const Text(
          'Tu inscripción aún se está procesando. ¿Estás seguro que deseas salir?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}