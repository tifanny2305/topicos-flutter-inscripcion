import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/page/grupos/widgets/btn_continuar.dart';
import '../../models/materia.dart';
import '../../providers/grupo_provider.dart';
import 'widgets/barra_progreso.dart';
import 'widgets/card_materia_grupo.dart';


class GruposPage extends StatefulWidget {
  final List<Materia> materias;

  const GruposPage({Key? key, required this.materias}) : super(key: key);

  @override
  State<GruposPage> createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GrupoProvider>().cargarGruposPorMaterias(widget.materias);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Grupos'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<GrupoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.cargarGruposPorMaterias(widget.materias);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              BarraProgreso(provider: provider),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.materiasConGrupos.length,
                  itemBuilder: (context, index) {
                    final materiaConGrupos = provider.materiasConGrupos[index];
                    return CardMateriaGrupo(
                      materiaConGrupos: materiaConGrupos,
                      provider: provider,
                    );
                  },
                ),
              ),
              BotonContinuar(provider: provider),
            ],
          );
        },
      ),
    );
  }
}
