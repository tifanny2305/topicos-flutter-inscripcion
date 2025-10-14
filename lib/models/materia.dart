class Materia {
  final int id;
  final String sigla;
  final String nombre;
  final int creditos;
  final int nivelId;
  final int tipoId;
  final Nivel nivel;
  final Tipo tipo;
  bool selected;

  Materia({
    required this.id,
    required this.sigla,
    required this.nombre,
    required this.creditos,
    required this.nivelId,
    required this.tipoId,
    required this.nivel,
    required this.tipo,
    this.selected = false,
  });

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      sigla: json['sigla'],
      nombre: json['nombre'],
      creditos: json['creditos'],
      nivelId: json['nivelId'],
      tipoId: json['tipoId'],
      nivel: Nivel.fromJson(json['nivel']),
      tipo: Tipo.fromJson(json['tipo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sigla': sigla,
      'nombre': nombre,
      'creditos': creditos,
      'nivelId': nivelId,
      'tipoId': tipoId,
    };
  }
}

class Nivel {
  final int id;
  final String nombre;

  Nivel({required this.id, required this.nombre});

  factory Nivel.fromJson(Map<String, dynamic> json) {
    return Nivel(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

class Tipo {
  final int id;
  final String nombre;

  Tipo({required this.id, required this.nombre});

  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}