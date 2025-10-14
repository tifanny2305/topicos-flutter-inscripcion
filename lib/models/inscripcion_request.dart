class InscripcionRequest {
  final int estudianteId;
  final int gestionId;
  final String fecha;
  final List<int> grupos;

  InscripcionRequest({
    required this.estudianteId,
    required this.gestionId,
    required this.fecha,
    required this.grupos,
  });

  Map<String, dynamic> toJson() {
    return {
      'estudiante_id': estudianteId,
      'gestion_id': gestionId,
      'fecha': fecha,
      'grupos': grupos,
    };
  }
}