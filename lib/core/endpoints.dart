class Endpoints {
  //static const String baseUrl = 'http://192.168.1.12:80/api';
  static const String baseUrl = 'https://f21c93dcf491.ngrok-free.app/api';

  // Endpoints
  static const String materias = '/materias/materia';
  static const String gruposPorMateria = '/grupos/grupo/materia'; // + /{id}
  static const String inscripciones = '/inscripciones/inscripciones';
  static String estadoInscripcion(String uuid) => '/inscripciones/estado/$uuid';

  // Configuración
  static const int timeoutSeconds = 30;
  static const int pollingIntervalSeconds = 7;

  // Datos de prueba (mientras no hay auth)
  static const int estudianteId = 1;
  static const int gestionId = 2;
}
