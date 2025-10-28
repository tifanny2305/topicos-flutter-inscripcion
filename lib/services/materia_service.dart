import '../core/cliente_api.dart';
import '../core/endpoints.dart';
import '../models/materia.dart';

class MateriaService {
  final ClienteApi _clienteApi;

  MateriaService(this._clienteApi);

  // ⭐ CAMBIO: Ahora recibe estudianteId como parámetro
  Future<List<Materia>> obtenerMaterias(int estudianteId) async {
    try {
      print('Obteniendo materias para estudiante: $estudianteId');
      
      final endpoint = Endpoints.materiasPorEstudiante(estudianteId);
      
      // ClienteApi añadirá el token automáticamente
      final response = await _clienteApi.get(endpoint);
      
      final materias = (response as List)
          .map((json) => Materia.fromJson(json))
          .toList();
      
      print('${materias.length} materias obtenidas');
      return materias;
          
    } catch (e) {
      print('Error al obtener materias: $e');
      throw Exception('Error al obtener materias: ${e.toString()}');
    }
  }
}