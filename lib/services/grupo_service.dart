import '../core/api_client.dart';
import '../core/endpoints.dart';
import '../models/grupo.dart';

class GrupoService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Grupo>> obtenerGruposPorMateria(int materiaId) async {
    try {
      final response = await _apiClient.get('${Endpoints.gruposPorMateria}/$materiaId');
      return (response as List).map((json) => Grupo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener grupos: $e');
    }
  }
}