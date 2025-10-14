import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/endpoints.dart';
import '../models/inscripcion_request.dart';
import '../models/inscripcion_response.dart';
import '../models/estado_inscripcion.dart';
import '../services/inscripcion_service.dart';

class InscripcionProvider with ChangeNotifier {
  final InscripcionService _service = InscripcionService();

  bool _isLoading = false;
  String? _error;
  InscripcionResponse? _response;
  EstadoInscripcion? _estadoActual;
  Timer? _pollingTimer;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  InscripcionResponse? get response => _response;
  EstadoInscripcion? get estadoActual => _estadoActual;

  // Métodos
  Future<void> crearInscripcion(List<int> gruposIds) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final request = InscripcionRequest(
        estudianteId: Endpoints.estudianteId,
        gestionId: Endpoints.gestionId,
        fecha: fecha,
        grupos: gruposIds,
      );

      _response = await _service.crearInscripcion(request);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void iniciarPolling(String transactionId) {
    // Primera consulta inmediata
    consultarEstado(transactionId);

    // Polling cada 3 segundos
    _pollingTimer = Timer.periodic(
      Duration(seconds: Endpoints.pollingIntervalSeconds),
      (_) => consultarEstado(transactionId),
    );
  }

  Future<void> consultarEstado(String transactionId) async {
    try {
      final estado = await _service.consultarEstado(transactionId);
      _estadoActual = estado;

      // Detener polling si está procesado, rechazado o con error
      if (estado.isProcesado || estado.isRechazado || estado.isError) {
        detenerPolling();
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _estadoActual = EstadoInscripcion(estado: 'error', error: e.toString());
      detenerPolling();
      notifyListeners();
    }
  }

  void detenerPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void reset() {
    _isLoading = false;
    _error = null;
    _response = null;
    _estadoActual = null;
    detenerPolling();
    notifyListeners();
  }

  @override
  void dispose() {
    detenerPolling();
    super.dispose();
  }
}
