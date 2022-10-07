// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/parent_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
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
    getArrow();

    // arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    // arObjectManager.onPanStart = onPanStarted;
    // arObjectManager.onPanChange = onPanChanged;
    // arObjectManager.onPanEnd = onPanEnded;
    // arObjectManager.onRotationStart = onRotationStarted;
    // arObjectManager.onRotationChange = onRotationChanged;
    // arObjectManager.onRotationEnd = onRotationEnded;
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
      ),
    );
  }
}
