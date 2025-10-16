import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/models/materia.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class CardMateria extends StatelessWidget {
  final Materia materia;
  final MateriaProvider provider;

  const CardMateria({
    Key? key,
    required this.materia,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Expanded(child: _construirContenidoMateria()),
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

  Widget _construirContenidoMateria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _etiqueta(materia.sigla, materia.selected ? Colors.blue : Colors.grey),
          const SizedBox(width: 8),
          _etiqueta(
            materia.tipo.nombre,
            materia.tipo.nombre == 'Electiva' ? Colors.amber : Colors.grey.shade300,
            textoColor: materia.tipo.nombre == 'Electiva'
                ? Colors.amber.shade900
                : Colors.grey.shade700,
          ),
        ]),
        const SizedBox(height: 8),
        Text(materia.nombre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.book, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text('${materia.creditos} créditos',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(width: 12),
            const Icon(Icons.layers, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text('Nivel ${materia.nivel.nombre}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _etiqueta(String texto, Color color, {Color textoColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: textoColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
