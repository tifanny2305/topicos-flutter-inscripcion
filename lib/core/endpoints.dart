class Endpoints {
  static const String baseUrl = 'http://192.168.1.12:80/api';

  // Endpoints
  static const String materias = '/materias/materia';
  static const String gruposPorMateria = '/grupos/grupo/materia'; // + /{id}
  static const String inscripciones = '/inscripciones/inscripciones';
  static String estadoInscripcion(String uuid) => '/inscripciones/estado/$uuid';

  // Configuración
  static const int timeoutSeconds = 30;
  static const int pollingIntervalSeconds = 3;

  // Datos de prueba (mientras no hay auth)
  static const int estudianteId = 1;
  static const int gestionId = 2;
}
