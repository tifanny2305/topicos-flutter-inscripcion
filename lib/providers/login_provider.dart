import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topicos_inscripciones/services/login_service.dart';

class LoginProvider with ChangeNotifier {
  // Estado
  String? _registro;
  String? _token;
  int? _estudianteId;
  bool _isAuthenticated = false;
  
  // Dependencia del Servicio
  final LoginService _loginService; 

  // Constructor que recibe el servicio
  LoginProvider(this._loginService);

  // Getters
  String? get registro => _registro;
  String? get token => _token;
  int? get estudianteId => _estudianteId;
  bool get isAuthenticated => _isAuthenticated;

  // Lógica de Login: Delega la llamada HTTP al Service
  Future<bool> login(String registro, String codigo) async {
    try {
      // 1. Llamada al Service de Lógica de Negocio
      final result = await _loginService.login(registro, codigo);

      // 2. Actualiza el estado con los datos obtenidos
      _registro = result['registro'];
      _token = result['token'];
      _estudianteId = result['estudianteId'];
      _isAuthenticated = true;

      // 3. Persistencia
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', _token!);
      await prefs.setString('userRegistro', _registro!);
      await prefs.setInt('estudianteId', _estudianteId!);

      notifyListeners();
      return true;
    } catch (e) {
      print('Error en login (Provider): ${e.toString()}');
      _isAuthenticated = false;
      return false;
    }
  }

  // Lógica para cargar el token al inicio de la app
  Future<void> cargarTokenDesdePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getString('authToken');
    
    if (guardado != null && guardado.isNotEmpty) {
      _token = guardado;
      _registro = prefs.getString('userRegistro');
      _estudianteId = prefs.getInt('estudianteId');
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userRegistro');
    await prefs.remove('estudianteId');

    _registro = null;
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
