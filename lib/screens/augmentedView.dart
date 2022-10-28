// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math' as math;

import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/anchor_types.dart';
import 'package:ar_flutter_plugin/datatypes/config_geospatialmode.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/parent_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:louisianatrail/services/directions.dart';
import 'package:louisianatrail/variables.dart';
import 'package:vector_math/vector_math_64.dart';

class ARPage extends StatefulWidget {
  const ARPage({super.key});

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  ARSessionManager? _arSessionManager;
  ARObjectManager? _arObjectManager;
  ARAnchorManager? _arAnchorManager;
  ARLocationManager? _arLocationManager;

  ARNode? _arrowNode;

  final Location _locationService = Location();
  bool _permission = false;

  var _currentLocation;
  LatLng? _destination;
  List<LatLng>? _routePoints;

  @override
  void dispose() {
    super.dispose();
    _arSessionManager!.dispose();
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    _arSessionManager = arSessionManager;
    _arObjectManager = arObjectManager;
    _arLocationManager = arLocationManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      customPlaneTexturePath: "Images/triangle.png",
      handleTaps: false,
    );
    arObjectManager.onInitialize();
    if (address.isNotEmpty) {
      startTracking();
    }

    // arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    // arObjectManager.onPanStart = onPanStarted;
    // arObjectManager.onPanChange = onPanChanged;
    // arObjectManager.onPanEnd = onPanEnded;
    // arObjectManager.onRotationStart = onRotationStarted;
    // arObjectManager.onRotationChange = onRotationChanged;
    // arObjectManager.onRotationEnd = onRotationEnded;
  }

  Future<void> calculateDirection() async {
    _destination = await getAddressLatLng(address);
    _routePoints = await retrieveRoute(_currentLocation, _destination);
    print("HERE GET MY ARROW");
    getArrow();
  }

  getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  deg2rad(deg) {
    return deg * (math.pi / 180);
  }

  calculateRotation(pointLocation) {
    // double distance1 = math.sqrt(
    //     (math.pow(pointLocation.longitude - _currentLocation.longitude, 2)) +
    //         (math.pow(pointLocation.latitude - _currentLocation.latitude, 2)));
    // double distance2 = pointLocation.latitude - _currentLocation.latitude;

    // double rotationInDegrees = math.atan(distance2 / distance1);
    // print("DEGREES: $rotationInDegrees");
    // double rotationInRadians = rotationInDegrees * (math.pi / 180);

    double rotationinKm = getDistanceFromLatLonInKm(
        _currentLocation.latitude,
        _currentLocation.longitude,
        pointLocation.latitude,
        pointLocation.longitude);
    print("KM: $rotationinKm");
    print("CURRENTLOCATION:" +
        _currentLocation.toString() +
        ":" +
        pointLocation.toString());
    print("ROUTEPOINT:" + _routePoints.toString());
    double rotationInRadians = rotationinKm / 6371;
    return rotationInRadians;
  }

  Future<void> startTracking() async {
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
          _currentLocation = location;
          calculateDirection();
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                if (_arrowNode != null) {
                  double rotation = calculateRotation(_routePoints![1]);
                  Matrix3 matrix = Matrix3.zero();
                  print("ROTATION:" + rotation.toString());
                  matrix.setRotationY(rotation);
                  _arrowNode!.transform = Matrix4.compose(Vector3(0, -1, -3),
                      Quaternion.fromRotation(matrix), Vector3(0.2, 0.2, 0.2));
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          startTracking();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        //_serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        //_serviceError = e.message;
      }
      location = null;
    }
  }

  Future<void> getArrow() async {
    var newNode = ARNode(
      channel: _arObjectManager!.channel,
      type: NodeType.localGLTF2,
      uri: "assets/models/arrow/scene.gltf",
      scale: Vector3(0.2, 0.2, 0.2),
    );
    bool? didAddLocalNode = await _arObjectManager!.addNode(newNode);
    _arrowNode = (didAddLocalNode != null) ? newNode : null;
    _arrowNode!.setParent(ParentType.camera);
    _arrowNode!.position = Vector3(0, -1, -3);
  }

  Future<void> setAnchorAtPlace(coordinates) async {}

  getCameraPos() async {
    Matrix4? matr = await _arSessionManager!.getCameraPose();
    return matr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        geospatialModeConfig: GeospatialModeConfig.disabled,
      ),
    );
  }
}
