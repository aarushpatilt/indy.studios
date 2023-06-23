import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicFinderView extends StatefulWidget {
  @override
  _MusicFinderViewState createState() => _MusicFinderViewState();
}

class _MusicFinderViewState extends State<MusicFinderView> {
  String? _selectedSongImage;
  String? _selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No return to previous screen
      appBar: HeaderPreviousList(text: "music", list: [_selectedTitle ?? "", _selectedSongImage ?? ""]),
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
              SearchBarSong(
                collectionPath: 'songs', 
                onDocumentSelected: (String imageUrl) {
                  setState(() {
                    _selectedSongImage = imageUrl;
                  });
                  print('Selected song image URL: $_selectedSongImage');
                },
                onTitleSelected: (String title) {
                  setState(() {
                    _selectedTitle = title;
                  });
                  print('Selected song image URL: $_selectedTitle');
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
