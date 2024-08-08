import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/registro.dart';
import 'package:caninar/widgets/restaurar_contrasena.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  bool? perfil;
  bool? navegacion;
  Login({Key? key, this.perfil, this.navegacion})
      : super(
          key: key,
        );

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool _showPassword = true;
  TextEditingController correoCtrl = TextEditingController();
  TextEditingController contrasenaCtrl = TextEditingController();
  bool? requerido;

  validateCondition() {
    if (widget.perfil == true) {
      setState(() {
        requerido = true;
      });
    } else {
      setState(() {
        requerido = false;
      });
    }
  }

  @override
  void initState() {
    validateCondition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.navegacion != null ? CustomAppBar() : null,
      drawer: widget.navegacion != null ? CustomDrawer() : null,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Image.asset(
                  'assets/images/Recurso 7.png',
                  width: 240,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 50, bottom: 20),
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 20),
              child: Text('Email *'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: PrincipalColors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: PrincipalColors.blue,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 15.0,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                    ),
                  ),
                ),
                controller: correoCtrl,
                validator: (correoCtrl) {
                  if (correoCtrl == null || correoCtrl.isEmpty) {
                    return 'El campo es obligatorio';
                  } else {}
                  return null;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 20),
              child: Text('Contraseña *'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                obscureText: _showPassword,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: PrincipalColors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: PrincipalColors.blue,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 15.0,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(
                      color: PrincipalColors.blue,
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                controller: contrasenaCtrl,
                validator: (contrasenaCtrl) {
                  if (contrasenaCtrl == null || contrasenaCtrl.isEmpty) {
                    return 'El campo es obligatorio';
                  } else {}
                  return null;
                },
              ),
            ),
            Center(
                child: SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(PrincipalColors.blue),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (validate()) {
                    await Shared().login(correoCtrl.text, contrasenaCtrl.text,
                        context, requerido);
                  }
                },
              ),
            )),
            /*  Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.grey.shade400),
                  ),
                  onPressed: _handleSignIn,
                  icon: const FaIcon(FontAwesomeIcons.google,
                      color: Colors.white),
                  label: const Text('Iniciar sesión con Google',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.grey.shade400),
                  ),
                  onPressed: _handleSignIn,
                  icon: const FaIcon(FontAwesomeIcons.facebookF,
                      color: Colors.white),
                  label: const Text('Iniciar sesión con Facebook',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ), */
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RestaurarContrasena()),
                    );
                  },
                  child: Text(
                    '¿Olvidaste la contraseña?',
                    style: TextStyle(
                      color: PrincipalColors.orange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: '¿No tienes cuenta aún? ',
                      children: [
                        TextSpan(
                          text: 'Regístrate',
                          style: TextStyle(
                            color: PrincipalColors.orange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registro()),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  bool validate() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
