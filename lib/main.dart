import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/cliente_api.dart';
import 'services/inscripcion_service.dart';
import 'services/login_service.dart';
import 'services/materia_service.dart';
import 'services/grupo_service.dart';
import 'app.dart';
import 'providers/login_provider.dart';
import 'providers/materia_provider.dart';
import 'providers/grupo_provider.dart';
import 'providers/inscripcion_provider.dart';
import 'providers/estado_inscripcion_provider.dart';

void main() {
  print('🚀 Iniciando aplicación...');
  
  runApp(
    MultiProvider(
      providers: [
        // CAPA 1: Cliente Base
        Provider<ClienteApi>(
          create: (_) {
            print('Creando ClienteApi...');
            return ClienteApi();
          },
          dispose: (_, api) => api.dispose(),
        ),

        // CAPA 2: Servicios
        Provider<LoginService>(
          create: (context) {
            print('Creando LoginService...');
            return LoginService(context.read<ClienteApi>());
          },
        ),

        Provider<InscripcionService>(
          create: (context) => InscripcionService(context.read<ClienteApi>()),
        ),

        Provider<MateriaService>(
          create: (context) {
            print('Creando MateriaService...');
            return MateriaService(context.read<ClienteApi>());
          },
        ),

        Provider<GrupoService>(
          create: (context) => GrupoService(context.read<ClienteApi>()),
        ),

        // CAPA 3: LoginProvider (CLAVE)
        ChangeNotifierProxyProvider<LoginService, LoginProvider>(
          create: (context) {
            print('Creando LoginProvider...');
            final loginService = context.read<LoginService>();
            final provider = LoginProvider(loginService);
            
            // ⭐ CRÍTICO: Cargar sesión y configurar token provider
            provider.cargarTokenDesdePrefs().then((_) {
              print('Configurando token provider en ClienteApi...');
              context.read<ClienteApi>().configurarTokenProvider(
                () => provider.token,
              );
              print('Token provider configurado');
            });
            
            return provider;
          },
          update: (context, loginService, previousProvider) {
            return previousProvider ?? LoginProvider(loginService);
          },
          lazy: false, // ⭐ IMPORTANTE: No lazy
        ),

        // CAPA 4: Providers de Dominio
        ChangeNotifierProxyProvider2<InscripcionService, LoginProvider, InscripcionProvider>(
          create: (context) {
            final service = context.read<InscripcionService>();
            final authProvider = context.read<LoginProvider>();
            return InscripcionProvider(service, authProvider);
          },
          update: (context, service, authProvider, previousProvider) {
            return previousProvider ?? InscripcionProvider(service, authProvider);
          },
        ),

        ChangeNotifierProxyProvider<MateriaService, MateriaProvider>(
          create: (context) => MateriaProvider(context.read<MateriaService>()),
          update: (context, servicioMateria, previousProvider) {
            return previousProvider ?? MateriaProvider(servicioMateria);
          },
        ),

        ChangeNotifierProxyProvider<GrupoService, GrupoProvider>(
          create: (context) => GrupoProvider(context.read<GrupoService>()),
          update: (context, servicioGrupo, previousProvider) {
            return previousProvider ?? GrupoProvider(servicioGrupo);
          },
        ),

        ChangeNotifierProvider(
          create: (_) => EstadoInscripcionProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}