import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/page/materias_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscripciones - Topicos',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const MateriasPage(),
    );
  }
}
