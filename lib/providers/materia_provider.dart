import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/services/materia_service.dart';
import '../models/materia.dart';

/// Provider responsable de manejar el estado y la lógica
/// relacionada con la selección y filtrado de materias.
class MateriaProvider with ChangeNotifier {
  final MateriaService _servicioMateria = MateriaService();

  // Estado interno
  List<Materia> _listaMaterias = [];
  List<Materia> _materiasSeleccionadas = [];
  bool _estaCargando = false;
  String? _error;

  // Filtros activos
  String _terminoBusqueda = '';
  String _nivelSeleccionado = 'all';
  String _tipoSeleccionado = 'all';

  // Getters públicos (lectura)
  List<Materia> get materias => _listaMaterias;
  List<Materia> get materiasSeleccionadas => _materiasSeleccionadas;
  bool get estaCargando => _estaCargando;
  String? get error => _error;
  String get terminoBusqueda => _terminoBusqueda;
  String get nivelSeleccionado => _nivelSeleccionado;
  String get tipoSeleccionado => _tipoSeleccionado;

  /// Retorna las materias filtradas por búsqueda, nivel y tipo.
  List<Materia> get materiasFiltradas {
    return _listaMaterias.where((materia) {
      final coincideNivel =
          _nivelSeleccionado == 'all' ||
          materia.nivel.nombre == _nivelSeleccionado;

      final coincideTipo =
          _tipoSeleccionado == 'all' ||
          materia.tipo.nombre == _tipoSeleccionado;

      final coincideBusqueda =
          _terminoBusqueda.isEmpty ||
          materia.nombre.toLowerCase().contains(
            _terminoBusqueda.toLowerCase(),
          ) ||
          materia.sigla.toLowerCase().contains(_terminoBusqueda.toLowerCase());

      return coincideNivel && coincideTipo && coincideBusqueda;
    }).toList();
  }

  /// Retorna la lista única de niveles disponibles.
  List<String> get nivelesDisponibles =>
      _listaMaterias.map((m) => m.nivel.nombre).toSet().toList()..sort();

  /// Retorna la lista única de tipos disponibles.
  List<String> get tiposDisponibles =>
      _listaMaterias.map((m) => m.tipo.nombre).toSet().toList();

  // Métodos públicos
  /// Carga las materias desde el servicio remoto.
  Future<void> cargarMaterias() async {
    _establecerCarga(true);

    try {
      _listaMaterias = await _servicioMateria.obtenerMaterias();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _establecerCarga(false);
  }

  /// Cambia el estado de selección de una materia.
  void alternarSeleccionMateria(Materia materia) {
    // Renombrado de 'toggleMateria'
    final index = _listaMaterias.indexWhere((m) => m.id == materia.id);
    if (index == -1) return;

    _listaMaterias[index].selected = !_listaMaterias[index].selected;

    if (_listaMaterias[index].selected) {
      _materiasSeleccionadas.add(_listaMaterias[index]);
    } else {
      _materiasSeleccionadas.removeWhere(
        (m) => m.id == _listaMaterias[index].id,
      );
    }

    notifyListeners();
  }

  /// Aplica búsqueda por nombre o sigla.
  void aplicarTerminoBusqueda(String termino) {
    _terminoBusqueda = termino.trim();
    notifyListeners();
  }

  /// Aplica filtro por nivel.
  void aplicarFiltroNivel(String nivel) {
    _nivelSeleccionado = nivel;
    notifyListeners();
  }

  /// Aplica filtro por tipo.
  void aplicarFiltroTipo(String tipo) {
    _tipoSeleccionado = tipo;
    notifyListeners();
  }

  /// Limpia todas las selecciones actuales.
  void limpiarSeleccion() {
    for (var materia in _listaMaterias) {
      materia.selected = false;
    }
    _materiasSeleccionadas.clear();
    notifyListeners();
  }

  // Métodos privados (internos)
  /// Cambia el estado de carga y notifica.
  void _establecerCarga(bool valor) {
    _estaCargando = valor;
    notifyListeners();
  }
}
