import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../services/materia_service.dart';

class MateriaProvider with ChangeNotifier {
  final MateriaService _service = MateriaService();

  List<Materia> _materias = [];
  List<Materia> _materiasSeleccionadas = [];
  bool _isLoading = false;
  String? _error;

  // Filtros
  String _searchTerm = '';
  String _nivelSeleccionado = 'all';
  String _tipoSeleccionado = 'all';

  // Getters
  List<Materia> get materias => _materias;
  List<Materia> get materiasSeleccionadas => _materiasSeleccionadas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchTerm => _searchTerm;
  String get nivelSeleccionado => _nivelSeleccionado;
  String get tipoSeleccionado => _tipoSeleccionado;

  List<Materia> get materiasFiltradas {
    return _materias.where((materia) {
      final matchesNivel = _nivelSeleccionado == 'all' || 
          materia.nivel.nombre == _nivelSeleccionado;
      final matchesTipo = _tipoSeleccionado == 'all' || 
          materia.tipo.nombre == _tipoSeleccionado;
      final matchesSearch = _searchTerm.isEmpty ||
          materia.nombre.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          materia.sigla.toLowerCase().contains(_searchTerm.toLowerCase());
      
      return matchesNivel && matchesTipo && matchesSearch;
    }).toList();
  }

  List<String> get niveles {
    final nivelesSet = _materias.map((m) => m.nivel.nombre).toSet();
    return nivelesSet.toList()..sort();
  }

  List<String> get tipos {
    final tiposSet = _materias.map((m) => m.tipo.nombre).toSet();
    return tiposSet.toList();
  }

  // Métodos
  Future<void> cargarMaterias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _materias = await _service.obtenerMaterias();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleMateria(Materia materia) {
    final index = _materias.indexWhere((m) => m.id == materia.id);
    if (index != -1) {
      _materias[index].selected = !_materias[index].selected;
      
      if (_materias[index].selected) {
        _materiasSeleccionadas.add(_materias[index]);
      } else {
        _materiasSeleccionadas.removeWhere((m) => m.id == materia.id);
      }
      notifyListeners();
    }
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void setNivelFilter(String nivel) {
    _nivelSeleccionado = nivel;
    notifyListeners();
  }

  void setTipoFilter(String tipo) {
    _tipoSeleccionado = tipo;
    notifyListeners();
  }

  void clearSelection() {
    for (var materia in _materias) {
      materia.selected = false;
    }
    _materiasSeleccionadas.clear();
    notifyListeners();
  }
}