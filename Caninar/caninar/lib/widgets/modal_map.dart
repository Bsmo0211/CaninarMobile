/* import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'
    as geocoding; // Alias para 'geocoding'
import 'package:location/location.dart' as location; // Alias para 'location'

class ModalMap extends StatefulWidget {
  LatLng? initialCenter;
  Function stringImage;
  ModalMap({Key? key, this.initialCenter, required this.stringImage})
      : super(key: key);

  @override
  _ModalMapState createState() => _ModalMapState();
}

class _ModalMapState extends State<ModalMap> {
  late MapController mapController;
  TextEditingController addressController = TextEditingController();
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Buscar dirección',
                hintText: 'Ingresa una dirección',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: PrincipalColors.blue),
                  onPressed: () async {
                    List<geocoding.Location> locations = await geocoding
                        .locationFromAddress(addressController.text);
                    if (locations.isNotEmpty) {
                      mapController.move(
                        LatLng(locations.first.latitude,
                            locations.first.longitude),
                        18.0,
                      );
                      setState(() {
                        selectedLocation = LatLng(locations.first.latitude,
                            locations.first.longitude);
                      });
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: PrincipalColors.blue),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onTap: (tapPosition, point) {
                    setState(() {
                      selectedLocation = point;
                    });
                  },
                  initialCenter:
                      widget.initialCenter ?? const LatLng(4.747457, -122.4194),
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  if (selectedLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                            width: 40.0,
                            height: 40.0,
                            point: selectedLocation!,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 35,
                            )),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
            child: TextButton(
              onPressed: () async {
                await widget.stringImage(addressController.text);
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
      ),
    );
  }
}
 */