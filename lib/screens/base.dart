// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louisianatrail/screens/about.dart';
import 'package:louisianatrail/screens/auth.dart';
import 'package:louisianatrail/screens/navigation.dart';
import 'package:louisianatrail/variables.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool isLoggedIn = false;
  bool completedInfo = false;

  @override
  initState() {
    super.initState();
    auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
          usercollection.doc(auth.currentUser!.uid).get().then((value) => {
                setState(() {
                  completedInfo = value["completedInfo"];
                }),
              });
        });
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    });
  }

  updateCompletedInfo() {
    setState(() {
      completedInfo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn
          ? FutureBuilder(
              future: usercollection.doc(auth.currentUser!.uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return data['completedInfo']
                      ? NavigationPage()
                      : AboutPage(onSubmit: updateCompletedInfo);
                }

                return CircularProgressIndicator();
              },
            )
          : AuthPage(),
    );
  }
}
