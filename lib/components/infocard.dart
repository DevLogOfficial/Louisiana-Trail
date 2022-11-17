// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:louisianatrail/components/map.dart';
import 'package:louisianatrail/variables.dart';

class InfoCard extends StatefulWidget {
  final String? title;
  final String? desc;
  final String? host;
  final String? tag;
  final String? address;
  const InfoCard(
      {super.key, this.title, this.desc, this.host, this.tag, this.address});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Stack(children: [
          SizedBox(
              width: 103,
              child: GPSMap(
                address: widget.address!,
                marker: CustomPaint(
                  painter:
                      MyPainter(inputText: tags[widget.tag!]!, inputSize: 18),
                ),
              )),
          Container(
              width: 103, decoration: BoxDecoration(color: Colors.transparent)),
        ]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title!,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(tags[widget.tag!]!,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 20)),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.desc!,
                      overflow: TextOverflow.ellipsis, maxLines: 3)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5, right: 8),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "hosted by ${widget.host!}",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(height: 1, color: Colors.grey),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ]),
    );
  }
}
