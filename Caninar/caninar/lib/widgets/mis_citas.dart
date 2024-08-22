import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/citas/model_current.dart';
import 'package:caninar/models/citas/model_history.dart';
import 'package:caninar/models/citas/model_pending.dart';
import 'package:caninar/models/citas/model_coming.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/informacion_citas.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MisCitas extends StatefulWidget {
  bool? drawer;
  MisCitas({super.key, this.drawer});

  @override
  State<MisCitas> createState() => _MisCitasState();
}

class _MisCitasState extends State<MisCitas> {
  UserLoginModel? user;
  PendingModel? pendingModel;
  HistoryModel? historyModel;
  CurrentModel? currentModel;
  ComingModel? comingModel;
  bool isApiCallProcess = false;

  getCurrentUser() async {
    setState(() {
      isApiCallProcess = true; // Usar = para asignar valores
    });

    UserLoginModel? userTemp = await Shared().currentUser();

    // Verificar si el widget está montado antes de llamar a setState
    if (mounted) {
      setState(() {
        user = userTemp;
      });

      if (user != null) {
        await getCitas();
      }

      // Verificar si el widget está montado antes de llamar a setState
      if (mounted) {
        setState(() {
          isApiCallProcess = false; // Usar = para asignar valores
        });
      }
    }
  }

  getCitas() async {
    Map<String, dynamic> citasData = {};

    if (user?.type == 2) {
      citasData = await API().getCitas(user?.idSupplier, user?.type);
    } else {
      citasData = await API().getCitas(user?.id, user?.type);
    }

    PendingModel? pendingModelTemp;
    HistoryModel? historyModelTemp;
    CurrentModel? currentModelTemp;
    ComingModel? comingTemp;

    if (citasData.containsKey('pending')) {
      pendingModelTemp = PendingModel.fromJson(citasData['pending']);
    }

    if (citasData.containsKey('history')) {
      historyModelTemp = HistoryModel.fromJson(citasData['history']);
    }

    if (citasData.containsKey('current')) {
      currentModelTemp = CurrentModel.fromJson(citasData['current']);
    }
    if (citasData.containsKey('coming')) {
      comingTemp = ComingModel.fromJson(citasData['coming']);
    }

    if (mounted) {
      setState(() {
        pendingModel = pendingModelTemp;
        historyModel = historyModelTemp;
        currentModel = currentModelTemp;
        comingModel = comingTemp;
      });
    }
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
        tabs: [
          Tab(
            child: Badge.count(
              alignment: Alignment.topRight,
              count:
                  pendingModel?.dataCita != null ? pendingModel!.counter! : 0,
              backgroundColor: PrincipalColors.orange,
              child: const Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Pendientes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Tab(
            child: Text(
              'Historial',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const Tab(
            child: Text(
              'En curso',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const Tab(
            child: Text(
              'Próximas',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    ProductoProvider productoProvider = Provider.of<ProductoProvider>(context);
    if (isApiCallProcess) {
      EasyLoading.show(status: 'Cargando');
    } else {
      EasyLoading.dismiss();
    }
    return Scaffold(
      appBar: widget.drawer != null ? const CustomAppBar() : null,
      drawer: widget.drawer != null ? CustomDrawer() : null,
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              labelStyle: const TextStyle(color: Colors.black),
              indicatorColor: PrincipalColors.orange,
              tabs: [
                Tab(
                  child: Badge.count(
                    alignment: Alignment.topRight,
                    count: pendingModel?.dataCita != null
                        ? pendingModel!.counter!
                        : 0,
                    backgroundColor: PrincipalColors.orange,
                    child: const Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                        'Pendientes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Tab(
                  child: Text(
                    'Historial',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Tab(
                  child: Text(
                    'En curso',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Tab(
                  child: Text(
                    'Próximas',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RefreshIndicator(
                      child: ListView(children: [
                        if (user?.type != 2)
                          RedireccionAtras(nombre: 'Mis citas'),
                        pendingModel != null
                            ? Column(
                                children: pendingModel!.dataCita.map((e) {
                                return CardItemHome(
                                    terminadoCitas: false,
                                    imageCard: e.image,
                                    titulo: e.name!,
                                    redireccion: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InformacionCitas(
                                            estado: 'pending',
                                            titulo: e.name,
                                            informacionDetalle:
                                                e.infoDetalladaCita,
                                            proxima: true,
                                          ),
                                        ),
                                      );
                                    });
                              }).toList())
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'No tiene citas pendientes en este momento ')
                                ],
                              ),
                      ]),
                      onRefresh: () async {
                        await getCitas();
                      }),
                  RefreshIndicator(
                      child: ListView(children: [
                        if (user?.type != 2)
                          RedireccionAtras(nombre: 'Mis citas'),
                        historyModel != null
                            ? Column(
                                children: historyModel!.dataCita.map((e) {
                                return CardItemHome(
                                    terminadoCitas: false,
                                    imageCard: e.image,
                                    titulo: e.name!,
                                    redireccion: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InformacionCitas(
                                            estado: 'history',
                                            titulo: e.name,
                                            informacionDetalle:
                                                e.infoDetalladaCita,
                                            proxima: false,
                                          ),
                                        ),
                                      );
                                    });
                              }).toList())
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No tiene un historial de citas ')
                                ],
                              ),
                      ]),
                      onRefresh: () async {
                        await getCitas();
                      }),
                  RefreshIndicator(
                      child: ListView(children: [
                        if (user?.type != 2)
                          RedireccionAtras(nombre: 'Mis citas'),
                        currentModel != null
                            ? Column(
                                children: currentModel!.dataCita.map((e) {
                                return CardItemHome(
                                    terminadoCitas: false,
                                    imageCard: e.image,
                                    titulo: e.name!,
                                    redireccion: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InformacionCitas(
                                            estado: 'current',
                                            titulo: e.name,
                                            informacionDetalle:
                                                e.infoDetalladaCita,
                                            proxima: false,
                                          ),
                                        ),
                                      );
                                    });
                              }).toList())
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No tiene ninguna cita en curso')
                                ],
                              ),
                      ]),
                      onRefresh: () async {
                        await getCitas();
                      }),
                  RefreshIndicator(
                      child: ListView(children: [
                        if (user?.type != 2)
                          RedireccionAtras(nombre: 'Mis citas'),
                        comingModel != null
                            ? Column(
                                children: comingModel!.dataCita.map((e) {
                                return CardItemHome(
                                    terminadoCitas: false,
                                    imageCard: e.image,
                                    titulo: e.name!,
                                    redireccion: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InformacionCitas(
                                            estado: 'coming',
                                            titulo: e.name,
                                            informacionDetalle:
                                                e.infoDetalladaCita,
                                            proxima: false,
                                          ),
                                        ),
                                      );
                                    });
                              }).toList())
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No tiene ninguna cita próxima')
                                ],
                              ),
                      ]),
                      onRefresh: () async {
                        await getCitas();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
