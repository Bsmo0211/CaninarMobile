import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class TerminosYCondiciones extends StatefulWidget {
  TerminosYCondiciones({Key? key}) : super(key: key);

  @override
  _TerminosYCondicionesState createState() => _TerminosYCondicionesState();
}

class _TerminosYCondicionesState extends State<TerminosYCondiciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Términos y Condiciones'),
        ],
      ),
    );
  }
}
