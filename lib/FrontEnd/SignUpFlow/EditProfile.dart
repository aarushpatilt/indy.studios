import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/SignUpFlow/StoryCreationView.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../FrontEndComponents/ButtonComponents.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late Future<Map<String, dynamic>> specificData;

  @override
  void initState() {
    super.initState();
    specificData = FirebaseComponents().getSpecificData(documentPath: 'users/${GlobalVariables.userUUID}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPrevious(text: 'CREATE'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: specificData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            GlobalVariables.inputOne.text = snapshot.data['username'];
            GlobalVariables.inputTwo.text = snapshot.data['bio'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: GlobalVariables.smallSpacing),
                      ProfilePictureSelector(
                        size: GlobalVariables.largeSize * 2, 
                        color: Colors.transparent, 
                        onImageSelected: (File file) {
                          GlobalVariables.mediaOne = file;
                        },
                        currentProfileUrl: snapshot.data['image_urls'][0],
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
                        currentBackgroundUrl: snapshot.data['image_urls'][1],
                    
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: ClearButton(
                      text: "CONTINUE", 
                      width: GlobalVariables.properWidth, 
onPressed: () async {
  Map<String, dynamic> data = {
    "username" : GlobalVariables.inputOne.text,
    "bio" : GlobalVariables.inputTwo.text,
  };

  // If mediaOne or mediaTwo are not null, call replaceAndUploadImage
  Future<bool>? profilePicUpdate;
  if (GlobalVariables.mediaOne != null) {
    String oldProfileUrl = snapshot.data['image_urls'][0];
    profilePicUpdate = FirebaseComponents().replaceAndUploadImage(snapshot.data['image_urls'], 'users/${GlobalVariables.userUUID}', 'users/${GlobalVariables.userUUID}/profile', oldProfileUrl, GlobalVariables.mediaOne!, 0);
  }

  Future<bool>? backgroundPicUpdate;
  if (GlobalVariables.mediaTwo != null) {
    String oldBackgroundUrl = snapshot.data['image_urls'][1];
    backgroundPicUpdate = FirebaseComponents().replaceAndUploadImage(snapshot.data['image_urls'],'users/${GlobalVariables.userUUID}', 'users/${GlobalVariables.userUUID}/profile', oldBackgroundUrl, GlobalVariables.mediaTwo!, 1);
  }

  // Wait for all updates to finish
  List<Future<bool>> updates = [FirebaseComponents().updateEachDataToFirestore('users/${GlobalVariables.userUUID}', data)];
  if (profilePicUpdate != null) updates.add(profilePicUpdate);
  if (backgroundPicUpdate != null) updates.add(backgroundPicUpdate);
  
  List<bool> results = await Future.wait(updates);

  // Check if all updates were successful
  if (results.every((result) => result == true)) {
    GlobalVariables().disposeInputs();
    Navigator.pop(context);
  } else {
    // Handle failure case
    print("Error updating data");
  }
},

                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
