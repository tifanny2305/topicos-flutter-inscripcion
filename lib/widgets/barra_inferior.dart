import 'package:flutter/material.dart';

class BarraInferior extends StatelessWidget {
  // Índice actual para resaltar el ítem
  final int indiceActual; 
  // Función para manejar el cambio de pestaña
  final ValueChanged<int> alCambiarTab; 

  const BarraInferior({
    Key? key,
    required this.indiceActual,
    required this.alCambiarTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceActual,
      onTap: alCambiarTab,
      selectedItemColor: Colors.blue.shade700,
      unselectedItemColor: Colors.grey.shade600,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Materias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Estados',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}