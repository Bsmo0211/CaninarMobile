import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/informacion_citas.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MisCitas extends StatefulWidget {
  const MisCitas({super.key});

  @override
  State<MisCitas> createState() => _MisCitasState();
}

class _MisCitasState extends State<MisCitas> {
  @override
  void initState() {
    super.initState();
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        labelStyle: const TextStyle(color: Colors.black),
        indicatorColor: PrincipalColors.orange,
        tabs: const [
          Tab(
            child: Text(
              'Pendientes',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              'Historial',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              'En curso',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              'Próximas',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: PrincipalColors.blue,
            elevation: 0,
            title: Image.asset(
              'assets/images/logo.png',
              width: 90,
            ),
            actions: [
              GestureDetector(
                child: Image.asset(
                  'assets/images/wpp.png',
                  width: 30,
                ),
                onTap: () {
                  API().launchWhatsApp('51919285667');
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: Badge.count(
                  count: cartProvider.cartItems.length,
                  backgroundColor: PrincipalColors.orange,
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarritoCompras()),
                      );
                    },
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: Material(
                  color: Colors.white, //<-- SEE HERE
                  child: _tabBar),
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(
            children: [
              ListView(children: [
                RedireccionAtras(nombre: 'Mis citas'),
                Column(
                    children: [1, 2, 3].map((e) {
                  return CardItemHome(
                      titulo: 'Prueba pendiente',
                      redireccion: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InformacionCitas()),
                        );
                      });
                }).toList()),
              ]),
              ListView(children: [
                RedireccionAtras(nombre: 'Mis citas'),
                Column(
                    children: [1, 2, 3].map((e) {
                  return CardItemHome(
                      titulo: 'Prueba Historial',
                      redireccion: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InformacionCitas()),
                        );
                      });
                }).toList()),
              ]),
              ListView(children: [
                RedireccionAtras(nombre: 'Mis citas'),
                Column(
                    children: [1, 2, 3].map((e) {
                  return CardItemHome(
                      titulo: 'Prueba En curso',
                      redireccion: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InformacionCitas()),
                        );
                      });
                }).toList()),
              ]),
              ListView(children: [
                RedireccionAtras(nombre: 'Mis citas'),
                Column(
                    children: [1, 2, 3].map((e) {
                  return CardItemHome(
                      titulo: 'Prueba Próximas',
                      redireccion: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InformacionCitas()),
                        );
                      });
                }).toList()),
              ]),
            ],
          ),
        ));
  }
}
