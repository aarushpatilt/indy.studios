import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/ButtonComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';

 class ThoughtUploadView extends StatefulWidget {

  ThoughtUploadView();

  @override
  _ThoughtUploadViewState createState() => _ThoughtUploadViewState();
}

class _ThoughtUploadViewState extends State<ThoughtUploadView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPrevious(text: "THOUGHT"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: GlobalVariables.largeSpacing,
            left: GlobalVariables.horizontalSpacing,
            right: GlobalVariables.horizontalSpacing,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DISPLAY IMAGES OR VIDEOS HERE
                  const SizedBox(height: GlobalVariables.largeSpacing),
                  ClearFilledTextField(labelText: "THOUGHT", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),

                  ClearButton(
                    text: "COMPLETE",
                    width: GlobalVariables.properWidth,
                    onPressed: () {
                      String documentID = GlobalVariables().generateUUID().toString();
                      Map<String, dynamic> data = {
                        "unique_id": documentID,
                        "caption": GlobalVariables.inputOne.text,
                        "user_id": GlobalVariables.userUUID,
                      };

                      // Loop through the media files and generate the Map
                      FirebaseComponents().setEachDataToFirestore('users/${GlobalVariables.userUUID}/posts/$documentID', data).then((result) {
                        if (result) {

                          FirebaseComponents().addDocumentRef(documentID, 'users/${GlobalVariables.userUUID}/posts', 'threads', 'thought').then((result) {

                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}