// lib/page/inscripciones/inscripcion_page.dart
import 'package:flutter/material.dart';
import 'widgets/action_btn.dart';
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
      body: Column(
        children: [
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
          ActionButtons(gruposSeleccionados: gruposSeleccionados),
        ],
      ),
    );
  }
}