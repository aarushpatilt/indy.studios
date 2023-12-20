import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicFinderView extends StatefulWidget {
  final Function(Map<String, dynamic>)? onListSelected;
  final String? select;

  MusicFinderView({this.onListSelected, this.select});

  @override
  _MusicFinderViewState createState() => _MusicFinderViewState();
}

class _MusicFinderViewState extends State<MusicFinderView> {
  Map<String, dynamic>? _selectedList;

  void _selectList(Map<String, dynamic> list) {
    setState(() {
      _selectedList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderPreviousMap(text: "music", list: _selectedList ?? {}),
      body: Padding(
        padding: const EdgeInsets.only(
          top: GlobalVariables.smallSpacing,
          left: GlobalVariables.horizontalSpacing,
          right: GlobalVariables.horizontalSpacing,
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarSong(
                collectionPath: 'songs',
                onListSelected: widget.onListSelected,
                select: widget.select,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
