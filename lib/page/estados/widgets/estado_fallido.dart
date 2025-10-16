import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/models/transacion_inscripcion.dart';

class EstadoFallido extends StatelessWidget {
  final TransaccionInscripcion transaccion;

  const EstadoFallido({super.key, required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final datos = transaccion.datos;
    final mensaje = datos?['message'] ?? 'Error desconocido al procesar la inscripción.';
    final gruposChoque = _extraerGruposChoque(mensaje);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _construirIcono(transaccion.tipoError == 'choque', transaccion.tipoError == 'cupo'),
            const SizedBox(height: 32),
            _construirTitulo(transaccion.tipoError == 'choque', transaccion.tipoError == 'cupo'),
            const SizedBox(height: 16),
            _construirMensajePrincipal(mensaje),
            const SizedBox(height: 32),
            _construirCardError(gruposChoque),
            const SizedBox(height: 32),
            _botonVolver(context),
          ],
        ),
      ),
    );
  }

  /// 🧠 Extrae pares de grupos (por ejemplo "(3, 5)") desde el mensaje del backend.
  List<List<String>> _extraerGruposChoque(String mensaje) {
    final exp = RegExp(r'\((\d+),\s*(\d+)\)');
    return exp
        .allMatches(mensaje)
        .map((m) => [m.group(1) ?? '', m.group(2) ?? ''])
        .toList();
  }

  Widget _construirIcono(bool esChoque, bool esCupo) {
    Color color;
    IconData icon;

    if (esChoque) {
      color = Colors.orange;
      icon = Icons.schedule;
    } else if (esCupo) {
      color = Colors.red;
      icon = Icons.cancel;
    } else {
      color = Colors.grey;
      icon = Icons.error_outline;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, size: 80, color: color),
    );
  }

  Widget _construirTitulo(bool esChoque, bool esCupo) {
    String titulo;
    Color color;

    if (esChoque) {
      titulo = 'Choque de Horarios';
      color = Colors.orange;
    } else if (esCupo) {
      titulo = 'Sin Cupos Disponibles';
      color = Colors.red;
    } else {
      titulo = 'Error en la Inscripción';
      color = Colors.grey;
    }

    return Text(
      titulo,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color),
      textAlign: TextAlign.center,
    );
  }

  Widget _construirMensajePrincipal(String mensaje) {
    return Text(
      mensaje,
      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
      textAlign: TextAlign.center,
    );
  }

  /// Decide qué card mostrar según el tipo de error
  Widget _construirCardError(List<List<String>> gruposChoque) {
    if (transaccion.tipoError == 'choque' && gruposChoque.isNotEmpty) {
      return _construirCardChoques(gruposChoque);
    } else if (transaccion.tipoError == 'cupo') {
      return _construirCardCupos();
    } else {
      return _construirCardGenerico();
    }
  }

  Widget _construirCardChoques(List<List<String>> gruposChoque) {
    return Card(
      elevation: 2,
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Conflictos detectados',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FixedColumnWidth(20),
                2: FixedColumnWidth(60),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  children: [
                    Text('Grupo A', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(),
                    Text('Grupo B', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const TableRow(children: [
                  SizedBox(height: 8),
                  SizedBox(),
                  SizedBox(),
                ]),
                ...gruposChoque.map((p) => TableRow(
                      children: [
                        Center(child: Text(p[0])),
                        const Center(
                            child: Icon(Icons.compare_arrows, size: 16, color: Colors.orange)),
                        Center(child: Text(p[1])),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Por favor elige grupos con horarios diferentes.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirCardCupos() {
    return Card(
      elevation: 2,
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Row(
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Cupos agotados',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Uno o más grupos no tienen cupos disponibles.\n'
              'Intenta seleccionar otros grupos con disponibilidad.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirCardGenerico() {
    return Card(
      elevation: 2,
      color: Colors.grey.shade100,
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Ocurrió un error inesperado.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  Widget _botonVolver(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        icon: const Icon(Icons.home),
        label: const Text('Volver al inicio'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
