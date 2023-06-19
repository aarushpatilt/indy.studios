import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumSongsDisplayUploadView.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

class AlbumCoverUploadView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No return to previous screen
      appBar: const HeaderPrevious(text: "singles"),
      body: SingleChildScrollView(
        child: Padding(
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

                // GET IMAGE AND DISPLAY IT HERE 
                RectanglePictureSelector(
                  size: GlobalVariables.properWidth,
                  color: Colors.transparent,
                  onImageSelected: (File file) {
                    GlobalVariables.mediaOne = file;
                  },
                ),

                const SizedBox(height: GlobalVariables.mediumSpacing),
                ClearFilledTextField(
                  labelText: "title ",
                  width: GlobalVariables.properWidth,
                  controller: GlobalVariables.inputOne,
                ),
                ClearButton(
                  text: "Complete",
                  width: GlobalVariables.properWidth,
                  onPressed: () {

                    String documentID = GlobalVariables().generateUUID().toString();
                    String albumImageRef = GlobalVariables().generateUUID().toString();

                    Map<String, dynamic> data = {
                      "unique_id": documentID,
                      "title": GlobalVariables.inputOne.text,
                    };

                    Map<String, File> mediaData = {
                      albumImageRef : GlobalVariables.mediaOne!,
                      
                    };

                    FirebaseComponents().setEachDataToFirestore('users/${GlobalVariables.userUUID}/albums/$documentID', data).then((result) {
                        
                        if (result) {

                          FirebaseComponents().addDocumentRef(documentID, 'users/${GlobalVariables.userUUID}/albums', 'songs', GlobalVariables.inputOne.text).then((result) {

                            if(result){

                              FirebaseComponents().setEachMediaToStorage('users/${GlobalVariables.userUUID}/albums/', 'users/${GlobalVariables.userUUID}/albums/$documentID', mediaData).then((result) {

                                GlobalVariables().disposeInputs();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumSongDisplayUploadView(albumID: documentID)));
                              });
                            }
                          });
                        }
                    });

                  },
                ),
                const SizedBox(height: GlobalVariables.mediumSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
