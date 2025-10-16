import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/page/inscripciones/widgets/action_btn.dart';
import '../../core/endpoints.dart';
import '../../providers/inscripcion_provider.dart';
import 'widgets/info_banner.dart';
import 'widgets/grupo_card.dart';

class InscripcionPage extends StatelessWidget {
  final List<Map<String, dynamic>> gruposSeleccionados;

  const InscripcionPage({Key? key, required this.gruposSeleccionados})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Inscripción'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<InscripcionProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              //InfoBanner(estudianteId: Endpoints.estudianteId),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Materias y Grupos Seleccionados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...gruposSeleccionados.map(
                      (grupo) => GrupoCard(grupo: grupo),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              ActionButtons(
                provider: provider,
                gruposSeleccionados: gruposSeleccionados,
              ),
            ],
          );
        },
      ),
    );
  }
}
