class Grupo {
  final int id;
  final String codigo;
  final String turno;
  final int cupo;
  final int inscritos;

  Grupo({
    required this.id,
    required this.codigo,
    required this.turno,
    required this.cupo,
    required this.inscritos,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) => Grupo(
    id: json['id'] as int,
    codigo: json['codigo'] ?? '',
    turno: json['turno'] ?? '',
    cupo: json['cupo'] ?? 0,
    inscritos: json['inscritos'] ?? 0,
  );
}
