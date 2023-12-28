import 'package:flutter/material.dart';

class ItemDrawer extends StatelessWidget {
  String titulo;
  Function redireccion;
  ItemDrawer({Key? key, required this.titulo, required this.redireccion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: GestureDetector(
        child: Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        onTap: () {
          redireccion();
        },
      ),
    );
  }
}
