import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

class RestaurarContrasena extends StatefulWidget {
  const RestaurarContrasena({super.key});

  @override
  State<RestaurarContrasena> createState() => _RestaurarContrasenaState();
}

class _RestaurarContrasenaState extends State<RestaurarContrasena> {
  @override
  Widget build(BuildContext context) {
    TextEditingController correoCtrl = TextEditingController();
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: Center(
              child: Image.asset(
                'assets/images/Recurso 7.png',
                width: 240,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Recuperar contraseña',
              style: TextStyle(
                fontSize: 22,
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
          Center(
              child: SizedBox(
            width: 300,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(PrincipalColors.blue),
              ),
              child: const Text(
                'Recuperar Contraseña',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await API().passRecovery(correoCtrl.text, context);
              },
            ),
          )),
        ],
      ),
    );
  }
}
