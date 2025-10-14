import '../core/api_client.dart';
import '../core/endpoints.dart';
import '../models/materia.dart';

class MateriaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Materia>> obtenerMaterias() async {
    try {
      final response = await _apiClient.get(Endpoints.materias);
      return (response as List).map((json) => Materia.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener materias: $e');
    }
  }
}