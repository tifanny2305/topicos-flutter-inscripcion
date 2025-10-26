import 'package:flutter/material.dart';
import 'package:topicos_inscripciones/page/login/widgets/encabezado.dart';
import 'package:topicos_inscripciones/page/login/widgets/formulario.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _claveFormulario = GlobalKey<FormState>();

  final _controladorUsuario = TextEditingController(text: 'estudiante1');
  final _controladorContrasena = TextEditingController(text: '123456');
  bool _estaCargando = false;

  @override
  void dispose() {
    _controladorUsuario.dispose();
    _controladorContrasena.dispose();
    super.dispose();
  }

  // MÉTODO CLAVE: Lógica de Autenticación
  Future<void> _autenticar() async {
    // 1. Validar el formulario
    if (!_claveFormulario.currentState!.validate()) return;

    // 2. Iniciar la carga y refrescar la UI
    setState(() => _estaCargando = true);

    // TODO: Aquí va la llamada real a tu API con ClienteApi.enviar(...)
    // Por ahora, simulamos el retraso.
    await Future.delayed(const Duration(seconds: 1));

    // 3. Finalizar la carga y refrescar la UI
    setState(() => _estaCargando = false);

    // 4. Navegación (siempre verifica 'mounted')
    if (mounted) {
      // Login exitoso - navegar a materias
      Navigator.pushReplacementNamed(context, '/materias');
    }
  }

  @override
  Widget build(BuildContext context) {
    // EL MÉTODO BUILD AHORA ES EXTREMADAMENTE SIMPLE Y CLARO
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _claveFormulario,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Widget Encabezado
                  const EncabezadoWidget(),
                  const SizedBox(height: 48),

                  // Widget Lógica del formulario
                  FormularioWidget(
                    controladorUsuario: _controladorUsuario,
                    controladorContrasena: _controladorContrasena,
                    estaCargando: _estaCargando,
                    alPresionarIngresar: _autenticar, // método de autenticación
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
