// ignore_for_file: prefer_const_constructors

import 'package:louisianatrail/screens/home.dart';
import 'package:louisianatrail/screens/auth.dart';
import 'package:louisianatrail/variables.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool isLoggedIn = false;
  initState() {
    super.initState();
    auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
        });
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: isLoggedIn == true ? HomePage() : AuthPage());
  }
}
