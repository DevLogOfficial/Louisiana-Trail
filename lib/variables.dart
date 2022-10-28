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
String address = "";
//Navigation

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
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(size.width * 0.01, size.height - 60,
        size.width * 0.25, size.height - 60);
    path.lineTo(size.width - 50, size.height - 60);
    path.quadraticBezierTo(size.width + 50, size.height - 60, size.width, 0.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 15.0;
    final Path path = Path();
    path.lineTo(0, size.height - roundnessFactor);
    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    path.lineTo(size.width - roundnessFactor, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width,
        size.height - roundnessFactor); //rightBottomCorner
    path.lineTo(size.width, roundnessFactor);
    path.quadraticBezierTo(
        size.width, 0, size.width - roundnessFactor, 0); // rightTopCorner
    path.lineTo(roundnessFactor, 0);
    path.quadraticBezierTo(0, 0, 0, roundnessFactor);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomDiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 15.0;
    final Path path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height / 2); //right corner
    path.lineTo(size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomCardClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 30.0;
    final Path path = Path();
    path.lineTo(0, size.height - roundnessFactor);
    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    path.lineTo(size.width - roundnessFactor, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width,
        size.height - roundnessFactor); //rightBottomCorner
    path.lineTo(size.width, roundnessFactor + 30);
    path.quadraticBezierTo(
        size.width, 30, size.width - roundnessFactor, 20); // rightTopCorner
    path.quadraticBezierTo(
        size.width / 1.3, 0, size.width / 1.4 - roundnessFactor, 0);
    path.lineTo(5, 0);
    path.quadraticBezierTo(0, 0, 0, 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ClipShadowPath({
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
//Clipping
