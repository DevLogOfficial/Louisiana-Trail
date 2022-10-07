// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Text("What's new on the trail",
                  style: Theme.of(context).textTheme.labelLarge),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(bottom: 5, right: 20),
                padding: EdgeInsets.all(3),
                child: Row(
                  children: [
                    Icon(MdiIcons.filter),
                    Text("Classes",
                        style: Theme.of(context).textTheme.headlineMedium),
                    Icon(MdiIcons.chevronDown),
                  ],
                )),
          ],
        ),
      ],
    )));
  }
}
