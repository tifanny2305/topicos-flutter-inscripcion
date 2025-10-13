import '../core/api_client.dart';
import '../core/endpoints.dart';

class InscripcionService {
  final client = ApiClient();

  /// Inicia la inscripción: devuelve transaction_id y status inicial.
  Future<Map<String, dynamic>> iniciarInscripcion(
    Map<String, dynamic> body,
  ) async {
    final res = await client.post(Endpoints.baseInscripciones, body);
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<Map<String, dynamic>> estadoInscripcion(String transactionId) async {
    final res = await client.get(
      '${Endpoints.baseInscripcionEstado}/$transactionId',
    );
    return Map<String, dynamic>.from(res.data as Map);
  }
}
