import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../models/grupo.dart';
import '../services/grupo_service.dart';

class MateriaConGrupos {
  final Materia materia;
  final List<Grupo> grupos;
  int? grupoSeleccionadoId;

  MateriaConGrupos({
    required this.materia,
    required this.grupos,
    this.grupoSeleccionadoId,
  });
}

class GrupoProvider with ChangeNotifier {
  final GrupoService _service = GrupoService();

  List<MateriaConGrupos> _materiasConGrupos = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MateriaConGrupos> get materiasConGrupos => _materiasConGrupos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get materiasSeleccionadas {
    return _materiasConGrupos
        .where((m) => m.grupoSeleccionadoId != null)
        .length;
  }

  bool get tieneAlMenosUnaSeleccionada {
    return materiasSeleccionadas > 0;
  }

  int get progresoSeleccion {
    if (_materiasConGrupos.isEmpty) return 0;
    return ((materiasSeleccionadas / _materiasConGrupos.length) * 100).round();
  }

  List<Grupo> gruposConCupo(List<Grupo> grupos) {
    return grupos.where((g) => g.cupo > 0).toList();
  }

  // Métodos
  Future<void> cargarGruposPorMaterias(List<Materia> materias) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Peticiones en paralelo
      final gruposPorMateria = await Future.wait(
        materias.map((materia) => _service.obtenerGruposPorMateria(materia.id)),
      );

      _materiasConGrupos = List.generate(
        materias.length,
        (i) =>
            MateriaConGrupos(materia: materias[i], grupos: gruposPorMateria[i]),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void seleccionarGrupo(int materiaId, int grupoId) {
    final index = _materiasConGrupos.indexWhere(
      (m) => m.materia.id == materiaId,
    );
    if (index != -1) {
      if (_materiasConGrupos[index].grupoSeleccionadoId == grupoId) {
        _materiasConGrupos[index].grupoSeleccionadoId = null;
      } else {
        _materiasConGrupos[index].grupoSeleccionadoId = grupoId;
      }
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> obtenerGruposSeleccionados() {
    return _materiasConGrupos.where((mc) => mc.grupoSeleccionadoId != null).map(
      (mc) {
        final grupo = mc.grupos.firstWhere(
          (g) => g.id == mc.grupoSeleccionadoId,
        );
        return {
          'materiaId': mc.materia.id,
          'materiaNombre': mc.materia.nombre,
          'materiaSigla': mc.materia.sigla,
          'grupoId': grupo.id,
          'grupoSigla': grupo.sigla,
          'docenteId': grupo.docenteId,
          // Agregar el objeto docente completo
          'docente': grupo.docente != null ? {
            'id': grupo.docente!.id,
            'nombre': grupo.docente!.nombre,
          } : null,
          // Agregar los horarios
          'horarios': grupo.horarios.map((h) => {
            'dia': h.dia,
            'horaInicio': h.horaInicio,
            'horaFin': h.horaFin,
          }).toList(),
        };
      },
    ).toList();
  }
}