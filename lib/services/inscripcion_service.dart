import '../core/cliente_api.dart';
import '../core/endpoints.dart';
import '../models/inscripcion_request.dart';
import '../models/inscripcion_response.dart';
import '../models/estado_inscripcion.dart';

class InscripcionService {
  final ClienteApi _clienteApi;

  // Constructor que recibe la inyección
  InscripcionService(this._clienteApi); 

  Future<InscripcionResponse> crearInscripcion(
    InscripcionRequest request,
  ) async {
    try {
      final response = await _clienteApi.post(
        Endpoints.inscripciones,
        request.toJson(),
      );
      return InscripcionResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear inscripción: ${e.toString()}');
    }
  }

  Future<EstadoInscripcion> consultarEstado(String transactionId) async {
    try {
      final response = await _clienteApi.get(
        Endpoints.estadoInscripcion(transactionId),
      );

      // Si el response es un Map, aplicamos la lógica de verificación de códigos de error
      if (response is Map<String, dynamic>) {
        final solicitud = response['Solicitud'];
        final datos = solicitud['datos'] as Map<String, dynamic>?;

        if (datos != null) {
          // Si el servidor devuelve los códigos 409 o 422 dentro del JSON de datos:
          if (datos['code'] == 409) {
            return EstadoInscripcion.fromJson({
              'Solicitud': {
                'estado': 'error',
                'datos': datos,
                'message': datos['message'] ?? 'Conflicto o choque de horarios detectado',
              },
            });
          }

          if (datos['code'] == 422) {
            return EstadoInscripcion.fromJson({
              'Solicitud': {
                'estado': 'error',
                'datos': datos,
                'message': datos['message'] ?? 'Uno o más grupos no tienen cupos disponibles',
              },
            });
          }
        }
      }

      return EstadoInscripcion.fromJson(response);
    } catch (e) {
      // Si el error es una excepción de red o del cliente, relanzamos
      // NOTA: El ClienteApi ya debería lanzar excepciones de 4xx
      throw Exception('Error al consultar estado: ${e.toString()}');
    }
  }
}
