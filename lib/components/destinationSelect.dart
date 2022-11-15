// ignore_for_file: prefer_const_constructors

import 'package:geocoding/geocoding.dart';
import 'package:louisianatrail/components/map.dart';
import 'package:louisianatrail/services/directions.dart';
import 'package:louisianatrail/variables.dart';
import 'package:flutter/material.dart';

class DestinationSelect extends StatefulWidget {
  const DestinationSelect({Key? key}) : super(key: key);

  @override
  State<DestinationSelect> createState() => _DestinationSelectState();
}

class _DestinationSelectState extends State<DestinationSelect> {
  Placemark? adds;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "destSelect",
      child: Stack(
        children: [
          GPSMap(
              address: address,
              interactive: true,
              onTap: (coordinates) async => {
                    adds = await getLatLngAddress(coordinates),
                    setState(() {}),
                  }),
          if (adds != null)
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(adds!.street!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelLarge!),
                          ElevatedButton(
                              onPressed: () => {
                                    Navigator.of(context).pop(adds),
                                  },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[700],
                                  minimumSize: Size(350, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text('Select Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
