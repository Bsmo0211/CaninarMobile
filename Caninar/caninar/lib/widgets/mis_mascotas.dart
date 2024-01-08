import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/page_registro_mascotas.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class MisMascotas extends StatefulWidget {
  const MisMascotas({super.key});

  @override
  State<MisMascotas> createState() => _MisMascotasState();
}

class _MisMascotasState extends State<MisMascotas> {
  List<String> mascotas = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Mis mascotas'),
          mascotas.isEmpty
              ? Center(
                  child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(PrincipalColors.blue),
                    ),
                    child: const Text(
                      'Crear Nueva Mascota',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PageRegistroMascotas(registro: true),
                        ),
                      );
                    },
                  ),
                ))
              : Expanded(
                  child: ListView(
                  children: [
                    Column(
                      children: mascotas.map((producto) {
                        return CardItemHome(
                          titulo: '',
                          redireccion: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageRegistroMascotas(
                                  registro: false,
                                ),
                              ),
                            );
                          },
                          colorTexto: Colors.black,
                        );
                      }).toList(),
                    ),
                    Center(
                        child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              PrincipalColors.blue),
                        ),
                        child: const Text(
                          'Crear Nueva Mascota',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PageRegistroMascotas(registro: true),
                            ),
                          );
                        },
                      ),
                    ))
                  ],
                ))
        ],
      ),
    );
  }
}
