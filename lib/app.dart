// lib/app.dart
import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/page/estados/list_estado_page.dart';
import 'package:topicos_inscripciones/widgets/notificacion.dart';
import 'page/login/login_page.dart';
import 'page/materias/materias_page.dart';
import 'page/grupos/grupos_page.dart';
import 'page/inscripciones/inscripcion_page.dart';
import 'models/materia.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificacionListener(
      child: MaterialApp(
        title: 'Inscripciones - Tópicos',
        scaffoldMessengerKey: scaffoldMessengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
        onGenerateRoute: (settings) {
          Widget page;
          
          switch (settings.name) {
            case '/materias':
              page = const MateriasPage();
              break;
              
            case '/grupos':
              final materias = settings.arguments as List<Materia>;
              page = GruposPage(materias: materias);
              break;

            case '/inscripcion':
              final grupos = settings.arguments as List<Map<String, dynamic>>;
              page = InscripcionPage(gruposSeleccionados: grupos);
              break;

            case '/estados':
              page = const ListaEstadosPage();
              break;

            default:
              page = Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(
                  child: Text('Página no encontrada'),
                ),
              );
          }
          
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
    );
  }
}