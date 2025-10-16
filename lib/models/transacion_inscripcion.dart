class TransaccionInscripcion {
  final String transactionId;
  final String estado; // 'procesando', 'procesado', 'rechazado'
  final DateTime fechaCreacion;
  final List<int> gruposIds;
  final Map<String, dynamic>? datos; // Cuando está procesado
  final String? mensaje; // Para rechazos
  final String? tipoError; // 'choque' | 'cupo' | null

  TransaccionInscripcion({
    required this.transactionId,
    required this.estado,
    required this.fechaCreacion,
    required this.gruposIds,
    this.datos,
    this.mensaje,
    this.tipoError,
  });

  // Getters de estado
  bool get esPendiente => estado == 'procesando';
  bool get estaProcesado => estado == 'procesado';
  bool get estaRechazado => estado == 'rechazado';
  bool get tieneError => estado == 'error' || tipoError != null;

  // Crear desde la respuesta inicial del POST
  factory TransaccionInscripcion.desdeRespuestaInicial({
    required String transactionId,
    required List<int> gruposIds,
  }) {
    return TransaccionInscripcion(
      transactionId: transactionId,
      estado: 'procesando',
      fechaCreacion: DateTime.now(),
      gruposIds: gruposIds,
    );
  }

  // Crear desde la respuesta del GET (consulta de estado)
  factory TransaccionInscripcion.desdeConsulta(
    String transactionId,
    Map<String, dynamic> json,
    List<int> gruposIds,
    DateTime fechaCreacion,
  ) {
    final solicitud = json['Solicitud'];
    final estado = solicitud['estado'] as String;
    final datos = solicitud['datos'] as Map<String, dynamic>?;
    final message = solicitud['message'] as String?;

    // Detectar tipo de error según el código
    String? tipoError;
    final code = datos?['code'] as int?;
    if (code == 409) tipoError = 'choque';
    if (code == 422) tipoError = 'cupo';

    return TransaccionInscripcion(
      transactionId: transactionId,
      estado: estado,
      fechaCreacion: fechaCreacion,
      gruposIds: gruposIds,
      datos: datos,
      mensaje: message,
      tipoError: tipoError,
    );
  }

  // Para guardar en SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'estado': estado,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'grupos_ids': gruposIds,
      'datos': datos,
      'mensaje': mensaje,
      'tipo_error': tipoError,
    };
  }

  // Para cargar desde SharedPreferences
  factory TransaccionInscripcion.fromJson(Map<String, dynamic> json) {
    return TransaccionInscripcion(
      transactionId: json['transaction_id'],
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      gruposIds: List<int>.from(json['grupos_ids']),
      datos: json['datos'],
      mensaje: json['mensaje'],
      tipoError: json['tipo_error'],
    );
  }

  // Crear copia con nuevos valores
  TransaccionInscripcion copiarCon({
    String? estado,
    Map<String, dynamic>? datos,
    String? mensaje,
    String? tipoError,
  }) {
    return TransaccionInscripcion(
      transactionId: transactionId,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion,
      gruposIds: gruposIds,
      datos: datos ?? this.datos,
      mensaje: mensaje ?? this.mensaje,
      tipoError: tipoError ?? this.tipoError,
    );
  }
}
