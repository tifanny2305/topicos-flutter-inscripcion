// lib/page/estados/lista_estados_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inscripcion_provider.dart';
import 'widgets/tarjeta_transaccion.dart';

class ListaEstadosPage extends StatefulWidget {
  const ListaEstadosPage({Key? key}) : super(key: key);

  @override
  State<ListaEstadosPage> createState() => _ListaEstadosPageState();
}

class _ListaEstadosPageState extends State<ListaEstadosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InscripcionProvider>().actualizarTransaccionesPendientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Inscripciones'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Limpiar completadas'),
                  content: const Text(
                    '¿Eliminar todas las inscripciones completadas?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Limpiar'),
                    ),
                  ],
                ),
              );

              if (confirmar == true) {
                context
                    .read<InscripcionProvider>()
                    .limpiarTransaccionesProcesadas();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Inscripciones completadas eliminadas'),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<InscripcionProvider>()
                  .actualizarTransaccionesPendientes();
            },
          ),
        ],
      ),
      body: Consumer<InscripcionProvider>(
        builder: (context, provider, _) {
          if (provider.transacciones.isEmpty) {
            return _construirVacio();
          }

          return RefreshIndicator(
            onRefresh: () => provider.actualizarTransaccionesPendientes(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Transacciones pendientes
                if (provider.transaccionesPendientes.isNotEmpty) ...[
                  _construirTitulo('En proceso', Icons.schedule, Colors.orange),
                  const SizedBox(height: 12),
                  ...provider.transaccionesPendientes.map(
                    (t) => TarjetaTransaccion(transaccion: t),
                  ),
                  const SizedBox(height: 24),
                ],

                // Transacciones con error
                if (provider.transaccionesError.isNotEmpty) ...[
                  _construirTitulo('Fallidas', Icons.error, Colors.red),
                  const SizedBox(height: 12),
                  ...provider.transaccionesError.map(
                    (t) => TarjetaTransaccion(
                      transaccion: t, // NO PASAR tipoError
                    ),
                  ),
                ],

                // Transacciones procesadas
                if (provider.transaccionesProcesadas.isNotEmpty) ...[
                  _construirTitulo(
                    'Completadas',
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  ...provider.transaccionesProcesadas.map(
                    (t) => TarjetaTransaccion(transaccion: t),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _construirVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes inscripciones',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Realiza una inscripción para verla aquí',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _construirTitulo(String titulo, IconData icono, Color color) {
    return Row(
      children: [
        Icon(icono, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
