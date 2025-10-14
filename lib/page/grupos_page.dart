// lib/pages/grupos_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/materia.dart';
import '../providers/grupo_provider.dart';

class GruposPage extends StatefulWidget {
  final List<Materia> materiasSeleccionadas;

  const GruposPage({Key? key, required this.materiasSeleccionadas}) : super(key: key);

  @override
  State<GruposPage> createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  @override
  void initState() {
    super.initState();
    // Cargar grupos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GrupoProvider>().cargarGruposPorMaterias(widget.materiasSeleccionadas);
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
                      provider.cargarGruposPorMaterias(widget.materiasSeleccionadas);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Barra de progreso
              _buildProgressBar(provider),
              
              // Lista de materias con grupos
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.materiasConGrupos.length,
                  itemBuilder: (context, index) {
                    final materiaConGrupos = provider.materiasConGrupos[index];
                    return _buildMateriaSection(materiaConGrupos, provider);
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

  Widget _buildProgressBar(GrupoProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progreso de selección',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${provider.progresoSeleccion}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: provider.progresoSeleccion / 100,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blue,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${provider.materiasSeleccionadas} de ${provider.materiasConGrupos.length} materias con grupo seleccionado',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriaSection(MateriaConGrupos materiaConGrupos, GrupoProvider provider) {
    final gruposDisponibles = provider.gruposConCupo(materiaConGrupos.grupos);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de materia
            Row(
              children: [
                Expanded(
                  child: Column(
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
                              materiaConGrupos.materia.sigla,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: materiaConGrupos.materia.tipo.nombre == 'Electiva'
                                  ? Colors.amber.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              materiaConGrupos.materia.tipo.nombre,
                              style: TextStyle(
                                fontSize: 11,
                                color: materiaConGrupos.materia.tipo.nombre == 'Electiva'
                                    ? Colors.amber.shade900
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                          if (materiaConGrupos.grupoSeleccionadoId != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, size: 12, color: Colors.green.shade700),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Seleccionado',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        materiaConGrupos.materia.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.book, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${materiaConGrupos.materia.creditos} créditos',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.layers, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Nivel ${materiaConGrupos.materia.nivel.nombre}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Lista de grupos
            if (gruposDisponibles.isEmpty)
              _buildNoGruposMessage()
            else
              ...gruposDisponibles.map((grupo) => _buildGrupoCard(
                    grupo,
                    materiaConGrupos,
                    provider,
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildNoGruposMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No hay grupos disponibles',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Esta materia no tiene grupos con cupos',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildGrupoCard(
    grupo,
    MateriaConGrupos materiaConGrupos,
    GrupoProvider provider,
  ) {
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
                    Row(
                      children: [
                        Text(
                          'Grupo ${grupo.sigla}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? Colors.blue.shade900 : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (grupo.docente != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: isSelected ? Colors.blue.shade700 : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              grupo.docente.nombre,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (grupo.horarios.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      ...grupo.horarios.map((horario) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: isSelected ? Colors.blue.shade700 : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${horario.dia}: ${horario.horaInicio.substring(0, 5)} - ${horario.horaFin.substring(0, 5)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
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
                          Icon(
                            Icons.people,
                            size: 12,
                            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${grupo.cupo} cupos disponibles',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Radio(
                value: grupo.id,
                groupValue: materiaConGrupos.grupoSeleccionadoId,
                onChanged: (_) => provider.seleccionarGrupo(materiaConGrupos.materia.id, grupo.id),
                activeColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(GrupoProvider provider) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${provider.materiasConGrupos.length} materias',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  provider.tieneAlMenosUnaSeleccionada
                      ? '${provider.materiasSeleccionadas} seleccionada(s)'
                      : 'Selecciona al menos un grupo',
                  style: TextStyle(
                    fontSize: 12,
                    color: provider.tieneAlMenosUnaSeleccionada
                        ? Colors.green
                        : Colors.amber.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.tieneAlMenosUnaSeleccionada
                    ? () {
                        final gruposSeleccionados = provider.obtenerGruposSeleccionados();
                        Navigator.pushNamed(
                          context,
                          '/inscripcion',
                          arguments: gruposSeleccionados,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  'Continuar a inscripción',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}