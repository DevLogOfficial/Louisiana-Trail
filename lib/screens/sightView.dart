// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:floating_pullup_card/floating_pullup_card.dart';
import 'package:flutter/material.dart';
import 'package:louisianatrail/screens/augmentedView.dart';
import 'package:louisianatrail/screens/mapView.dart';

class SightPage extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? host;
  final String? address;
  final String? tag;
  const SightPage(
      {Key? key, this.title, this.desc, this.host, this.address, this.tag})
      : super(key: key);

  @override
  State<SightPage> createState() => _MapState();
}

class _MapState extends State<SightPage> {
  bool active = false;

  var map;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    map = MapPage(
        title: widget.title,
        desc: widget.desc,
        host: widget.host,
        address: widget.address,
        tag: widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FloatingPullUpCardLayout(
      dismissable: false,
      state: FloatingPullUpState.collapsed,
      dragHandleBuilder: null,
      cardBuilder: null,
      collpsedStateOffset: null,
      uncollpsedStateOffset: null,
      autoPadding: true,
      withOverlay: true,
      body: map,
      child: ARPage(
          title: widget.title,
          desc: widget.desc,
          host: widget.host,
          address: widget.address,
          tag: widget.tag),
    ));
  }
}
