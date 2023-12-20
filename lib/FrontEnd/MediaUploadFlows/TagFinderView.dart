import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

class TagFinderView extends StatefulWidget {
  @override
  _TagFinderViewState createState() => _TagFinderViewState();
}

class _TagFinderViewState extends State<TagFinderView> {
  List<String> _addedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No return to previous screen
      appBar: HeaderPreviousList(text: "TAGS", list: _addedTags),
      body: Padding(
        padding: const EdgeInsets.only(
          top: GlobalVariables.largeSpacing,
          left: GlobalVariables.horizontalSpacing,
          right: GlobalVariables.horizontalSpacing,
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarTag(
                collectionPath: 'genre',
                onTagsChanged: (tags) {
                  setState(() {
                    _addedTags = tags;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
