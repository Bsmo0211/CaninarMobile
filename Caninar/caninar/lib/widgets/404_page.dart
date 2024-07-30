import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/item_home.dart';
import 'package:flutter/material.dart';

class PaginaNoEncontrada extends StatefulWidget {
  const PaginaNoEncontrada({super.key});

  @override
  State<PaginaNoEncontrada> createState() => _PaginaNoEncontradaState();
}

class _PaginaNoEncontradaState extends State<PaginaNoEncontrada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BotonCustom(
              funcion: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ItemHome(),
                  ),
                );
              },
              texto: 'Volver al inicio')
        ],
      ),
    );
  }
}
