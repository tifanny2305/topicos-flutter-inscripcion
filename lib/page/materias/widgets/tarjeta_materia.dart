import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/models/materia.dart';
import 'package:topicos_inscripciones/providers/materia_provider.dart';

class TarjetaMateria extends StatelessWidget {
  final Materia materia;
  final MateriaProvider provider;

  const TarjetaMateria({
    Key? key,
    required this.materia,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      // Sombra más notoria al seleccionar (mejor UI/UX)
      elevation: materia.selected ? 6 : 2, 
      color: materia.selected ? Colors.blue.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes más redondeados
        side: materia.selected // Borde azul al seleccionar para mejor indicación
            ? BorderSide(color: Colors.blue.shade400, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        // Usamos el método en español
        onTap: () => provider.alternarSeleccionMateria(materia), 
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: _construirContenidoMateria()),
              // Checkbox con color principal
              Checkbox(
                value: materia.selected,
                // Usamos el método en español
                onChanged: (_) => provider.alternarSeleccionMateria(materia), 
                activeColor: Colors.blue.shade700, 
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye los detalles internos de la materia (sigla, nombre, créditos, nivel).
  Widget _construirContenidoMateria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          // Sigla de la Materia
          _etiqueta(
            materia.sigla, 
            materia.selected ? Colors.blue.shade400 : Colors.grey.shade500,
            textoColor: Colors.white,
          ),
          const SizedBox(width: 8),
          // Tipo de Materia (Electiva, Troncal, etc.)
          _etiqueta(
            materia.tipo.nombre,
            materia.tipo.nombre == 'Electiva' ? Colors.orange.shade100 : Colors.grey.shade100,
            textoColor: materia.tipo.nombre == 'Electiva'
                ? Colors.orange.shade900
                : Colors.grey.shade700,
          ),
        ]),
        const SizedBox(height: 8),
        // Nombre de la Materia (Tipografía mejorada)
        Text(
            materia.nombre,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14, 
              color: Colors.black87,
            )),
        const SizedBox(height: 4),
        Row(
          // Información secundaria: Créditos y Nivel
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

  /// Widget auxiliar para crear etiquetas pequeñas con colores.
  Widget _etiqueta(String texto, Color color, {Color textoColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6), // Bordes más suaves
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