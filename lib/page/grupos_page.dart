import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/materia.dart';
import '../providers/grupo_provider.dart';
import '../models/grupo.dart';
import 'inscripcion_page.dart';

class GruposPage extends ConsumerWidget {
  final Materia materia;
  const GruposPage({required this.materia, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(gruposProvider(materia.id));
    return Scaffold(
      appBar: AppBar(title: Text('Grupos - \${materia.nombre}')),
      body: async.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) =>
              GrupoCard(grupo: list[i], materia: materia),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: \$e')),
      ),
    );
  }
}

class GrupoCard extends StatelessWidget {
  final Grupo grupo;
  final Materia materia;
  const GrupoCard({required this.grupo, required this.materia, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text('Grupo \${grupo.codigo} • \${grupo.turno}'),
        subtitle: Text('Cupo: \${grupo.inscritos}/\${grupo.cupo}'),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InscripcionPage(materia: materia, grupo: grupo),
              ),
            );
          },
          child: const Text('Inscribirme'),
        ),
      ),
    );
  }
}
