import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/models/transacion_inscripcion.dart';
import 'inscripcion_provider.dart';

class EstadoInscripcionProvider with ChangeNotifier {
  String _estadoActual = 'Sin iniciar';
  String get estadoActual => _estadoActual;

  void escucharCambios(InscripcionProvider inscripcionProvider) {
    final TransaccionInscripcion? t = inscripcionProvider.transaccionActual;

    if (t == null) {
      _estadoActual = 'Sin iniciar';
    } else if (t.esPendiente) {
      _estadoActual = 'Procesando...';
    } else if (t.estaProcesado) {
      _estadoActual = 'Completado ✅';
    } else if (t.tieneError) {
      _estadoActual = 'Error ❌';
    }

    notifyListeners();
  }
}
