import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class FiltrosMateria extends StatelessWidget {
  final MateriaProvider provider;
  const FiltrosMateria({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: provider.setSearchTerm,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o sigla...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: provider.nivelSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Nivel',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Todos')),
                    ...provider.niveles.map((nivel) => DropdownMenuItem(
                          value: nivel,
                          child: Text('Nivel $nivel'),
                        )),
                  ],
                  onChanged: (value) => provider.setNivelFilter(value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: provider.tipoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Todos')),
                    ...provider.tipos.map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        )),
                  ],
                  onChanged: (value) => provider.setTipoFilter(value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
