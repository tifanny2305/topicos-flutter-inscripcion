import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../services/materia_service.dart';

/// Provider responsable de manejar el estado y la lógica
/// relacionada con la selección y filtrado de materias.
class MateriaProvider with ChangeNotifier {
  final MateriaService _service = MateriaService();

  // ===============================
  // Estado interno
  // ===============================
  List<Materia> _materias = [];
  List<Materia> _materiasSeleccionadas = [];
  bool _isLoading = false;
  String? _error;

  // ===============================
  // Filtros activos
  // ===============================
  String _searchTerm = '';
  String _nivelSeleccionado = 'all';
  String _tipoSeleccionado = 'all';

  // ===============================
  // Getters públicos (lectura)
  // ===============================
  List<Materia> get materias => _materias;
  List<Materia> get materiasSeleccionadas => _materiasSeleccionadas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchTerm => _searchTerm;
  String get nivelSeleccionado => _nivelSeleccionado;
  String get tipoSeleccionado => _tipoSeleccionado;

  /// Retorna las materias filtradas por búsqueda, nivel y tipo.
  List<Materia> get materiasFiltradas {
    return _materias.where((materia) {
      final coincideNivel = _nivelSeleccionado == 'all' ||
          materia.nivel.nombre == _nivelSeleccionado;

      final coincideTipo = _tipoSeleccionado == 'all' ||
          materia.tipo.nombre == _tipoSeleccionado;

      final coincideBusqueda = _searchTerm.isEmpty ||
          materia.nombre.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          materia.sigla.toLowerCase().contains(_searchTerm.toLowerCase());

      return coincideNivel && coincideTipo && coincideBusqueda;
    }).toList();
  }

  /// Retorna la lista única de niveles disponibles.
  List<String> get niveles =>
      _materias.map((m) => m.nivel.nombre).toSet().toList()..sort();

  /// Retorna la lista única de tipos disponibles.
  List<String> get tipos =>
      _materias.map((m) => m.tipo.nombre).toSet().toList();

  // ===============================
  // Métodos públicos
  // ===============================

  /// Carga las materias desde el servicio remoto.
  Future<void> cargarMaterias() async {
    _setLoading(true);

    try {
      _materias = await _service.obtenerMaterias();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Cambia el estado de selección de una materia.
  void toggleMateria(Materia materia) {
    final index = _materias.indexWhere((m) => m.id == materia.id);
    if (index == -1) return;

    _materias[index].selected = !_materias[index].selected;

    if (_materias[index].selected) {
      _materiasSeleccionadas.add(_materias[index]);
    } else {
      _materiasSeleccionadas
          .removeWhere((m) => m.id == _materias[index].id);
    }

    notifyListeners();
  }

  /// Aplica búsqueda por nombre o sigla.
  void setSearchTerm(String term) {
    _searchTerm = term.trim();
    notifyListeners();
  }

  /// Aplica filtro por nivel.
  void setNivelFilter(String nivel) {
    _nivelSeleccionado = nivel;
    notifyListeners();
  }

  /// Aplica filtro por tipo.
  void setTipoFilter(String tipo) {
    _tipoSeleccionado = tipo;
    notifyListeners();
  }

  /// Limpia todas las selecciones actuales.
  void clearSelection() {
    for (var materia in _materias) {
      materia.selected = false;
    }
    _materiasSeleccionadas.clear();
    notifyListeners();
  }

  // ===============================
  // Métodos privados (internos)
  // ===============================

  /// Cambia el estado de carga y notifica.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
