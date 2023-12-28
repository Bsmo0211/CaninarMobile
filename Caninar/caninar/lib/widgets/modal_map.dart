import 'package:caninar/client/mapa.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class ModalMap extends StatefulWidget {
  LatLng? initialCenter;
  ModalMap({Key? key, this.initialCenter}) : super(key: key);

  @override
  _ModalMapState createState() => _ModalMapState();
}

class _ModalMapState extends State<ModalMap> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FlutterMap(
                  options: MapOptions(
                    onTap: (tapPosition, point) {},
                    initialCenter: widget.initialCenter ??
                        const LatLng(4.747457, -122.4194),
                    initialZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(12),
                  ),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(PrincipalColors.blue),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
