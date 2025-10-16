import 'package:flutter/material.dart';
import '../../../models/grupo.dart';

class GrupoCard extends StatelessWidget {
  final Map<String, dynamic> grupo;

  const GrupoCard({Key? key, required this.grupo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extraer datos del grupo
    final docente = grupo['docente'] as Map<String, dynamic>?;
    final horarios = grupo['horarios'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                      _buildBadge(grupo['materiaSigla'] ?? '', Colors.blue),
                      const SizedBox(width: 8),
                      _buildBadge(
                        'Grupo ${grupo['grupoSigla'] ?? ''}',
                        Colors.grey.shade300,
                        textColor: Colors.grey.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    grupo['materiaNombre'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Mostrar docente si existe
                  if (docente != null && docente['nombre'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            docente['nombre'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Mostrar horarios
                  ...horarios.map((h) {
                    final horario = h as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${horario['dia'] ?? ''}: ${_formatTime(horario['horaInicio'])} - ${_formatTime(horario['horaFin'])}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  String _formatTime(dynamic time) {
    if (time == null) return '';
    final timeStr = time.toString();
    return timeStr.length >= 5 ? timeStr.substring(0, 5) : timeStr;
  }

  Widget _buildBadge(String text, Color color, {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}