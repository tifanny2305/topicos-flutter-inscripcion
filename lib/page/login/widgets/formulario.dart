import 'package:flutter/material.dart';

/// Contiene los campos de texto y el botón de ingreso.
class FormularioWidget extends StatelessWidget {
  final TextEditingController controladorUsuario;
  final TextEditingController controladorContrasena;
  final bool estaCargando;
  // Usamos una función para que la lógica de autenticación viva fuera de este widget
  final VoidCallback alPresionarIngresar; 

  const FormularioWidget({
    super.key,
    required this.controladorUsuario,
    required this.controladorContrasena,
    required this.estaCargando,
    required this.alPresionarIngresar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo usuario
        TextFormField(
          controller: controladorUsuario,
          decoration: _decoracionCampo('Usuario', Icons.person),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese su usuario';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Campo contraseña
        TextFormField(
          controller: controladorContrasena,
          obscureText: true,
          decoration: _decoracionCampo('Contraseña', Icons.lock),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese su contraseña';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Botón login
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // El botón se deshabilita si 'estaCargando' es true
            onPressed: estaCargando ? null : alPresionarIngresar, 
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: estaCargando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'INGRESAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// MÉTODO AUXILIAR: Extraemos el diseño del campo de texto
InputDecoration _decoracionCampo(String etiqueta, IconData icono) {
  return InputDecoration(
    labelText: etiqueta,
    prefixIcon: Icon(icono),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
  );
}