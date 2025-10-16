import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/page/grupos/widgets/mensaje_sin%20grupo.dart';
import '../../../providers/grupo_provider.dart';
import 'card_grupo.dart';

class CardMateriaGrupo extends StatelessWidget {
  final MateriaConGrupos materiaConGrupos;
  final GrupoProvider provider;

  const CardMateriaGrupo({
    super.key,
    required this.materiaConGrupos,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            materiaConGrupos.grupos.isEmpty
                ? const MensajeSinGrupos()
                : Column(
                    children: materiaConGrupos.grupos
                        .map(
                          (grupo) => CardGrupo(
                            grupo: grupo,
                            materiaConGrupos: materiaConGrupos,
                            provider: provider,
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final materia = materiaConGrupos.materia;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                materia.sigla,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: materia.tipo.nombre == 'Electiva'
                    ? Colors.amber.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(materia.tipo.nombre),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          materia.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
