import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/materia_provider.dart';
import '../models/materia.dart';
import 'grupos_page.dart';

class MateriasPage extends ConsumerWidget {
  const MateriasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(materiasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Materias')),
      body: async.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => MateriaCard(materia: list[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: \$e')),
      ),
    );
  }
}

class MateriaCard extends StatelessWidget {
  final Materia materia;
  const MateriaCard({required this.materia, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(materia.nombre),
        subtitle: Text(
          'Codigo: \${materia.codigo} • Cred: \${materia.creditos}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GruposPage(materia: materia)),
            );
          },
        ),
      ),
    );
  }
}
