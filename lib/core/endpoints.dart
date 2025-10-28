
class Endpoints {
  static const String baseUrl = 'http://localhost:3005/api';
  //static const String baseUrl = 'https://f21c93dcf491.ngrok-free.app/api';

  // Endpoints
  static String materiasPorEstudiante(int estudianteId) => 
      '/usuarios/estudiantes/$estudianteId/materias-disponibles';
  static const String gruposPorMateria = '/grupos/grupo/materia'; // + /{id}
  static const String inscripciones = '/inscripciones/inscripciones';

  static const String iniciarSesion = '/usuarios/auth/login';
  
  static String estadoInscripcion(String uuid) => '/inscripciones/estado/$uuid';


  // Configuración
  static const int timeoutSeconds = 30;
  static const int pollingIntervalSeconds = 7;


}
