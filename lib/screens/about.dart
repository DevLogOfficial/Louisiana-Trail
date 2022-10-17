// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:louisianatrail/components/multiselect.dart';
import 'package:louisianatrail/components/optionpicker.dart';
import 'package:louisianatrail/variables.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AboutPage extends StatefulWidget {
  final Function? onSubmit;
  const AboutPage({super.key, this.onSubmit});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final OptionPickerController _optionPickerController =
      OptionPickerController();
  final MultiSelectController _multiSelectController = MultiSelectController();

  List selectedTags = [];

  @override
  void initState() {
    super.initState();

    _optionPickerController.addListener(() {
      setState(() {});
    });
    _multiSelectController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Tell us a bit about you..",
                style: Theme.of(context).textTheme.labelLarge),
            SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Interests",
                    style: Theme.of(context).textTheme.labelLarge),
                SizedBox(width: 5),
                Text("(Enter up to 10)",
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            Stack(
              children: [
                Positioned(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 175),
                      Text("Role",
                          style: Theme.of(context).textTheme.labelLarge),
                      OptionPicker(
                        controller: _optionPickerController,
                        options: ["Student", "Professor", "Someone Else"],
                        selectedColors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ],
                      ),
                      SizedBox(height: 20),
                      if (_optionPickerController.selectedIndex == 0 ||
                          _optionPickerController.selectedIndex == 1)
                        Column(
                          children: [
                            Text("Classes",
                                style: Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                      ElevatedButton(
                          onPressed: () => {
                                usercollection
                                    .doc(auth.currentUser!.uid)
                                    .update({
                                  "Role": _optionPickerController.options![
                                      _optionPickerController.selectedIndex],
                                  "Interests": _multiSelectController
                                      .selectedTags!
                                      .toList(),
                                  "completedInfo": true,
                                }),
                                widget.onSubmit!.call(),
                              },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[700],
                              minimumSize: Size(350, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text('Done',
                              style: Theme.of(context).textTheme.displayLarge)),
                    ],
                  ),
                ),
                MultiSelect(
                  controller: _multiSelectController,
                  tags: tags!,
                  hintText: "Select interests",
                  chipColors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    ));
  }
}
