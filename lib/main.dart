// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:louisianatrail/screens/base.dart';
import 'package:louisianatrail/screens/home.dart';
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
              primary: Color(0xff3d196c), secondary: Color(0xff3d196d)),
          textTheme: TextTheme(
            headlineLarge: fontStyle(45, Colors.white),
            bodyLarge: fontStyle(50, Colors.white),
            labelLarge: fontStyle(18, Colors.grey),
            labelMedium: fontStyle(15, Colors.blue, FontWeight.w700),
            labelSmall: fontStyle(15, Colors.black),
            displayLarge: fontStyle(18, Colors.purple),
            displayMedium: fontStyle(15, Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black)),
      home: BasePage(),
    );
  }
}
