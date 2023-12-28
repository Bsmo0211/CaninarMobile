import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/login.dart';
import 'package:flutter/material.dart';

class RegistroCompleto extends StatelessWidget {
  const RegistroCompleto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25),
            child: Icon(
              Icons.email_outlined,
              size: 60,
              color: PrincipalColors.blue,
            ),
          ),
          const Center(
            child: Text(
              'Completa tu registro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Text(
                textAlign: TextAlign.justify,
                'Revisa la bandeja de entrada de tu correo electrónico y haz click en el enlace enviado para terminar tu registro.',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text:
                      'Si tuvieras alguna dificultad comunicate con nosotros por Whatsapp al ',
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: '+51 919 285 667',
                      style: TextStyle(
                        color: PrincipalColors.orange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(
                      text: ' o al correo ',
                    ),
                    TextSpan(
                      text: 'contacto@caninar.com. ',
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
          Center(
            child: BotonCustom(funcion: () {}, texto: 'Confirmar Correo'),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text(
                'Ir a inciar sesion',
                style: TextStyle(
                  color: PrincipalColors.orange,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
