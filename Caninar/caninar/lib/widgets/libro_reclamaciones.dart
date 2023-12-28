import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class LibroReclamaciones extends StatefulWidget {
  LibroReclamaciones({Key? key}) : super(key: key);

  @override
  _LibroReclamacionesState createState() => _LibroReclamacionesState();
}

class _LibroReclamacionesState extends State<LibroReclamaciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Libro de Reclamaciones'),
        ],
      ),
    );
  }
}
