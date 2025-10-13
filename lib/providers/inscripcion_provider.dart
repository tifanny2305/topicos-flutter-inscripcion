import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/inscripcion_service.dart';
import '../models/solicitud_status.dart';

final inscripcionServiceProvider = Provider((ref) => InscripcionService());

final inscripcionActionProvider =
    StateNotifierProvider<
      InscripcionActionNotifier,
      AsyncValue<Map<String, dynamic>>
    >((ref) => InscripcionActionNotifier(ref));

class InscripcionActionNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref ref; // 🔹 Reemplazamos Reader por Ref
  Timer? _pollTimer;

  InscripcionActionNotifier(this.ref) : super(const AsyncValue.data({}));

  Future<void> iniciar(Map<String, dynamic> body) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(inscripcionServiceProvider);
      final res = await service.iniciarInscripcion(body);
      state = AsyncValue.data(res);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Polling sencillo para consultar estado hasta que sea procesado o timeout.
  void startPolling(
    String transactionId, {
    Duration interval = const Duration(seconds: 2),
    Duration timeout = const Duration(seconds: 30),
  }) {
    final service = ref.read(inscripcionServiceProvider);
    var elapsed = Duration.zero;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (timer) async {
      elapsed += interval;
      try {
        final map = await service.estadoInscripcion(transactionId);
        // actualizar estado con la respuesta completa
        state = AsyncValue.data(map);
        final s = map['Solicitud']?['estado'] as String? ?? '';
        if (s == 'procesado' || elapsed >= timeout) {
          timer.cancel();
        }
      } catch (e, st) {
        // ✅ Pasamos StackTrace.current si no lo capturas
        state = AsyncValue.error(e, st ?? StackTrace.current);
        timer.cancel();
      }
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
