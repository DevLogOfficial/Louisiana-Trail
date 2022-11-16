// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:louisianatrail/components/auto_search.dart';
import 'package:louisianatrail/components/destinationSelect.dart';
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
  String? title, description, location, type;

  final TextEditingController _textEditingController = TextEditingController();
  final MultiSelectController _multiSelectController = MultiSelectController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80, left: 10),
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
                        DropdownButton<String>(
                            value: type,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                type = value!;
                              });
                            },
                            items: types.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key + entry.value,
                                child: Text(entry.key + entry.value),
                              );
                            }).toList()),
                        SizedBox(height: 175),
                        Text("Location",
                            style: Theme.of(context).textTheme.labelLarge),
                        SizedBox(height: 50),
                        TextForm(
                            labelText: "Enter location",
                            onSaved: (value) => {
                                  setState(() {
                                    location = value;
                                  }),
                                }),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DestinationSelect()))
                                .then((results) => setState(() {
                                      _textEditingController.text =
                                          results.street;
                                      location = results.street;
                                    })),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: Hero(
                                    tag: "destSelect",
                                    child: GPSMap(
                                        address: location,
                                        marker: Icon(Icons.pin_drop,
                                            color: Colors.red, size: 30)),
                                  ),
                                ),
                                Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent)),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () => {
                                  trailcollection.doc().set({
                                    'title': title,
                                    'desc': description,
                                    'host': auth.currentUser!.uid,
                                    'address': location,
                                  }),
                                  widget.onSubmit!.call(),
                                },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[700],
                                minimumSize: Size(350, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text('Done',
                                style:
                                    Theme.of(context).textTheme.displayLarge)),
                        SizedBox(height: 50),
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
