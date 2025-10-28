class Estudiante {
  final int id;
  final String registro;
  final String codigo;
  final String nombre;
  final String email;
  final int telefono;
  final int plan_estudio_id;
  
  Estudiante({
    required this.id,
    required this.registro,
    required this.codigo,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.plan_estudio_id,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'] as int,
      registro: json['registro'] ?? '',
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? 0,
      plan_estudio_id: json['plan_estudio_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registro': registro,
      'codigo': codigo,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'plan_estudio_id': plan_estudio_id,
    };
  }
}
