import 'package:caninar/pages/home.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/login.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompraFinalizada extends StatefulWidget {
  const CompraFinalizada({super.key});

  @override
  State<CompraFinalizada> createState() => _CompraFinalizadaState();
}

class _CompraFinalizadaState extends State<CompraFinalizada> {
  @override
  void initState() {
    super.initState();
    // Limpia todos los proveedores al inicializar la pantalla
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      clearProviders();
    });
  }

  void clearProviders() {
    final OrdenProvider ordenProvider =
        Provider.of<OrdenProvider>(context, listen: false);
    final CartProvider carritoProvider =
        Provider.of<CartProvider>(context, listen: false);
    final ProductoProvider productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);

    carritoProvider.clearCart();
    ordenProvider.clearOrder();
    productoProvider.clearProducto();
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
          Center(
            child: Image.asset(
              'assets/images/Recurso 7.png',
              width: 200,
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Su compra fue realizada con exito!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          BotonCustom(
              funcion: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              texto: 'Volver al home')
        ],
      ),
    );
  }
}
