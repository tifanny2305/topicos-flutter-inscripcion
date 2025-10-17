import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topicos_inscripciones/app.dart';
import 'package:topicos_inscripciones/models/transacion_inscripcion.dart';
import '../models/inscripcion_request.dart';
import '../services/inscripcion_service.dart';
import '../core/endpoints.dart';

class InscripcionProvider with ChangeNotifier {
  final InscripcionService _service = InscripcionService();

  List<TransaccionInscripcion> _transacciones = [];
  TransaccionInscripcion? _transaccionActual;
  Timer? _pollingTimer;
  bool _estaCargando = false;



  // Callback para notificaciones
  Function(TransaccionInscripcion)? onTransaccionCompletada;

  // Getters
  List<TransaccionInscripcion> get transacciones => _transacciones;
  TransaccionInscripcion? get transaccionActual => _transaccionActual;
  bool get estaCargando => _estaCargando;

  List<TransaccionInscripcion> get transaccionesPendientes =>
      _transacciones.where((t) => t.esPendiente).toList();

  List<TransaccionInscripcion> get transaccionesProcesadas =>
      _transacciones.where((t) => t.estaProcesado).toList();

  int get cantidadPendientes => transaccionesPendientes.length;

  // Constructor
  InscripcionProvider() {
    _cargarTransaccionesLocales();
    limpiarTransaccionesAntiguas();
  }

  // Crear inscripción
  Future<String?> crearInscripcion(List<Map<String, dynamic>> grupos) async {
    print('📝 [INSCRIPCION] Iniciando creación de inscripción...');
    _estaCargando = true;
    notifyListeners();

    try {
      final gruposIds = grupos.map((g) => g['grupoId'] as int).toList();
      print('📝 [INSCRIPCION] Grupos a inscribir: $gruposIds');

      final request = InscripcionRequest(
        estudianteId: Endpoints.estudianteId,
        gestionId: Endpoints.gestionId,
        fecha: DateTime.now().toIso8601String().split('T')[0],
        grupos: gruposIds,
      );

      print('📝 [INSCRIPCION] Enviando petición al servidor...');
      final response = await _service.crearInscripcion(request);
      print(
        '✅ [INSCRIPCION] Respuesta recibida - Transaction ID: ${response.transactionId}',
      );

      final transaccion = TransaccionInscripcion.desdeRespuestaInicial(
        transactionId: response.transactionId,
        gruposIds: gruposIds,
      );

      _transacciones.insert(0, transaccion);
      _transaccionActual = transaccion;
      await _guardarTransaccionesLocales();
      print('💾 [INSCRIPCION] Transacción guardada localmente');

      _estaCargando = false;
      notifyListeners();

      return response.transactionId;
    } catch (e) {
      print('❌ [INSCRIPCION] Error al crear inscripción: $e');
      _estaCargando = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> consultarEstado(String transactionId) async {
    final shortId = transactionId.substring(0, 8);
    print('🔍 [POLLING] Consultando estado de transacción: $shortId...');

    try {
      // Obtener estado desde el servicio
      final estadoResponse = await _service.consultarEstado(transactionId);
      print(
        '📡 [POLLING] Respuesta recibida - Estado: ${estadoResponse.estado}',
      );

      final index = _transacciones.indexWhere(
        (t) => t.transactionId == transactionId,
      );
      if (index == -1) {
        print('⚠️ [POLLING] Transacción no encontrada en la lista local');
        return;
      }

      final transaccionExistente = _transacciones[index];

      // Crear copia base de la transacción
      TransaccionInscripcion transaccionActualizada =
          TransaccionInscripcion.desdeConsulta(
            transactionId,
            {
              'Solicitud': {
                'estado': estadoResponse.estado,
                'datos': estadoResponse.datos,
                'message': estadoResponse.error,
              },
            },
            transaccionExistente.gruposIds,
            transaccionExistente.fechaCreacion,
          );

      // --- Detectar errores según el código del backend
      final datosResp = estadoResponse.datos as Map<String, dynamic>? ?? {};
      final code = datosResp['code'] as int?;
      final message = (datosResp['message'] ?? estadoResponse.error ?? '')
          .toString();

      if (code == 409 || code == 422) {
        print('⚠️ [POLLING] Error detectado: code=$code');

        final solicitud = Map<String, dynamic>.from(
          transaccionActualizada.datos ?? {},
        );
        solicitud['code'] = code;
        solicitud['message'] = code == 409
            ? 'Conflicto de horarios detectado entre grupos.'
            : 'Uno o más grupos no tienen cupos disponibles.';

        // Crear transacción marcada como error
        transaccionActualizada = TransaccionInscripcion.desdeConsulta(
          transactionId,
          {
            'Solicitud': {
              'estado': 'error',
              'datos': solicitud,
              'message': solicitud['message'],
              'tipoError': code == 409 ? 'choque' : 'cupo',
            },
          },
          transaccionExistente.gruposIds,
          transaccionExistente.fechaCreacion,
        );

        _transacciones[index] = transaccionActualizada;
        _transaccionActual = transaccionActualizada;

        print('❌ [POLLING] Transacción marcada como error ($code)');
        await _guardarTransaccionesLocales();
        notifyListeners();
        return; // detener aquí, ya se actualizó la transacción
      }

      // --- Actualizar transacción normal si no hubo error
      _transacciones[index] = transaccionActualizada;
      _transaccionActual = transaccionActualizada;
      notifyListeners();

      print('✅ [POLLING] Transacción actualizada correctamente');
    } catch (e) {
      print('❌ [POLLING] Error al consultar estado: $e');
    }
  }

  // Iniciar polling
  void iniciarPolling(String transactionId) {
    final shortId = transactionId.substring(0, 8);
    print('🚀 [POLLING] Iniciando polling para transacción: $shortId...');
    print('⏰ [POLLING] Frecuencia: cada 7 segundos');

    detenerPolling();

    int intentos = 0;
    const maxIntentos = 2;
    _pollingTimer = Timer.periodic(
      Duration(seconds: Endpoints.pollingIntervalSeconds),
      (timer) async {
        intentos++;
        print(
          '\n🔄 [POLLING] Intento #$intentos - ${DateTime.now().toString().split('.')[0]}',
        );

        await consultarEstado(transactionId);

        if (intentos >= maxIntentos) {
          print('Se alcanzó el número máximo de intentos');
          detenerPolling();
          navigatorKey.currentState?.pushNamedAndRemoveUntil('/materias', (route) => false);
        }

        final transaccion = _transacciones.firstWhere(
          (t) => t.transactionId == transactionId,
          orElse: () => _transaccionActual!,
        );

        if (!transaccion.esPendiente) {
          print(
            '🛑 [POLLING] Deteniendo polling - Estado final: ${transaccion.estado}',
          );
          print('📊 [POLLING] Total de intentos: $intentos');
          print('⏱️ [POLLING] Tiempo total: ${intentos * 3} segundos\n');
          detenerPolling();
        }
      },
    );
  }

  // Detener polling
  void detenerPolling() {
    if (_pollingTimer != null) {
      print('⏹️ [POLLING] Polling detenido');
      _pollingTimer?.cancel();
      _pollingTimer = null;
    }
  }

  // Actualizar todas las transacciones pendientes
  Future<void> actualizarTransaccionesPendientes() async {
    final pendientes = transaccionesPendientes;

    if (pendientes.isEmpty) {
      print('ℹ️ [UPDATE] No hay transacciones pendientes para actualizar');
      return;
    }

    print(
      '🔄 [UPDATE] Actualizando ${pendientes.length} transacciones pendientes...',
    );

    for (var transaccion in pendientes) {
      await consultarEstado(transaccion.transactionId);
    }

    print('✅ [UPDATE] Actualización completada\n');
  }

  // Establecer transacción actual
  void establecerTransaccionActual(String transactionId) {
    _transaccionActual = _transacciones.firstWhere(
      (t) => t.transactionId == transactionId,
      orElse: () => _transaccionActual!,
    );
    notifyListeners();
  }

  // Guardar transacciones localmente
  Future<void> _guardarTransaccionesLocales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _transacciones.map((t) => t.toJson()).toList();
      await prefs.setString('transacciones', jsonEncode(jsonList));
      /*print(
        '💾 [STORAGE] ${_transacciones.length} transacciones guardadas localmente',
      );*/
    } catch (e) {
      print('❌ [STORAGE] Error al guardar transacciones: $e');
    }
  }

  // Cargar transacciones desde local
  Future<void> _cargarTransaccionesLocales() async {
    try {
      print('📂 [STORAGE] Cargando transacciones locales...');
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('transacciones');

      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _transacciones = jsonList
            .map((json) => TransaccionInscripcion.fromJson(json))
            .toList();

        print('📂 [STORAGE] ${_transacciones.length} transacciones cargadas');
        print('📂 [STORAGE] Pendientes: ${transaccionesPendientes.length}');
        print('📂 [STORAGE] Procesadas: ${transaccionesProcesadas.length}');

        if (transaccionesPendientes.isNotEmpty) {
          print('🔄 [STORAGE] Actualizando transacciones pendientes...');
          await actualizarTransaccionesPendientes();
        }

        notifyListeners();
      } else {
        print('📂 [STORAGE] No hay transacciones guardadas');
      }
    } catch (e) {
      print('❌ [STORAGE] Error al cargar transacciones: $e');
    }
  }

  // Limpiar transacciones procesadas
  Future<void> limpiarTransaccionesProcesadas() async {
    _transacciones.removeWhere((t) => t.estaProcesado);
    await _guardarTransaccionesLocales();
    notifyListeners();
  }

  // En inscripcion_provider.dart

  Future<void> limpiarTransaccionesAntiguas({int diasMaximos = 7}) async {
    final ahora = DateTime.now();
    _transacciones.removeWhere(
      (t) =>
          t.estaProcesado &&
          ahora.difference(t.fechaCreacion).inDays > diasMaximos,
    );
    await _guardarTransaccionesLocales();
    print('🗑️ [STORAGE] Transacciones antiguas eliminadas');
    notifyListeners();
  }

  // Reset
  void reset() {
    _transaccionActual = null;
    detenerPolling();
    notifyListeners();
  }

  @override
  void dispose() {
    detenerPolling();
    super.dispose();
  }
}
