import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/citas/model_current.dart';
import 'package:caninar/models/citas/model_history.dart';
import 'package:caninar/models/citas/model_pending.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
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
  UserLoginModel? user;
  PendingModel? pendingModel;
  HistoryModel? historyModel;
  CurrentModel? currentModel;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });

    await getCitas();
  }

  getCitas() async {
    Map<String, dynamic> citasData = await API().getCitas(user?.id);

    PendingModel? pendingModelTemp;
    HistoryModel? historyModelTemp;
    CurrentModel? currentModelTemp;

    if (citasData.containsKey('pending')) {
      pendingModelTemp = PendingModel.fromJson(citasData['pending']);
    }

    if (citasData.containsKey('history')) {
      historyModelTemp = HistoryModel.fromJson(citasData['history']);
    }

    if (citasData.containsKey('current')) {
      currentModelTemp = CurrentModel.fromJson(citasData['current']);
    }

    setState(() {
      pendingModel = pendingModelTemp;
      historyModel = historyModelTemp;
      currentModel = currentModelTemp;
    });

    print(historyModel?.dataCita.length);
    print(pendingModel?.dataCita.length);
    print(currentModel?.dataCita.length);
  }

  @override
  void initState() {
    getCurrentUser();
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
        ],
      );

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return DefaultTabController(
        length: 3,
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
              child: Material(color: Colors.white, child: _tabBar),
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(
            children: [
              ListView(children: [
                RedireccionAtras(nombre: 'Mis citas'),
                pendingModel != null
                    ? Column(
                        children: pendingModel!.dataCita.map((e) {
                        return CardItemHome(
                            imageCard: e.image,
                            titulo: e.name!,
                            redireccion: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformacionCitas(
                                    titulo: e.name,
                                    informacionDetalle: e.infoDetalladaCita,
                                  ),
                                ),
                              );
                            });
                      }).toList())
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No tiene citas pendientes en este momento ')
                        ],
                      ),
              ]),
              ListView(children: [
                RedireccionAtras(nombre: 'Mis citas'),
                historyModel != null
                    ? Column(
                        children: historyModel!.dataCita.map((e) {
                        return CardItemHome(
                            imageCard: e.image,
                            titulo: e.name!,
                            redireccion: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformacionCitas(
                                    titulo: e.name,
                                    informacionDetalle: e.infoDetalladaCita,
                                  ),
                                ),
                              );
                            });
                      }).toList())
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('No tiene un historial de citas ')],
                      ),
              ]),
              ListView(children: [
                RedireccionAtras(nombre: 'Mis citas'),
                currentModel != null
                    ? Column(
                        children: currentModel!.dataCita.map((e) {
                        return CardItemHome(
                            imageCard: e.image,
                            titulo: e.name!,
                            redireccion: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformacionCitas(
                                    titulo: e.name,
                                    informacionDetalle: e.infoDetalladaCita,
                                  ),
                                ),
                              );
                            });
                      }).toList())
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('No tiene ninguna cita en curso')],
                      ),
              ]),
            ],
          ),
        ));
  }
}
