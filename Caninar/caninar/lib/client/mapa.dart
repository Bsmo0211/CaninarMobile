import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class Mapa {
  Future<LatLng> getLocation() async {
    Location location = Location();

    try {
      LocationData currentLocation = await location.getLocation();
      return LatLng(currentLocation.latitude!, currentLocation.longitude!);
    } catch (e) {
      print('Error obteniendo la ubicación: $e');
      return const LatLng(0, 0);
    }
  }
}
