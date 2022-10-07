// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:louisianatrail/screens/account.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:louisianatrail/screens/home.dart';
import 'package:louisianatrail/screens/augmentedView.dart';
import 'package:louisianatrail/variables.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List pageOptions = [
    HomePage(),
    AccountPage(),
    ARPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOptions[page],
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          child: Icon(MdiIcons.cameraIris,
              size: 60, color: page == 2 ? Colors.white : Colors.black),
          onPressed: () => {
            setState(() {
              page = 2;
            }),
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: Colors.purple[800],
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                      icon: Icon(MdiIcons.home,
                          size: 40,
                          color: page == 0 ? Colors.white : Colors.black),
                      onPressed: () {
                        setState(() {
                          page = 0;
                        });
                      }),
                ),
                SizedBox(width: 40), // The dummy child
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      icon: Icon(MdiIcons.account,
                          size: 40,
                          color: page == 1 ? Colors.white : Colors.black),
                      onPressed: () {
                        setState(() {
                          page = 1;
                        });
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
