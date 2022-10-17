// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:louisianatrail/components/auto_search.dart';
import 'package:louisianatrail/components/map.dart';
import 'package:louisianatrail/components/multiselect.dart';
import 'package:louisianatrail/components/optionpicker.dart';
import 'package:louisianatrail/components/textForm.dart';
import 'package:louisianatrail/variables.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateEventPage extends StatefulWidget {
  final Function? onSubmit;
  const CreateEventPage({super.key, this.onSubmit});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  String? title, description, location;

  final TextEditingController _textEditingController = TextEditingController();
  final MultiSelectController _multiSelectController = MultiSelectController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Create Event",
                  style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: 20),
              Text("Event Title",
                  style: Theme.of(context).textTheme.displayLarge),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextForm(
                    labelText: "Your Event Title",
                    onSaved: (value) => {
                          setState(() {
                            title = value;
                          }),
                        }),
              ),
              Text("Description",
                  style: Theme.of(context).textTheme.displayLarge),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextForm(
                    labelText: "Something about your event...",
                    maxLines: 5,
                    maxLength: 150,
                    onSaved: (value) => {
                          setState(() {
                            title = value;
                          }),
                        }),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Tags", style: Theme.of(context).textTheme.displayLarge),
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
                        Text("Location",
                            style: Theme.of(context).textTheme.labelLarge),
                        Stack(
                          children: [
                            Positioned(
                              child: Column(
                                children: [
                                  SizedBox(height: 50),
                                  SizedBox(
                                    height: 150,
                                    child: GPSMap(
                                        address:
                                            "310 LSU Student Union, Baton Rouge, LA 70803"),
                                  ),
                                  ElevatedButton(
                                      onPressed: () => {
                                            usercollection
                                                .doc(auth.currentUser!.uid)
                                                .update({}),
                                            widget.onSubmit!.call(),
                                          },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purple[700],
                                          minimumSize: Size(350, 50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      child: Text('Done',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge)),
                                  SizedBox(height: 50),
                                ],
                              ),
                            ),
                            AutoSearchInput(
                                controller: _textEditingController,
                                data: addresses!,
                                hintText: "Current Location",
                                maxElementsToDisplay: 5,
                                onItemTap: (index) => {
                                      _textEditingController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                          offset: _textEditingController
                                              .text.length,
                                        ),
                                      )
                                    }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MultiSelect(
                      controller: _multiSelectController,
                      tags: tags,
                      hintText: "Select tags",
                      chipColors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary
                      ])
                ],
              ),
            ]),
          ),
        ));
  }
}
