// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:louisianatrail/components/map.dart';

class MapCard extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? host;
  final String? address;
  const MapCard({super.key, this.title, this.desc, this.host, this.address});

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xfff3f3f3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: 200,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title!,
                          style: Theme.of(context).textTheme.displayLarge),
                      Text("hosted by ${widget.host!}"),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Column(
                    children: [
                      Text(widget.desc!, maxLines: 4),
                      SizedBox(height: 5),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("View Details >>",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.blue))),
                    ],
                  )),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}
