// lib/pages/inscripcion_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/endpoints.dart';
import '../providers/inscripcion_provider.dart';

class InscripcionPage extends StatelessWidget {
  final List<Map<String, dynamic>> gruposSeleccionados;

  const InscripcionPage({Key? key, required this.gruposSeleccionados}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Inscripción'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<InscripcionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Banner de modo prueba
              _buildTestBanner(),

              // Lista de grupos
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Materias y Grupos Seleccionados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...gruposSeleccionados.map((grupo) => _construirGrupoCard(grupo)),
                    const SizedBox(height: 16),
                    //_buildInfoCard(),
                  ],
                ),
              ),

              // Botones de acción
              _buildActionButtons(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTestBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.amber.shade100,
      child: Row(
        children: [
          Icon(Icons.person, color: Colors.amber.shade900),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modo de prueba',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                Text(
                  'Estudiante ID ${Endpoints.estudianteId} • Gestión ${Endpoints.gestionId}-${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirGrupoCard(Map<String, dynamic> grupo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          grupo['materiaSigla'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Grupo ${grupo['grupoSigla']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    grupo['materiaNombre'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Docente ID: ${grupo['docenteId']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  /*Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Información importante',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('• Tu inscripción será procesada de forma asíncrona', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            const Text('• Los cupos son limitados y se asignan por orden de llegada', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            const Text('• Recibirás una notificación del estado', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            const Text('• Estados posibles: Procesando, Confirmado o Rechazado', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }*/

  Widget _buildActionButtons(BuildContext context, InscripcionProvider provider) {
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

  Future<void> _confirmarInscripcion(BuildContext context, InscripcionProvider provider) async {
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