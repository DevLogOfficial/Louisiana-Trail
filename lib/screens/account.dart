// ignore_for_file: prefer_const_constructors

import 'package:louisianatrail/screens/auth.dart';
import 'package:louisianatrail/screens/navigation.dart';
import 'package:louisianatrail/variables.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Account"),
        ElevatedButton(
            onPressed: () => {
                  auth.signOut(),
                },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                minimumSize: Size(350, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('Logout',
                style: Theme.of(context).textTheme.displayLarge)),
      ],
    )));
  }
}
