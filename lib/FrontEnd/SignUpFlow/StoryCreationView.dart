
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import 'UpgradeView.dart';

class StoryCreationView extends StatelessWidget {

    @override 
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: const HeaderPrevious(text: "STORY"),
      
      //Scrolling to body
      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.only(top: GlobalVariables.smallSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),

          child: Align (

            alignment: Alignment.topLeft,

            child: Column (

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                RectanglePictureSelector(size: GlobalVariables.properWidth, color: Colors.grey, onImageSelected: (File file) {

                  GlobalVariables.mediaOne = file;
                }),
                const SizedBox(height: GlobalVariables.smallSpacing),

                ClearFilledTextField(labelText: "title", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),
                const SizedBox(height: GlobalVariables.smallSpacing),

                ParagraphTextField(text: "type here...", controller: GlobalVariables.inputTwo),
                const SizedBox(height: GlobalVariables.smallSpacing),

                ClearButton(text: "CONTINUE", width: GlobalVariables.properWidth, onPressed: () {

                  Map<String, dynamic> data = {

                    "title" : GlobalVariables.inputOne.text,
                    "story" : GlobalVariables.inputTwo.text,
                  };

                  Map<String, File> mediaData = {

                    "story_picture" : GlobalVariables.mediaOne!,
                  };

                  FirebaseComponents().setEachDataToFirestore('users/${GlobalVariables.userUUID}/bio/story', data).then( (result) {

                  if (result) {

                    FirebaseComponents().setEachMediaToStorage('users/${GlobalVariables.userUUID}/profile', 'users/${GlobalVariables.userUUID}/bio/story', mediaData).then( (result) {

                      if (result) {

                        GlobalVariables().disposeInputs();
                        
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpgradeView()),);
                      }
                    });
                  }
                });

                }),
                const SizedBox(height: GlobalVariables.mediumSpacing),
                
              ],
            )
          )
        )
      )
      
    );

  }
}