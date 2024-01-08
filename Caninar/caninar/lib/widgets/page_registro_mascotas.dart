import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:caninar/widgets/registro_mascota.dart';
import 'package:flutter/material.dart';

class PageRegistroMascotas extends StatefulWidget {
  bool registro;
  PageRegistroMascotas({
    super.key,
    required this.registro,
  });

  @override
  State<PageRegistroMascotas> createState() => _PageRegistroMascotasState();
}

class _PageRegistroMascotasState extends State<PageRegistroMascotas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Registro Mascotas'),
          Expanded(
              child: RegistroMascota(
            registro: widget.registro,
          ))
        ],
      ),
    );
  }
}
