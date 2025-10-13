import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inscripcion_provider.dart';
import '../models/solicitud_status.dart';

class EstadoPage extends ConsumerStatefulWidget {
  final String transactionId;
  const EstadoPage({required this.transactionId, super.key});

  @override
  ConsumerState<EstadoPage> createState() => _EstadoPageState();
}

class _EstadoPageState extends ConsumerState<EstadoPage> {
  SolicitudStatus? _status;
  Timer? _timer;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    final notifier = ref.read(inscripcionActionProvider.notifier);
    notifier.startPolling(
      widget.transactionId,
      interval: const Duration(seconds: 2),
      timeout: const Duration(seconds: 60),
    );
    // Also listen to the provider state
    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      final state = ref.read(inscripcionActionProvider);
      state.when(
        data: (map) {
          final parsed = SolicitudStatus.fromJson(map);
          setState(() {
            _status = parsed;
            _loading = parsed.estado == 'procesando';
            _error = null;
          });
          if (parsed.estado == 'procesado') {
            _timer?.cancel();
            notifier.stopPolling();
          }
        },
        loading: () {
          setState(() {
            _loading = true;
          });
        },
        error: (e, st) {
          setState(() {
            _error = e.toString();
            _loading = false;
          });
          _timer?.cancel();
        },
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    ref.read(inscripcionActionProvider.notifier).stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estado de Inscripción')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _error != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: \$_error'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _startPolling(),
                    child: const Text('Reintentar'),
                  ),
                ],
              )
            : _status == null
            ? Center(
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Esperando estado...'),
              )
            : _buildStatusView(),
      ),
    );
  }

  Widget _buildStatusView() {
    if (_status!.estado == 'procesando') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Procesando...'),
        ],
      );
    }

    if (_status!.estado == 'procesado') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 48, color: Colors.green),
          const SizedBox(height: 12),
          const Text(
            'Inscripción procesada',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _status!.datos.length,
              itemBuilder: (context, i) {
                final d = _status!.datos[i];
                return Card(
                  child: ListTile(
                    title: Text('Solicitud ID: \${d.id}'),
                    subtitle: Text(
                      'Fecha: \${d.fecha.toLocal()} • Gestión: \${d.gestionId}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Center(child: Text('Estado: \${_status!.estado}'));
  }
}
