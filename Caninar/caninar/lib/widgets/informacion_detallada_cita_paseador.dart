import 'dart:async';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:caninar/widgets/paseo_terminado.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class InformacionDetalladaCitaPaseador extends StatefulWidget {
  String nombreRedireccion;
  MascotasModel mascota;
  String idSchedule;
  InformacionDetalladaCitaPaseador({
    super.key,
    required this.nombreRedireccion,
    required this.mascota,
    required this.idSchedule,
  });

  @override
  State<InformacionDetalladaCitaPaseador> createState() =>
      _InformacionDetalladaCitaPaseadorState();
}

class _InformacionDetalladaCitaPaseadorState
    extends State<InformacionDetalladaCitaPaseador> {
  GoogleMapController? _mapController;
  final Location _location = Location();
  LatLng _initialCameraPosition = const LatLng(0.0, 0.0);
  LatLng _cameraPositionInicio = const LatLng(0.0, 0.0);
  LatLng _cameraPosition = const LatLng(0.0, 0.0);
  bool _isLocationLoaded = false;
  UserLoginModel? user;
  bool paseoIniciado = false;
  List<Map<String, double>> ubicaciones = [];
  List<Map<String, String>> arrayEnvio = [];
  List<LatLng> polilineaPoints = [];
  Timer? _locationTimer;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  Future<void> getLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      setState(() {
        _initialCameraPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
        _isLocationLoaded = true;
      });
    } catch (error) {
      print('Error getting location: $error');
    }
  }

  Future<void> getLocationTimer() async {
    try {
      LocationData locationData = await _location.getLocation();
      setState(() {
        _cameraPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
        ubicaciones.add(
            {'lat': locationData.latitude!, 'long': locationData.longitude!});
        arrayEnvio.add({
          'lat': '${locationData.latitude!}',
          'long': '${locationData.longitude!}'
        });
        polilineaPoints.add(_cameraPosition);
      });
      await API().updatePointById(arrayEnvio, widget.idSchedule);
    } catch (error) {
      print('Error getting location: $error');
    }
  }

  Future<void> getLocationRecogida() async {
    try {
      LocationData locationData = await _location.getLocation();
      setState(() {
        _cameraPositionInicio =
            LatLng(locationData.latitude!, locationData.longitude!);
        ubicaciones.add(
            {'lat': locationData.latitude!, 'long': locationData.longitude!});
        arrayEnvio.add({
          'lat': '${locationData.latitude!}',
          'long': '${locationData.longitude!}'
        });
      });

      await API()
          .updateFirstPointById(arrayEnvio, widget.idSchedule, 'current');
    } catch (error) {
      print('Error getting location: $error');
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.idSchedule);
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RedireccionAtras(
              nombre: 'Paseo de ${widget.nombreRedireccion}',
            ),
            SizedBox(
              height: 200,
              child: _isLocationLoaded
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialCameraPosition,
                        zoom: 17,
                      ),
                      markers: {
                        Marker(
                            markerId: const MarkerId('Punto incial'),
                            position: _cameraPositionInicio,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueCyan,
                            ))
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('ruta'),
                          color: PrincipalColors.orange, // Color de la línea
                          points: polilineaPoints,
                        ),
                      },
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
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
            if (user?.type == 2)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: BotonCustom(
                  funcion: () async {
                    if (!paseoIniciado) {
                      await getLocationRecogida();
                      _locationTimer = Timer.periodic(
                          const Duration(seconds: 30), (timer) async {
                        await getLocationTimer();
                      });

                      setState(() {
                        paseoIniciado = true;
                      });
                    } else {
                      _locationTimer?.cancel();
                      await API().updateFirstPointById(
                          arrayEnvio, widget.idSchedule, 'terminated');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaseoTerminado(),
                        ),
                      );
                      setState(() {
                        paseoIniciado = false;
                      });
                    }
                  },
                  texto: paseoIniciado ? 'Finalizar Paseo' : 'Iniciar Paseo',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
