import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:caninar/widgets/registro_mascota.dart';
import 'package:flutter/material.dart';

class PageRegistroMascotas extends StatefulWidget {
  Function refresh;
  bool registro;
  MascotasModel? mascota;

  PageRegistroMascotas(
      {super.key, required this.registro, required this.refresh, this.mascota});

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
          RedireccionAtras(
              nombre: widget.registro == true
                  ? 'Registro Mascotas'
                  : 'Editar Mascota'),
          Expanded(
              child: RegistroMascota(
            mascota: widget.mascota,
            registro: widget.registro,
            refresh: widget.refresh,
          ))
        ],
      ),
    );
  }
}
