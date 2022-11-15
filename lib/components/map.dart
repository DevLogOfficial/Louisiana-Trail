// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:louisianatrail/services/directions.dart';

class GPSMap extends StatefulWidget {
  final String? address;
  final bool? interactive;
  final Widget? marker;
  final Function? onTap;
  const GPSMap(
      {Key? key, this.address, this.interactive, this.marker, this.onTap})
      : super(key: key);

  @override
  State<GPSMap> createState() => _GPSMapState();
}

class _GPSMapState extends State<GPSMap> {
  LocationData? _currentLocation;
  late final MapController _mapController;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  final Location _locationService = Location();

  LatLng? _destination;
  List<LatLng>? _routePoints;

  Widget? pin;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();
  }

  void initLocationService() async {
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
          if (widget.address != null) {
            _destination = await getAddressLatLng(widget.address!);
          }
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              initMap();
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

  void initMap() {
    _mapController.move(_destination!, _mapController.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        onTap: (pos, coordinates) => widget.onTap != null
            ? {
                widget.onTap!.call(coordinates),
                setState(() {
                  _destination = coordinates;
                  pin = Icon(Icons.pin_drop, color: Colors.red, size: 30);
                }),
              }
            : {},
        center: _destination ??
            (_currentLocation != null
                ? LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!)
                : LatLng(0, 0)),
        interactiveFlags: widget.interactive == true
            ? InteractiveFlag.all
            : InteractiveFlag.none,
        zoom: 15,
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
              point: _destination ??
                  (_currentLocation != null
                      ? LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!)
                      : LatLng(0, 0)),
              builder: (ctx) =>
                  widget.marker != null ? widget.marker! : pin ?? SizedBox()),
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
    );
  }
}
