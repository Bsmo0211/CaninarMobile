import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/home_adriestrador.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:flutter/material.dart';

class PaseoTerminado extends StatefulWidget {
  const PaseoTerminado({super.key});

  @override
  State<PaseoTerminado> createState() => _PaseoTerminadoState();
}

class _PaseoTerminadoState extends State<PaseoTerminado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Recurso 7.png',
              width: 200,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Text(
                'Paseo terminado con éxito!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BotonCustom(
                funcion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeAdiestrador(),
                    ),
                  );
                },
                texto: 'Volver a Inicio')
          ],
        ),
      ),
    );
  }
}
