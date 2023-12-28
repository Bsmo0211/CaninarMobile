import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class AtencionCliente extends StatefulWidget {
  AtencionCliente({Key? key}) : super(key: key);

  @override
  _AtencionClienteState createState() => _AtencionClienteState();
}

class _AtencionClienteState extends State<AtencionCliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Atención al Cliente'),
        ],
      ),
    );
  }
}
