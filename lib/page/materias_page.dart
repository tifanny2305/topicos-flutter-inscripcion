import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/models/materia.dart';
import '../providers/materia_provider.dart';

class MateriasPage extends StatefulWidget {
  const MateriasPage({Key? key}) : super(key: key);

  @override
  State<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  @override
  void initState() {
    super.initState();
    // Cargar materias al iniciar
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.cargarMaterias(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Filtros
              _buildFilters(provider),
              
              // Contador de selección
              if (provider.materiasSeleccionadas.isNotEmpty)
                _buildSelectionCounter(provider),

              // Lista de materias
              Expanded(
                child: provider.materiasFiltradas.isEmpty
                    ? const Center(child: Text('No se encontraron materias'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.materiasFiltradas.length,
                        itemBuilder: (context, index) {
                          final materia = provider.materiasFiltradas[index];
                          return _buildMateriaCard(materia, provider);
                        },
                      ),
              ),

              // Botón continuar
              _buildContinueButton(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(MateriaProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Búsqueda
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
          // Filtros de Nivel y Tipo
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

  Widget _buildSelectionCounter(MateriaProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  '${provider.materiasSeleccionadas.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${provider.materiasSeleccionadas.length} materia(s) seleccionada(s)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          TextButton(
            onPressed: provider.clearSelection,
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriaCard(Materia materia, MateriaProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: materia.selected ? 4 : 1,
      color: materia.selected ? Colors.blue.shade50 : Colors.white,
      child: InkWell(
        onTap: () => provider.toggleMateria(materia),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: materia.selected ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            materia.sigla,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: materia.tipo.nombre == 'Electiva'
                                ? Colors.amber.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            materia.tipo.nombre,
                            style: TextStyle(
                              fontSize: 11,
                              color: materia.tipo.nombre == 'Electiva'
                                  ? Colors.amber.shade900
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      materia.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.book, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${materia.creditos} créditos',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.layers, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Nivel ${materia.nivel.nombre}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: materia.selected,
                onChanged: (_) => provider.toggleMateria(materia),
                activeColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(MateriaProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: provider.materiasSeleccionadas.isEmpty
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      '/grupos',
                      arguments: provider.materiasSeleccionadas,
                    );
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: const Text(
              'Continuar a grupos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}