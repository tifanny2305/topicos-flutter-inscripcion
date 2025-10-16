import 'package:flutter/material.dart';
import '../../../core/endpoints.dart';

class InfoBanner extends StatelessWidget {
  final int estudianteId;

  const InfoBanner({Key? key, required this.estudianteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.amber.shade100,
      child: Row(
        children: [
          Icon(Icons.person, color: Colors.amber.shade900),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modo de prueba',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                Text(
                  'Estudiante ID $estudianteId • Gestión ${Endpoints.gestionId}-${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
