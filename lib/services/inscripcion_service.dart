import '../core/cliente_api.dart';
import '../core/endpoints.dart';
import '../models/inscripcion_request.dart';
import '../models/inscripcion_response.dart';
import '../models/estado_inscripcion.dart';

class InscripcionService {
  final ClienteApi _ClienteApi = ClienteApi();

  Future<InscripcionResponse> crearInscripcion(
    InscripcionRequest request,
  ) async {
    try {
      final response = await _ClienteApi.post(
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
      final response = await _ClienteApi.get(
        Endpoints.estadoInscripcion(transactionId),
      );

      if (response is Map<String, dynamic>) {
        final solicitud = response['Solicitud'];
        final datos = solicitud['datos'] as Map<String, dynamic>?;

        if (datos != null) {
          // Manejar choque de horarios (409)
          if (datos['code'] == 409) {
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

          // Manejar cupo agotado (422)
          if (datos['code'] == 422) {
            return EstadoInscripcion.fromJson({
              'Solicitud': {
                'estado': 'error',
                'datos': datos,
                'message':
                    datos['message'] ??
                    'Uno o más grupos no tienen cupos disponibles',
              },
            });
          }
        }
      }

      return EstadoInscripcion.fromJson(response);
    } catch (e) {
      final mensaje = e.toString();

      // Capturar errores 409
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

      // Capturar errores 422
      if (mensaje.contains('422')) {
        return EstadoInscripcion.fromJson({
          'Solicitud': {
            'estado': 'error',
            'datos': {
              'code': 422,
              'message': 'Uno o más grupos no tienen cupos disponibles',
            },
            'message': 'Uno o más grupos no tienen cupos disponibles',
          },
        });
      }

      throw Exception('Error al consultar estado: $e');
    }
  }
}
