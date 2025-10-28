import 'package:jwt_decoder/jwt_decoder.dart';
import '../core/cliente_api.dart';
import '../core/endpoints.dart';

/// Define la estructura que el Service retorna.
/// Usamos un simple Map para el login.
class LoginService {
  final ClienteApi _clienteApi;

  // Inyección del Cliente API
  LoginService(this._clienteApi);

  Future<Map<String, dynamic>> login(String registro, String codigo) async {
    final response = await _clienteApi.post(
      Endpoints.iniciarSesion,
      {
        'registro': registro,
        'codigo': codigo,
      },
    );

    // Deserializa el token y extrae el ID
    final token = response['token'];
    final estudianteRegistro = response['registro'];
    
    // Decodifica el JWT para extraer el ID del payload
    final Map<String, dynamic> payload = JwtDecoder.decode(token);
    final int estudianteId = payload['id'];

    return {
      'token': token,
      'registro': estudianteRegistro,
      'estudianteId': estudianteId,
    };
  }
}