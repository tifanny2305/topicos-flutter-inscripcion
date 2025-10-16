import 'package:flutter/material.dart';
import '../../../providers/grupo_provider.dart';
import '../../../models/grupo.dart';

class CardGrupo extends StatelessWidget {
  final Grupo grupo;
  final MateriaConGrupos materiaConGrupos;
  final GrupoProvider provider;

  const CardGrupo({
    super.key,
    required this.grupo,
    required this.materiaConGrupos,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = materiaConGrupos.grupoSeleccionadoId == grupo.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 3 : 1,
      color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
      child: InkWell(
        onTap: () => provider.seleccionarGrupo(materiaConGrupos.materia.id, grupo.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grupo ${grupo.sigla}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isSelected ? Colors.blue.shade900 : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (grupo.docente != null)
                      Row(
                        children: [
                          Icon(Icons.person, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(grupo.docente?.nombre ?? '',
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ...grupo.horarios.map((h) => Row(
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${h.dia}: ${h.horaInicio.substring(0, 5)} - ${h.horaFin.substring(0, 5)}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        )),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.people, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${grupo.cupo} cupos disponibles',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Radio<int>(
                value: grupo.id,
                groupValue: materiaConGrupos.grupoSeleccionadoId,
                onChanged: (_) => provider.seleccionarGrupo(materiaConGrupos.materia.id, grupo.id),
                activeColor: Colors.blue,
                toggleable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
