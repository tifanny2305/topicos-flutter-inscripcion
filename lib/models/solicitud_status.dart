class SolicitudDatos {
  final int id;
  final DateTime fecha;
  final int estudianteId;
  final int gestionId;

  SolicitudDatos({
    required this.id,
    required this.fecha,
    required this.estudianteId,
    required this.gestionId,
  });

  factory SolicitudDatos.fromJson(Map<String, dynamic> json) => SolicitudDatos(
    id: json['id'] as int,
    fecha: DateTime.parse(json['fecha'] as String),
    estudianteId: json['estudiante_id'] as int,
    gestionId: json['gestion_id'] as int,
  );
}

class SolicitudStatus {
  final String estado;
  final List<SolicitudDatos> datos;

  SolicitudStatus({required this.estado, required this.datos});

  factory SolicitudStatus.fromJson(Map<String, dynamic> json) {
    final s = json['Solicitud'] ?? {};
    final datosJson = s['datos'] as List<dynamic>?;
    return SolicitudStatus(
      estado: s['estado'] as String? ?? 'procesando',
      datos: datosJson != null
          ? datosJson
                .map((d) => SolicitudDatos.fromJson(d as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}
