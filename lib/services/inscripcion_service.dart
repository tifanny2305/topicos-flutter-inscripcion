import '../core/api_client.dart';
import '../core/endpoints.dart';
import '../models/inscripcion_request.dart';
import '../models/inscripcion_response.dart';
import '../models/estado_inscripcion.dart';

class InscripcionService {
  final ApiClient _apiClient = ApiClient();

  Future<InscripcionResponse> crearInscripcion(InscripcionRequest request) async {
    try {
      final response = await _apiClient.post(Endpoints.inscripciones, request.toJson());
      return InscripcionResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear inscripción: $e');
    }
  }

  Future<EstadoInscripcion> consultarEstado(String transactionId) async {
    try {
      final response = await _apiClient.get(Endpoints.estadoInscripcion(transactionId));
      return EstadoInscripcion.fromJson(response);
    } catch (e) {
      throw Exception('Error al consultar estado: $e');
    }
  }
}