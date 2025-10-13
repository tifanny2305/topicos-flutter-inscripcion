class Materia {
  final int id;
  final String codigo;
  final String nombre;
  final int creditos;

  Materia({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.creditos,
  });

  factory Materia.fromJson(Map<String, dynamic> json) => Materia(
    id: json['id'] as int,
    codigo: json['codigo'] ?? '',
    nombre: json['nombre'] ?? '',
    creditos: json['creditos'] ?? 0,
  );
}
