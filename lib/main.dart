// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:louisianatrail/screens/base.dart';
import 'package:louisianatrail/screens/augmentedView.dart';
import 'package:louisianatrail/variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          colorScheme: ColorScheme.light(
              primary: Color(0xff4e29aa), secondary: Color(0xff7a34a4)),
          textTheme: TextTheme(
            headlineLarge: fontStyle2(45, Colors.white),
            headlineMedium: fontStyle(15, Colors.black, FontWeight.w600),
            bodyLarge: fontStyle(50, Colors.white),
            labelLarge: fontStyle(30, Colors.black, FontWeight.w700),
            labelMedium: fontStyle(18, Colors.grey, FontWeight.w700),
            labelSmall: fontStyle(18, Colors.purple, FontWeight.w700),
            displayLarge: fontStyle(20, Colors.black, FontWeight.w600),
            displayMedium: fontStyle(18, Colors.purple, FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.black)),
      home: BasePage(),
    );
  }
}
