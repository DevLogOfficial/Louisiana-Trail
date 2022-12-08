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
  late final MapController _mapController;

  LatLng? _loc;
  LatLng? _destination;
  List<LatLng>? _routePoints;

  Widget? pin;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initializeLocationService();
  }

  initializeLocationService() async {
    if (!permissionGranted) {
      await initLocationService();
    }
    _loc = await getAddressLatLng(widget.address!);
    initMap();
  }

  void initMap() async {
    if (permissionGranted) {
      if (widget.address != null) {
        if (mounted) {
          if (_loc != null) {
            setState(() {
              _destination = _loc;
            });
          } else {
            initializeLocationService();
          }
        }
      }
      _mapController.move(_destination!, _mapController.zoom);
    }
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
            (currentLocation != null
                ? LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!)
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
                  (currentLocation != null
                      ? LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!)
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
