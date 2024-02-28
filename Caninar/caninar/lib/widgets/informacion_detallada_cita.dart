import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class InformacionDetalladaCita extends StatefulWidget {
  String nombreMarca;
  String petId;
  InformacionDetalladaCita({
    super.key,
    required this.nombreMarca,
    required this.petId,
  });

  @override
  State<InformacionDetalladaCita> createState() =>
      _InformacionDetalladaCitaState();
}

class _InformacionDetalladaCitaState extends State<InformacionDetalladaCita> {
  GoogleMapController? _mapController;
  final Location _location = Location();
  LatLng _initialCameraPosition = const LatLng(0.0, 0.0);
  bool _isLocationLoaded = false;
  MascotasModel? mascota;

  getInformacionById() async {
    MascotasModel mascotaTemp = await API().getPetById(widget.petId);
    setState(() {
      mascota = mascotaTemp;
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

  @override
  void initState() {
    getInformacionById();
    getLocation();
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
            RedireccionAtras(nombre: widget.nombreMarca),
            SizedBox(
              height: 200,
              child: _isLocationLoaded
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialCameraPosition,
                        zoom: 17,
                      ),
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
                          imagen: '${mascota?.image}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('${mascota?.name}'),
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
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Text(
                                  'Cant.',
                                  style: TextStyle(
                                    color: PrincipalColors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 5,
                                  bottom: 20,
                                ),
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 10,
                                ),
                                child: Text(
                                  'Producto.',
                                  style: TextStyle(
                                    color: PrincipalColors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 5,
                                  bottom: 20,
                                ),
                                child: Text(
                                  'producto',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Precio S/',
                                  style: TextStyle(
                                    color: PrincipalColors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 20),
                                child: Text(
                                  'precio',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
