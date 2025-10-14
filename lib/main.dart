import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/materia_provider.dart';
import 'providers/grupo_provider.dart';
import 'providers/inscripcion_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MateriaProvider()),
        ChangeNotifierProvider(create: (_) => GrupoProvider()),
        ChangeNotifierProvider(create: (_) => InscripcionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}