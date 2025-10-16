// lib/app.dart
import 'package:flutter/material.dart';
import 'page/login_page.dart';
import 'page/materias/materias_page.dart';
import 'page/grupos/grupos_page.dart';
import 'page/inscripciones/inscripcion_page.dart';
import 'page/estado_page.dart';
import 'models/materia.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscripciones - Tópicos',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // Cambio aquí
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/materias':
            return MaterialPageRoute(
              builder: (_) => const MateriasPage(),
            );
            
          case '/grupos':
            final materias = settings.arguments as List<Materia>;
            return MaterialPageRoute(
              builder: (_) => GruposPage(materias: materias),
            );

          case '/inscripcion':
            final grupos = settings.arguments as List<Map<String, dynamic>>;
            return MaterialPageRoute(
              builder: (_) => InscripcionPage(gruposSeleccionados: grupos),
            );

          case '/estado':
            final transactionId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => EstadoPage(transactionId: transactionId),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(
                  child: Text('Página no encontrada'),
                ),
              ),
            );
        }
      },
    );
  }
}