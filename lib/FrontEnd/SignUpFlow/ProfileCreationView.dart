import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/SignUpFlow/StoryCreationView.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../FrontEndComponents/ButtonComponents.dart';

class ProfileCreationView extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: const HeaderPrevious(text: 'create'),
      body: Padding(

        padding: const EdgeInsets.only(top: GlobalVariables.largeSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),

        child: Align (

          alignment: Alignment.topLeft,

          child: Column (

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              
            Row(

              children: [

                const Column(

                  children: [

                    TitleText(text: "Create"),
                    SizedBox(height: GlobalVariables.smallSpacing),
                    TitleText(text: "Profile"),
                  ],
                ),
                const SizedBox(width: GlobalVariables.largeSpacing * 2),
                ProfilePictureSelector(size: GlobalVariables.largeSize * 2, color: Colors.grey, onImageSelected: (File file) {

                    GlobalVariables.mediaOne = file;
                },),
              ],
            ),

              const SizedBox(height: GlobalVariables.largeSpacing),
              const DescriptorText(text: "Basic information required for creating a profile"),
              const SizedBox(height: GlobalVariables.largeSpacing - 10),
              const InformationText(text: "Background image:"),
              const SizedBox(height: GlobalVariables.smallSpacing),
              BackgroundPictureSelector(width: GlobalVariables.properWidth, height: GlobalVariables.largeSize * 4, color: Colors.grey, onImageSelected: (File file) {

                GlobalVariables.mediaTwo = file;
              } ),
              const SizedBox(height: GlobalVariables.smallSpacing),
              ClearFilledTextField(labelText: "username", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),
              ClearFilledTextField(labelText: "bio", width: GlobalVariables.properWidth, controller: GlobalVariables.inputTwo),

              ClearButton(text: "Compelete", width: GlobalVariables.properWidth, onPressed: (){

                Map<String, dynamic> data = {

                  "username" : GlobalVariables.inputOne.text,
                  "bio" : GlobalVariables.inputTwo.text,
                };

                Map<String, File> mediaSet = {

                  GlobalVariables().generateUUID().toString() : GlobalVariables.mediaOne!,
                  GlobalVariables().generateUUID().toString() : GlobalVariables.mediaTwo!,
                };

                FirebaseComponents().updateEachDataToFirestore('users/${GlobalVariables.userUUID}', data).then( (result) {

                  if (result) {

                    FirebaseComponents().setEachMediaToStorage('artists/${GlobalVariables.userUUID}/profile', 'artists/${GlobalVariables.userUUID}/profile', mediaSet).then( (result) {

                      if (result) {

                        GlobalVariables().disposeInputs();
                        //GlobalVariables().disposeMedia();
                        
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StoryCreationView()),);
                      }
                    });
                  }
                });
              }),
            ],
            )
        )
      )
    );
  }
}