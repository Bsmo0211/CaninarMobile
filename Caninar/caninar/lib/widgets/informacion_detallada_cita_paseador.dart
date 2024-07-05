import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InformacionDetalladaCitaPaseador extends StatefulWidget {
  String nombreRedireccion;
  MascotasModel mascota;
  String idSchedule;
  String direccion;
  bool estado;
  String formatoHora;

  InformacionDetalladaCitaPaseador(
      {super.key,
      required this.nombreRedireccion,
      required this.mascota,
      required this.idSchedule,
      required this.direccion,
      required this.estado,
      required this.formatoHora});

  @override
  State<InformacionDetalladaCitaPaseador> createState() =>
      _InformacionDetalladaCitaPaseadorState();
}

class _InformacionDetalladaCitaPaseadorState
    extends State<InformacionDetalladaCitaPaseador> {
  GoogleMapController? _mapController;

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
  int _start = 0;
  Timer? _timer;
  String tiempoFormateado = '00:00:00';

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
      updateFormattedTime(_start);
    });
  }

  stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  String formattedTime(int seconds) {
    String hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    String minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$secondsStr';
  }

  updateFormattedTime(int seconds) {
    setState(() {
      tiempoFormateado = formattedTime(seconds);
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    stopTimer();
    super.dispose();
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
      polilineaPoints.clear();
      for (var coordenada in coordenadasDouble) {
        polilineaPoints.add(LatLng(coordenada['lat']!, coordenada['long']!));
      }
    });
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

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

  Future<void> getLocationTimer() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _cameraPosition = LatLng(position.latitude, position.longitude);
        ubicaciones.add({'lat': position.latitude, 'long': position.longitude});
        arrayEnvio.add(
            {'lat': '${position.latitude}', 'long': '${position.longitude}'});
        polilineaPoints.add(_cameraPosition);
      });
      await API().updatePointById(arrayEnvio, widget.idSchedule);
    } catch (error) {
      print('Error getting location: $error');
    }
  }

  Future<void> getLocationRecogida() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _cameraPositionInicio = LatLng(
          position.latitude,
          position.longitude,
        );
        ubicaciones.add({
          'lat': position.latitude,
          'long': position.longitude,
        });
        arrayEnvio.add(
            {'lat': '${position.latitude}', 'long': '${position.longitude}'});
      });

      await API().updateFirstPointById(
          arrayEnvio, widget.idSchedule, 'current', tiempoFormateado);
    } catch (error) {
      print('Error getting location: $error');
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getLocation();
    if (widget.estado == true) {
      getLocationPaseador();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              height: 370,
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
                            )),
                        if (polilineaPoints.isNotEmpty)
                          Marker(
                              markerId: const MarkerId('Punto incial'),
                              position: polilineaPoints.last,
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
            Expanded(
              child: Center(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: Icon(Icons.access_time,
                                color: PrincipalColors.orange),
                          ),
                          const Text('Duración: '),
                          Expanded(
                            child: Text(
                              widget.estado == true
                                  ? widget.formatoHora
                                  : tiempoFormateado,
                              overflow: TextOverflow
                                  .ellipsis, // Opcional: añade esto para manejar textos muy largos
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: Icon(Icons.home_filled,
                                color: PrincipalColors.orange),
                          ),
                          const Text('Dirección de rocojo: '),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Text(
                              widget.direccion,
                              overflow: TextOverflow
                                  .ellipsis, // Opcional: añade esto para manejar textos muy largos
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: Icon(
                              Icons.pets_outlined,
                              color: PrincipalColors.orange,
                            ),
                          ),
                          const Text('Nombre: '),
                          const SizedBox(width: 10),
                          ClipOval(
                            child: ImageNetworkPropio(
                              imagen: '${widget.mascota.image}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${widget.mascota.name}',
                              overflow: TextOverflow
                                  .ellipsis, // Opcional: añade esto para manejar textos muy largos
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (user?.type == 2 && widget.estado == false)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: BotonCustom(
                          funcion: () async {
                            if (!paseoIniciado) {
                              await getLocationRecogida();
                              _locationTimer = Timer.periodic(
                                  const Duration(seconds: 15), (timer) async {
                                await getLocationTimer();
                              });
                              startTimer();
                              setState(() {
                                paseoIniciado = true;
                              });
                            } else {
                              _locationTimer?.cancel();
                              stopTimer();
                              print(tiempoFormateado);
                              await API().updateFirstPointById(
                                  arrayEnvio,
                                  widget.idSchedule,
                                  'terminated',
                                  tiempoFormateado);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaseoTerminado(),
                                ),
                              );
                              setState(() {
                                paseoIniciado = false;
                              });
                            }
                          },
                          texto: paseoIniciado
                              ? 'Finalizar Paseo'
                              : 'Iniciar Paseo',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
