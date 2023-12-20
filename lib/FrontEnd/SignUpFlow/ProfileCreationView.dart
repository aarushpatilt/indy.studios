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
      appBar: const HeaderPrevious(text: 'CREATE'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: GlobalVariables.smallSpacing),
                ProfilePictureSelector(
                  size: GlobalVariables.largeSize * 2, 
                  color: Colors.black, 
                  onImageSelected: (File file) {
                    GlobalVariables.mediaOne = file;
                  },
                ),
                const SizedBox(height: GlobalVariables.smallSpacing),
                ClearFilledTextField(labelText: "username", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),
                ClearFilledTextField(labelText: "bio", width: GlobalVariables.properWidth, controller: GlobalVariables.inputTwo),
                const SizedBox(height: GlobalVariables.smallSpacing),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GenericTextSmall(text: "background image:"),
                  ],
                ),
                const SizedBox(height: GlobalVariables.smallSpacing),
                BackgroundPictureSelector(
                  width: GlobalVariables.properWidth, 
                  height: GlobalVariables.largeSize * 4, 
                  color: Colors.black, 
                  onImageSelected: (File file) {
                    GlobalVariables.mediaTwo = file;
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: ClearButton(
                text: "CONTINUE", 
                width: GlobalVariables.properWidth, 
                onPressed: (){
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

                      FirebaseComponents().setEachMediaToStorage('users/${GlobalVariables.userUUID}/profile', 'users/${GlobalVariables.userUUID}', mediaSet).then( (result) {

                        if (result) {
                          GlobalVariables().disposeInputs();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StoryCreationView()));
                        }
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
