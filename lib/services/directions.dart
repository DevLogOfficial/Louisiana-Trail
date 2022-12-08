import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:open_route_service/open_route_service.dart';

final Location _locationService = Location();
LocationData? currentLocation;
bool permissionGranted = false;

String? _serviceError = '';

initLocationService() async {
  LocationData? location;
  bool serviceEnabled;
  bool serviceRequestResult;

  try {
    serviceEnabled = await _locationService.serviceEnabled();

    if (serviceEnabled) {
      final permission = await _locationService.requestPermission();
      permissionGranted = permission == PermissionStatus.granted;

      if (permissionGranted) {
        location = await _locationService.getLocation();
        currentLocation = location;
        _locationService.onLocationChanged.listen((LocationData result) async {
          currentLocation = result;
        });
        return true;
      }
    } else {
      serviceRequestResult = await _locationService.requestService();
      if (serviceRequestResult) {
        initLocationService();
        return;
      }
    }
  } on PlatformException catch (e) {
    debugPrint(e.toString());
    if (e.code == 'PERMISSION_DENIED') {
      _serviceError = e.message;
    } else if (e.code == 'SERVICE_STATUS_ERROR') {
      _serviceError = e.message;
    }
    location = null;
  }
}

getAddressLatLng(address) async {
  List<geo.Location> addresses = await geo.locationFromAddress(address);
  geo.Location first = addresses.first;
  return LatLng(first.latitude, first.longitude);
}

getLatLngAddress(coordinates) async {
  var addresses = await geo.placemarkFromCoordinates(
      coordinates.latitude!, coordinates.longitude!);
  var first = addresses.first;
  return first;
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
