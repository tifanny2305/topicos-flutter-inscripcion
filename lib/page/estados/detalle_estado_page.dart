import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/page/estados/widgets/estado_fallido.dart';
import '../../providers/inscripcion_provider.dart';
import 'widgets/estado_pendiente.dart';
import 'widgets/estado_exitoso.dart';

class DetalleEstadoPage extends StatefulWidget {
  final String transactionId;

  const DetalleEstadoPage({Key? key, required this.transactionId})
    : super(key: key);

  @override
  State<DetalleEstadoPage> createState() => _DetalleEstadoPageState();
}

class _DetalleEstadoPageState extends State<DetalleEstadoPage> {
  late InscripcionProvider _provider;
  bool _haIniciadoPolling = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = context.read<InscripcionProvider>();

    if (!_haIniciadoPolling) {
      _haIniciadoPolling = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.establecerTransaccionActual(widget.transactionId);
        _provider.consultarEstado(widget.transactionId);
        _provider.iniciarPolling(widget.transactionId);
      });
    }
  }

  @override
  void dispose() {
    //_provider.detenerPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Inscripción'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<InscripcionProvider>(
        builder: (context, provider, _) {
          final transaccion = provider.transaccionActual;

          if (transaccion == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (transaccion.esPendiente) {
            return EstadoPendiente(
              transactionId: widget.transactionId,
              onVolverInscribir: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          }

          if (transaccion.estaProcesado) {
            return EstadoExitoso(transaccion: transaccion);
          }

          if (transaccion.tieneError) {
            return EstadoFallido(transaccion: transaccion);
          }

          // Para rechazado (implementar después)
          return const Center(child: Text('Estado no reconocido'));
        },
      ),
    );
  }
}
