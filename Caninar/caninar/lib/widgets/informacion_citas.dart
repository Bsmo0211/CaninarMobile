import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/info_detallada_adiestrador.dart';
import 'package:caninar/widgets/informacion_detallada_cita.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class InformacionCitas extends StatefulWidget {
  const InformacionCitas({super.key});

  @override
  State<InformacionCitas> createState() => _InformacionCitasState();
}

class _InformacionCitasState extends State<InformacionCitas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Texto viene endpoint'),
          Expanded(
              child: ListView(
            children: [1, 2, 3].map((e) {
              return CardItemHome(
                titulo: 'Paseador',
                redireccion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformacionDetalladaCita()),
                  );
                },
                precios: ' fecha \n hora',
                colorTexto: Colors.black,
                icono: Icon(
                  Icons.star,
                  color: PrincipalColors.orange,
                ),
              );
            }).toList(),
          ))
        ],
      ),
    );
  }
}
