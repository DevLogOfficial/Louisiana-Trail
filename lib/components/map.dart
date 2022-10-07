// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:open_route_service/open_route_service.dart';

class GPSMap extends StatefulWidget {
  final String? address;
  const GPSMap({Key? key, this.address}) : super(key: key);

  @override
  State<GPSMap> createState() => _GPSMapState();
}

class _GPSMapState extends State<GPSMap> {
  LocationData? _currentLocation;
  late final MapController _mapController;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  int interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();

  LatLng? _destination;

  List<LatLng>? _routePoints;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();
  }

  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _destination = await getAddressLatLng();
          _currentLocation = location;
          _routePoints = await retrieveRoute();
          initMap();
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                }
              });
            }
          });
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

  getAddressLatLng() async {
    List<geo.Location> addresses =
        await geo.locationFromAddress(widget.address!);
    geo.Location first = addresses.first;
    return LatLng(first.latitude, first.longitude);
  }

  void initMap() {
    _mapController.move(_destination!, _mapController.zoom);
  }

  retrieveRoute() async {
    final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf6248a23c02f542074e98a19f226352abe372');
    List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: _currentLocation!.latitude!,
          longitude: _currentLocation!.longitude!),
      endCoordinate: ORSCoordinate(
          latitude: _destination!.latitude, longitude: _destination!.longitude),
    );
    return routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _destination ?? LatLng(0, 0),
            // center: LatLng(47.925812, 106.919831),
            zoom: 15.0,
            interactiveFlags: InteractiveFlag.none,
          ),
          children: [
            TileLayer(
              urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
            ),
            MarkerLayer(markers: [
              Marker(
                width: 150,
                height: 150,
                point: _destination ?? LatLng(0, 0),
                builder: (ctx) => const Icon(
                  Icons.pin_drop,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ]),
            if (_routePoints != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints!,
                    color: Colors.blue,
                    strokeWidth: 4,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
