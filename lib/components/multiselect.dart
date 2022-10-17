// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:louisianatrail/components/auto_search.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MultiSelect extends StatefulWidget {
  final MultiSelectController? controller;
  final List<String>? tags;
  final String? hintText;
  final List<Color> chipColors;
  const MultiSelect({
    super.key,
    required this.controller,
    required this.chipColors,
    this.tags,
    this.hintText,
  });

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  @override
  void initState() {
    super.initState();
    widget.controller!.setTags(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        child: Stack(children: [
          Positioned(
            top: 60,
            child: widget.controller!.selectedTags!.isNotEmpty
                ? SizedBox(
                    height: 100,
                    width: 350,
                    child: GridView.builder(
                      itemCount: widget.controller!.selectedTags!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 2.2),
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary
                              ])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Text(widget.controller!.selectedTags![index],
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: GestureDetector(
                                    child: Icon(MdiIcons.delete,
                                        color: Colors.red),
                                    onTap: () => {
                                          Feedback.forTap(context),
                                          setState(() {
                                            widget.controller!.selectedTags!
                                                .removeWhere((entry) =>
                                                    entry ==
                                                    widget.controller!
                                                        .selectedTags![index]);
                                          })
                                        }),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Text("None Selected"),
          ),
          AutoSearchInput(
              data: widget.tags!,
              maxElementsToDisplay: 10,
              itemsShownAtStart: 3,
              hintText: widget.hintText!,
              onItemTap: (int index) => {
                    setState(() {
                      if (!widget.controller!.selectedTags!
                          .contains(widget.tags![index])) {
                        widget.controller!.selectedTags!
                            .add(widget.tags![index]);
                      }
                    })
                  }),
        ]));
  }
}

class MultiSelectController extends ChangeNotifier {
  List<String>? tags;
  List<String>? selectedTags = [];

  void setTags(List<String>? list) {
    tags = list;
  }
}
