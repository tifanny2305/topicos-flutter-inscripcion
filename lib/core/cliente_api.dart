import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoints.dart';

class ClienteApi {
  final http.Client _client = http.Client();
  
  // ⭐ NUEVO: Función que provee el token dinámicamente
  String? Function()? _tokenProvider;

  ClienteApi();

  // ⭐ NUEVO: Método para configurar el proveedor de token
  void configurarTokenProvider(String? Function() provider) {
    _tokenProvider = provider;
  }

  Map<String, String> _getHeaders({String? tokenOverride}) {
    final headers = {'Content-Type': 'application/json'};
    
    // ⭐ CLAVE: Obtener token dinámicamente
    final token = tokenOverride ?? _tokenProvider?.call();
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print('🔐 Token añadido: ${token.substring(0, 20)}...');
    } else {
      print('No hay token disponible');
    }
    
    return headers;
  }

  Future<dynamic> get(String endpoint, {String? token}) async {
    print('📤 GET: ${Endpoints.baseUrl}$endpoint');
    
    try {
      final response = await _client
          .get(
            Uri.parse('${Endpoints.baseUrl}$endpoint'),
            headers: _getHeaders(tokenOverride: token),
          )
          .timeout(Duration(seconds: Endpoints.timeoutSeconds));

      print('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('No autorizado. Token inválido o expirado.');
      } else {
        throw Exception('Error en el servidor: Código ${response.statusCode}');
      }
    } catch (e) {
      print('Error en GET: $e');
      throw Exception('Fallo de conexión: $e');
    }
  }

  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    print('📤 POST: ${Endpoints.baseUrl}$endpoint');
    
    try {
      final response = await _client
          .post(
            Uri.parse('${Endpoints.baseUrl}$endpoint'),
            headers: _getHeaders(tokenOverride: token),
            body: json.encode(data),
          )
          .timeout(Duration(seconds: Endpoints.timeoutSeconds));

      print('📥 Status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Credenciales incorrectas o token expirado.');
      } else {
        print('Error body: ${response.body}');
        throw Exception('Error en el servidor: Código ${response.statusCode}');
      }
    } catch (e) {
      print('Error en POST: $e');
      throw Exception('Fallo de conexión: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}