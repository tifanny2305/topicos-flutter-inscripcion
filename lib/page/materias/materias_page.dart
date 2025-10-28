import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/page/materias/widgets/btn_continuar.dart';
import 'package:topicos_inscripciones/page/materias/widgets/tarjeta_materia.dart';
import 'package:topicos_inscripciones/page/materias/widgets/filtros_materia.dart';
import 'package:topicos_inscripciones/page/materias/widgets/seleccion_resumen.dart';
import 'package:topicos_inscripciones/providers/login_provider.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';
import 'package:topicos_inscripciones/widgets/barra_inferior.dart';
import 'package:topicos_inscripciones/widgets/barra_superior.dart';

class MateriasPage extends StatefulWidget {
  const MateriasPage({Key? key}) : super(key: key);

  @override
  State<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  @override
  void initState() {
    super.initState();
    _cargarInicialmente();
  }

  void _cargarInicialmente() {
  // Es buena práctica usar addPostFrameCallback para llamadas asíncronas
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // ✅ CORRECCIÓN: Obtener el LoginProvider y pasar el estudianteId
    final loginProvider = context.read<LoginProvider>();
    final materiaProvider = context.read<MateriaProvider>();
    
    if (loginProvider.estudianteId != null) {
      await materiaProvider.cargarMaterias(loginProvider.estudianteId!);
    } else {
      // Usuario no autenticado, redirigir al login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  });
}

  // Método auxiliar para construir la vista de error
  Widget _construirVistaError(MateriaProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error al cargar: ${provider.error}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
            final loginProvider = context.read<LoginProvider>();
            if (loginProvider.estudianteId != null) {
              await provider.cargarMaterias(loginProvider.estudianteId!);
            }
          },
          child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const BarraSuperior(), 
      
      body: Consumer<MateriaProvider>(
        builder: (context, provider, child) {
          // Usamos el getter en español
          if (provider.estaCargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _construirVistaError(provider);
          }

          return Column(
            children: [
              FiltrosMateriaWidget(provider: provider), 
              
              if (provider.materiasSeleccionadas.isNotEmpty)
                ResumenSeleccionWidget(provider: provider),
              Expanded(
                child: provider.materiasFiltradas.isEmpty
                    ? const Center(child: Text('No se encontraron materias.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.materiasFiltradas.length,
                        itemBuilder: (context, index) => TarjetaMateria(
                          materia: provider.materiasFiltradas[index],
                          provider: provider,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<MateriaProvider>(
            builder: (context, provider, child) {
              return BotonContinuarWidget(provider: provider);
            },
          ),
          BarraInferior(
            indiceActual: 0, 
            alCambiarTab: (i) { 
              // TODO: Lógica de navegación entre pestañas (e.g., /materias, /estados, /perfil)
            },
          ),
        ],
      ),
    );
  }
}