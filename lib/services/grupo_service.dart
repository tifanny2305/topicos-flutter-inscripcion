import '../core/cliente_api.dart';
import '../core/endpoints.dart';
import '../models/grupo.dart';

class GrupoService {
  final ClienteApi _ClienteApi = ClienteApi();

  Future<List<Grupo>> obtenerGruposPorMateria(int materiaId) async {
    try {
      final response = await _ClienteApi.get('${Endpoints.gruposPorMateria}/$materiaId');
      return (response as List).map((json) => Grupo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener grupos: $e');
    }
  }
}