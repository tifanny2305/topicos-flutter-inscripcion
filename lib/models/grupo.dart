class Grupo {
  final int id;
  final String sigla;
  final int cupo;
  final int materiaId;
  final int docenteId;
  final int gestionId;
  final Docente? docente;
  final List<Horario> horarios;

  Grupo({
    required this.id,
    required this.sigla,
    required this.cupo,
    required this.materiaId,
    required this.docenteId,
    required this.gestionId,
    this.docente,
    this.horarios = const [],
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      sigla: json['sigla'],
      cupo: json['cupo'],
      materiaId: json['materiaId'],
      docenteId: json['docenteId'],
      gestionId: json['gestionId'],
      docente: json['docente'] != null ? Docente.fromJson(json['docente']) : null,
      horarios: json['horarios'] != null
          ? (json['horarios'] as List).map((h) => Horario.fromJson(h)).toList()
          : [],
    );
  }
}

class Docente {
  final int id;
  final String nombre;
  final String registro;

  Docente({required this.id, required this.nombre, required this.registro});

  factory Docente.fromJson(Map<String, dynamic> json) {
    return Docente(
      id: json['id'],
      nombre: json['nombre'],
      registro: json['registro'],
    );
  }
}

class Horario {
  final int id;
  final String dia;
  final String horaInicio;
  final String horaFin;

  Horario({
    required this.id,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      id: json['id'],
      dia: json['dia'],
      horaInicio: json['horaInicio'],
      horaFin: json['horaFin'],
    );
  }
}