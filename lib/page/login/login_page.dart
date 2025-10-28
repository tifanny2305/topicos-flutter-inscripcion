import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topicos_inscripciones/page/login/widgets/encabezado.dart';
import 'package:topicos_inscripciones/page/login/widgets/formulario.dart';
import 'package:topicos_inscripciones/providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _claveFormulario = GlobalKey<FormState>();

  final _controladorRegistro = TextEditingController();
  final _controladorCodigo = TextEditingController();
  bool _estaCargando = false;

  @override
  void dispose() {
    _controladorRegistro.dispose();
    _controladorCodigo.dispose();
    super.dispose();
  }

  //Lógica de Autenticación
  Future<void> _autenticar() async {

    if (!_claveFormulario.currentState!.validate()) return;

    setState(() => _estaCargando = true);

    final authProvider = Provider.of<LoginProvider>(context, listen: false);
    final registro = _controladorRegistro.text;
    final codigo = _controladorCodigo.text;
    final exito = await authProvider.login(registro, codigo);

    setState(() => _estaCargando = false);

    if (mounted) {
      if (exito) {
        Navigator.pushReplacementNamed(context, '/materias');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de autenticación. Verifique su registro y código.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                    controladorRegistro: _controladorRegistro,
                    controladorCodigo: _controladorCodigo,
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
