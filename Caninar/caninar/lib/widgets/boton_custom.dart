import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';

class BotonCustom extends StatelessWidget {
  String texto;
  Function funcion;
  BotonCustom({
    Key? key,
    required this.funcion,
    required this.texto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
      child: TextButton(
        onPressed: () {
          funcion();
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(12),
          ),
          backgroundColor:
              MaterialStatePropertyAll<Color>(PrincipalColors.blue),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
