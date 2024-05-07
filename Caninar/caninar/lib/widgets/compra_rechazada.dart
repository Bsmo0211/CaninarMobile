import 'package:caninar/navigation_pages/navigation_home.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:flutter/material.dart';

class CompraRechazada extends StatefulWidget {
  const CompraRechazada({super.key});

  @override
  State<CompraRechazada> createState() => _CompraRechazadaState();
}

class _CompraRechazadaState extends State<CompraRechazada> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Recurso 7.png',
            width: 200,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                'Su compra fue rechazada!,¿Quiere volver a intentar realizar el pago?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BotonCustom(
                  funcion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarritoCompras()),
                    );
                  },
                  texto: 'Si'),
              BotonCustom(
                  funcion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  texto: 'No'),
            ],
          )
        ],
      ),
    );
  }
}
