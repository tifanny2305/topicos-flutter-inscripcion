import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class FiltrosMateriaWidget extends StatelessWidget {
  final MateriaProvider provider;
  const FiltrosMateriaWidget({Key? key, required this.provider})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Campo de búsqueda con bordes redondeados
          TextField(
            onChanged: provider.aplicarTerminoBusqueda,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o sigla...',
              prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Dropdown Nivel
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: provider.nivelSeleccionado,
                  decoration: _decoracionDropdown('Nivel'),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  menuMaxHeight: 300, 
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Todos')),
                    ...provider.nivelesDisponibles.map(
                      (nivel) => DropdownMenuItem(
                        value: nivel,
                        child: Text('Nivel $nivel'),
                      ),
                    ),
                  ],
                  onChanged: (value) => provider.aplicarFiltroNivel(value!),
                ),
              ),
              const SizedBox(width: 16),
              // Dropdown Tipo
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: provider.tipoSeleccionado,
                  decoration: _decoracionDropdown('Tipo'),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  menuMaxHeight: 300, 
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Todos')),
                    ...provider.tiposDisponibles.map(
                      (tipo) =>
                          DropdownMenuItem(value: tipo, child: Text(tipo)),
                    ),
                  ],
                  onChanged: (value) => provider.aplicarFiltroTipo(value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MÉTODO AUXILIAR para no repetir código de estilo del Dropdown
  InputDecoration _decoracionDropdown(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
