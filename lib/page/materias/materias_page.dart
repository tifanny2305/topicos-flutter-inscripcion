import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/page/materias/widgets/btn_continuar.dart';
import 'package:topicos_inscripciones/page/materias/widgets/card_materia.dart';
import 'package:topicos_inscripciones/page/materias/widgets/filtros_materia.dart';
import 'package:topicos_inscripciones/page/materias/widgets/seleccion_resumen.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';


class MateriasPage extends StatefulWidget {
  const MateriasPage({Key? key}) : super(key: key);

  @override
  State<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MateriaProvider>().cargarMaterias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Materias'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<MateriaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _construirError(provider);
          }

          return Column(
            children: [
              FiltrosMateria(provider: provider),
              if (provider.materiasSeleccionadas.isNotEmpty)
                SeleccionMateria(provider: provider),
              Expanded(
                child: provider.materiasFiltradas.isEmpty
                    ? const Center(child: Text('No se encontraron materias'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.materiasFiltradas.length,
                        itemBuilder: (context, index) => 
                            CardMateria(
                              materia: provider.materiasFiltradas[index],
                              provider: provider,
                            ),
                      ),
              ),
              BotonContinuar(provider: provider),
            ],
          );
        },
      ),
    );
  }

  Widget _construirError(MateriaProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: provider.cargarMaterias,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
