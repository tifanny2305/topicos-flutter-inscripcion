import '../core/cliente_api.dart';
import '../core/endpoints.dart';
import '../models/materia.dart';

class MateriaService {
  final ClienteApi _ClienteApi = ClienteApi();

  Future<List<Materia>> obtenerMaterias() async {
    try {
      final response = await _ClienteApi.get(Endpoints.materias);
      return (response as List).map((json) => Materia.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener materias: $e');
    }
  }
}