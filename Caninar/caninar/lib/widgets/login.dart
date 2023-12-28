import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/pages/home.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:caninar/widgets/registro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController correoCtrl = TextEditingController();
  TextEditingController contrasenaCtrl = TextEditingController();

  Future<void> _handleSignIn() async {
    try {
      await GoogleSignIn().signIn();
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/Recurso 7.png',
              width: 240,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 50, bottom: 20),
            child: Text(
              'Inciar Sesión',
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
              child: const Text('Iniciar Sesión'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FinalizarCompra()),
                );
              },
            ),
          )),
          Center(
            child: SizedBox(
              width: 300,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.grey.shade400),
                ),
                onPressed: _handleSignIn,
                icon: const FaIcon(FontAwesomeIcons.google),
                label: const Text('Iniciar sesión con Google'),
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
                icon: const FaIcon(FontAwesomeIcons.facebookF),
                label: const Text('Iniciar sesión con Facebook'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
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
              padding: EdgeInsets.only(top: 10),
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
    );
  }
}
