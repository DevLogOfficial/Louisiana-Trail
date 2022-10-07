// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:louisianatrail/components/map.dart';

class InfoCard extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? creator;
  final String? address;
  const InfoCard(
      {super.key, this.title, this.desc, this.creator, this.address});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(children: [
        GPSMap(address: ""),
        Column(children: [
          Text(widget.title!, style: Theme.of(context).textTheme.labelLarge),
          Text(widget.desc!),
          Text(widget.creator!)
        ])
      ]),
    );
  }
}
