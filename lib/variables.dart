import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

fontStyle(double size,
    [Color? color, FontWeight fw = FontWeight.w500, double spacing = -1]) {
  return GoogleFonts.inter(
      fontSize: size, color: color, fontWeight: fw, letterSpacing: spacing);
}

fontStyle2(double size,
    [Color? color, FontWeight fw = FontWeight.w500, double spacing = 1]) {
  return GoogleFonts.lobster(
      fontSize: size, color: color, fontWeight: fw, letterSpacing: spacing);
}

//Firebase
var auth = FirebaseAuth.instance;
DatabaseReference database = FirebaseDatabase.instance.ref();
var usercollection = FirebaseFirestore.instance.collection('users');
var trailcollection = FirebaseFirestore.instance.collection('trails');
//Firebase

//Navigation
int page = 0;
String address = "310 LSU Student Union, Baton Rouge, LA 70803";
Map<String, String> marker = {};
//Navigation

//Types
final Map<String, String> types = {"Study": "🎓", "Lunch": "😋", "Club": "🐵"};
//Types

//Addresses
List<String>? addresses = [
  'Music',
  'Games',
  'Youtube',
  'Sports',
  'LSU',
  'Books',
  'Study',
  'Food',
  'Fraternity',
  'Sorority',
  'Entertainment',
];
//Addresses

//Tags
List<String>? tags = [
  'Music',
  'Games',
  'Youtube',
  'Sports',
  'LSU',
  'Books',
  'Study',
  'Food',
  'Fraternity',
  'Sorority',
  'Entertainment',
];
//Tags

//Clipping
class MyPainter extends CustomPainter {
  MyPainter({this.inputText, this.inputSize});
  final String? inputText;
  final double? inputSize;

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: this.inputSize,
    );
    final textSpan = TextSpan(
      text: inputText,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
//Clipping
