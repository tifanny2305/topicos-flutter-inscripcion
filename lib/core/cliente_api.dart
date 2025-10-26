import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoints.dart';

class ClienteApi {
  final http.Client _client = http.Client();

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _client
          .get(
            Uri.parse('${Endpoints.baseUrl}$endpoint'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: Endpoints.timeoutSeconds));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en el servidor: Codigo ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fallo de conexión: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${Endpoints.baseUrl}$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(Duration(seconds: Endpoints.timeoutSeconds));

      if (response.statusCode == 200 || response.statusCode == 202) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en el servidor: Codigo ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fallo de conexión: $e');
    }
  }
}