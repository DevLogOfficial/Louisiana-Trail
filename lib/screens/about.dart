// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:louisianatrail/components/optionpicker.dart';
import 'package:louisianatrail/variables.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final OptionPickerController _controller = OptionPickerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Tell us a bit about you..",
              style: Theme.of(context).textTheme.labelLarge),
          SizedBox(height: 50),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Interests", style: Theme.of(context).textTheme.labelLarge),
              SizedBox(width: 5),
              Text("(Enter up to 10)",
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          SizedBox(height: 50),
          Text("Role", style: Theme.of(context).textTheme.labelLarge),
          OptionPicker(
            controller: _controller,
            options: ["Student", "Professor", "Someone Else"],
            selectedColors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () => {
                    usercollection.doc(auth.currentUser!.uid).update({
                      "Role": _controller.options![_controller.selectedIndex]
                    })
                  },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  minimumSize: Size(350, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text('Done',
                  style: Theme.of(context).textTheme.displayLarge)),
        ]),
      ),
    ));
  }
}
