import 'dart:async';
import 'dart:developer';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class InformacionDetalladaCitaCliente extends StatefulWidget {
  String estado;
  String nombreRedireccion;
  MascotasModel mascota;
  String idSchedule;
  InformacionDetalladaCitaCliente(
      {super.key,
      required this.nombreRedireccion,
      required this.mascota,
      required this.idSchedule,
      required this.estado});

  @override
  State<InformacionDetalladaCitaCliente> createState() =>
      _InformacionDetalladaCitaClienteState();
}

class _InformacionDetalladaCitaClienteState
    extends State<InformacionDetalladaCitaCliente> {
  LatLng _initialCameraPosition = const LatLng(0.0, 0.0);
  bool _isLocationLoaded = false;
  UserLoginModel? user;
  bool paseoIniciado = false;
  List<LatLng> puntos = [];
  Timer? _timer;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    log(permission.name);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialCameraPosition = LatLng(position.latitude, position.longitude);
        _isLocationLoaded = true;
      });
    }

  Future<void> getLocationPaseador() async {
    List<Map<String, dynamic>> coordenadas =
        await API().getPointsSupplierById(widget.idSchedule);

    List<Map<String, double>> coordenadasDouble = coordenadas.map((coordenada) {
      return {
        'lat': double.parse(coordenada['lat']),
        'long': double.parse(coordenada['long']),
      };
    }).toList();

    setState(() {
      puntos.clear();
      for (var coordenada in coordenadasDouble) {
        puntos.add(LatLng(coordenada['lat']!, coordenada['long']!));
      }
    });

    print(puntos);
  }

  @override
  void initState() {
    getLocationPaseador();
    getCurrentUser();
    getLocation();

    if (widget.estado.contains('current')) {
      _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
        getLocationPaseador();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RedireccionAtras(nombre: widget.nombreRedireccion),
            SizedBox(
              height: 200,
              child: _isLocationLoaded
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialCameraPosition,
                        zoom: 17,
                      ),
                      markers: {
                        if (puntos.isNotEmpty)
                          Marker(
                              markerId: const MarkerId('punto'),
                              position: puntos.last,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueCyan,
                              ))
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('ruta'),
                          color: PrincipalColors.orange, // Color de la línea
                          points: puntos,
                        ),
                      },
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nombre: '),
                      const SizedBox(
                        width: 10,
                      ),
                      ClipOval(
                        child: ImageNetworkPropio(
                          imagen: '${widget.mascota.image}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('${widget.mascota.name}'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duración: '),
                      SizedBox(width: 40),
                      Text('Tiempo'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Distancia recorrida: '),
                      SizedBox(width: 40),
                      Text('Km'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dirección de rocojo: '),
                      SizedBox(width: 40),
                      Text('direccion'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
