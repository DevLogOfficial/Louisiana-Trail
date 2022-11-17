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
  String? title, description, location, tag;

  final TextEditingController _textEditingController = TextEditingController();

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
            padding:
                const EdgeInsets.only(top: 80.0, left: 8, right: 8, bottom: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Create Event",
                  style: Theme.of(context).textTheme.labelLarge),
              SizedBox(height: 20),
              Text("Event Title",
                  style: Theme.of(context).textTheme.displayLarge),
              TextFormField(
                  decoration: InputDecoration(
                      hintText: "Your Event Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onChanged: (value) => {
                        setState(() {
                          title = value;
                        }),
                      }),
              SizedBox(height: 20),
              Text("Description",
                  style: Theme.of(context).textTheme.displayLarge),
              TextFormField(
                  decoration: InputDecoration(
                      hintText: "Your Event Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  maxLines: 5,
                  maxLength: 150,
                  onChanged: (value) => {
                        setState(() {
                          description = value;
                        }),
                      }),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80),
                      Text("Location",
                          style: Theme.of(context).textTheme.displayLarge),
                      SizedBox(height: 10),
                      TextFormField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)))),
                          onChanged: (value) => {
                                setState(() {
                                  location = value;
                                }),
                              }),
                      InkWell(
                        onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DestinationSelect()))
                            .then((results) => setState(() {
                                  _textEditingController.text =
                                      "${results.street}, ${results.locality}, ${results.postalCode}";
                                  location =
                                      "${results.street}, ${results.locality}, ${results.postalCode}";
                                })),
                        child: Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
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
                                decoration:
                                    BoxDecoration(color: Colors.transparent)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () => {
                                Navigator.pop(context),
                                trailcollection.doc().set({
                                  'title': title,
                                  'desc': description,
                                  'host': auth.currentUser!.uid,
                                  'address': location,
                                  'tag': tag!.substring(0, tag!.length - 2),
                                }),
                              },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[700],
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text('Done',
                              style: Theme.of(context).textTheme.displayLarge)),
                      SizedBox(height: 30),
                    ],
                  ),
                  DropdownButton<String>(
                      value: tag,
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
                          tag = value!;
                        });
                      },
                      items: tags.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key + entry.value,
                          child: Text(entry.key + entry.value),
                        );
                      }).toList()),
                ],
              ),
            ]),
          ),
        ));
  }
}
