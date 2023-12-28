import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';

class RedireccionAtras extends StatelessWidget {
  String nombre;
  RedireccionAtras({
    Key? key,
    required this.nombre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: PrincipalColors.orange,
          )),
      title: Text(
        nombre,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
