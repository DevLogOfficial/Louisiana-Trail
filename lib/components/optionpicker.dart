// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class OptionPicker extends StatefulWidget {
  final OptionPickerController? controller;
  final List<String>? options;
  final List<Color> selectedColors;
  final List<Color> unselectedColors;
  const OptionPicker({
    super.key,
    required this.controller,
    required this.selectedColors,
    this.options,
    this.unselectedColors = const [Colors.white, Colors.white],
  });

  @override
  State<OptionPicker> createState() => _OptionPickerState();
}

class _OptionPickerState extends State<OptionPicker> {
  @override
  void initState() {
    super.initState();
    widget.controller!.setOptions(widget.options);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
            children: widget.options!
                .asMap()
                .entries
                .map((entry) => InkWell(
                    onTap: () => {
                          setState(() {
                            widget.controller!.selectedIndex = entry.key;
                            widget.controller!.notify();
                          })
                        },
                    child: Container(
                        height: 60,
                        width: 350,
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        padding: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: widget.controller!.selectedIndex ==
                                        entry.key
                                    ? widget.selectedColors
                                    : widget.unselectedColors),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8)),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(entry.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color:
                                            widget.controller!.selectedIndex ==
                                                    entry.key
                                                ? Colors.white
                                                : Colors.black))))))
                .toList()));
  }
}

class OptionPickerController extends ChangeNotifier {
  List<String>? options;
  int selectedIndex = -1;

  void notify() {
    notifyListeners();
  }

  void setOptions(List<String>? list) {
    options = list;
  }
}
