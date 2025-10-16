import '../core/api_client.dart';
import '../core/endpoints.dart';
import '../models/inscripcion_request.dart';
import '../models/inscripcion_response.dart';
import '../models/estado_inscripcion.dart';

class InscripcionService {
  final ApiClient _apiClient = ApiClient();

  Future<InscripcionResponse> crearInscripcion(
    InscripcionRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        Endpoints.inscripciones,
        request.toJson(),
      );
      return InscripcionResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear inscripción: $e');
    }
  }

  Future<EstadoInscripcion> consultarEstado(String transactionId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.estadoInscripcion(transactionId),
      );

      if (response is Map<String, dynamic>) {
        final solicitud = response['Solicitud'];
        final datos = solicitud['datos'] as Map<String, dynamic>?;

        if (datos != null && datos['code'] == 409) {
          return EstadoInscripcion.fromJson({
            'Solicitud': {
              'estado': 'error',
              'datos': datos,
              'message':
                  datos['message'] ??
                  'Conflicto o choque de horarios detectado',
            },
          });
        }
      }

      return EstadoInscripcion.fromJson(response);
    } catch (e) {
      // Capturar excepción de conexión o errores HTTP 409
      final mensaje = e.toString();
      if (mensaje.contains('409')) {
        return EstadoInscripcion.fromJson({
          'Solicitud': {
            'estado': 'error',
            'datos': {
              'code': 409,
              'message': 'Conflicto o choque de horarios detectado',
            },
            'message': 'Conflicto o choque de horarios detectado',
          },
        });
      }

      throw Exception('Error al consultar estado: $e');
    }
  }
}
