
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

      appBar: HeaderPrevious(text: "story"),
      
      //Scrolling to body
      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.only(top: GlobalVariables.largeSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),

          child: Align (

            alignment: Alignment.topLeft,

            child: Column (

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const TitleText(text: "Create"),
                const SizedBox(height: GlobalVariables.smallSpacing),
                const TitleText(text: "Story"),             
                const SizedBox(height: GlobalVariables.largeSpacing),
                const DescriptorText(text: "Story of you, written by you."),
                const SizedBox(height: GlobalVariables.largeSpacing),
                RectanglePictureSelector(size: GlobalVariables.properWidth, color: Colors.grey, onImageSelected: (File file) {

                  GlobalVariables.mediaOne = file;
                }),
                const SizedBox(height: GlobalVariables.smallSpacing),

                ClearFilledTextField(labelText: "Title", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),
                const SizedBox(height: GlobalVariables.smallSpacing),

                ParagraphTextField(text: "Start typing...", controller: GlobalVariables.inputTwo),
                const SizedBox(height: GlobalVariables.smallSpacing),

                ClearButton(text: "Compelete", width: GlobalVariables.properWidth, onPressed: () {

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