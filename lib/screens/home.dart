// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:louisianatrail/components/infocard.dart';
import 'package:louisianatrail/screens/eventCreate.dart';
import 'package:louisianatrail/variables.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  final Function? setPage;
  const HomePage({super.key, this.setPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getHost(id) async {
    String name = "";
    await usercollection
        .doc(id)
        .get()
        .then((value) => name = value["username"]);
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 200,
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text("What's new on the trail",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 2),
                        borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(bottom: 5, right: 20),
                    padding: EdgeInsets.all(3),
                    child: GestureDetector(
                      onTap: () => {Feedback.forTap(context), print("Filter")},
                      child: Row(
                        children: [
                          Icon(MdiIcons.filter),
                          Text("Classes",
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          Icon(MdiIcons.chevronDown),
                        ],
                      ),
                    )),
              ],
            ),
            StreamBuilder(
                stream: trailcollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length + 1,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            if (index <= snapshot.data!.docs.length - 1) {
                              DocumentSnapshot document =
                                  snapshot.data!.docs[index];

                              return FutureBuilder(
                                  future: getHost(document["host"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String hostName = snapshot.data!;

                                      return Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: InkWell(
                                          onTap: () => {
                                            setState(() {
                                              address = document["address"];
                                              widget.setPage!.call(2, {
                                                "title": document["title"],
                                                "desc": document["desc"],
                                                "host": hostName,
                                                "address": document["address"],
                                                "type": document["type"]
                                              });
                                            })
                                          },
                                          child: InfoCard(
                                              title: document["title"],
                                              desc: document["desc"],
                                              host: hostName,
                                              type: document["type"],
                                              address: document["address"]),
                                        ),
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  });
                            } else {
                              return Center(
                                  child: Text("Thats all for now!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge));
                            }
                          }),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 65,
                width: 65,
                child: FloatingActionButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateEventPage())),
                    child: Icon(size: 30, MdiIcons.plus)),
              ),
            ))
      ],
    )));
  }
}
