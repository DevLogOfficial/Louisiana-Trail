import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:open_route_service/open_route_service.dart';

getAddressLatLng(address) async {
  List<geo.Location> addresses = await geo.locationFromAddress(address);
  geo.Location first = addresses.first;
  return LatLng(first.latitude, first.longitude);
}

retrieveRoute(currentLocation, destination) async {
  final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248a23c02f542074e98a19f226352abe372');
  List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
    startCoordinate: ORSCoordinate(
        latitude: currentLocation!.latitude!,
        longitude: currentLocation!.longitude!),
    endCoordinate: ORSCoordinate(
        latitude: destination!.latitude, longitude: destination!.longitude),
  );
  return routeCoordinates
      .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
      .toList();
}
