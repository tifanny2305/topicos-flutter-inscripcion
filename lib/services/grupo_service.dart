import '../core/cliente_api.dart';
import '../core/endpoints.dart';
import '../models/grupo.dart';

class GrupoService {
  final ClienteApi _clienteApi;

  // Constructor que recibe la inyección
  GrupoService(this._clienteApi);

  Future<List<Grupo>> obtenerGruposPorMateria(int materiaId) async {
    try {
      // 1. Construir la URL completa (ClienteApi lo prefija con baseUrl)
      final endpoint = '${Endpoints.gruposPorMateria}/$materiaId';
      
      // 2. Llamar a la API
      final response = await _clienteApi.get(endpoint);
      
      // 3. Deserialización
      return (response as List).map((json) => Grupo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener grupos: ${e.toString()}');
    }
  }
}
