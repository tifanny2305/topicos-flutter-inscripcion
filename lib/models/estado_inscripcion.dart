class EstadoInscripcion {
  final String estado; // procesando, procesado, rechazado, error
  final dynamic datos;
  final String? error;

  EstadoInscripcion({
    required this.estado,
    this.datos,
    this.error,
  });

  factory EstadoInscripcion.fromJson(Map<String, dynamic> json) {
    // Manejar respuesta inicial con 'status'
    if (json.containsKey('status')) {
      return EstadoInscripcion(
        estado: json['status'],
        datos: null,
        error: null,
      );
    }
    
    // Manejar respuesta con 'Solicitud'
    if (json.containsKey('Solicitud')) {
      final solicitud = json['Solicitud'];
      return EstadoInscripcion(
        estado: solicitud['estado'],
        datos: solicitud['datos'],
        error: solicitud['error'],
      );
    }

    throw Exception('Formato de respuesta no reconocido');
  }

  bool get isProcesando => estado == 'procesando';
  bool get isProcesado => estado == 'procesado' && datos != null && datos['id'] != null;
  bool get isRechazado => estado == 'procesado' && datos != null && datos['message'] != null;
  bool get isError => estado == 'error';
}