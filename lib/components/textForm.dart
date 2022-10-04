// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TextForm extends StatefulWidget {
  final String? labelText;
  final IconData? prefixIcon;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  bool obscureText;
  TextForm({
    Key? key,
    this.labelText,
    this.prefixIcon,
    required this.onSaved,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  TextFormState createState() => TextFormState();
}

class TextFormState extends State<TextForm> {
  final FocusNode _focusNode = FocusNode();
  bool styleOn = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        styleOn = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.displayMedium,
      decoration: InputDecoration(
        labelText: widget.labelText,
        contentPadding: EdgeInsets.all(1),
        prefixIcon:
            Icon(widget.prefixIcon, color: Theme.of(context).iconTheme.color),
        labelStyle: styleOn
            ? Theme.of(context).textTheme.displayLarge
            : Theme.of(context).textTheme.labelLarge,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 3.0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).iconTheme.color!, width: 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      obscureText: widget.obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
      focusNode: _focusNode,
    );
  }
}
