import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../SignUpFlow/UpgradeView.dart';
import 'TagFinderView.dart';

class SingleUploadView extends StatefulWidget {
  @override
  _SingleUploadViewState createState() => _SingleUploadViewState();
}

class _SingleUploadViewState extends State<SingleUploadView> {
  List<String>? _addedTags;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No return to previous screen
      appBar: HeaderPreviousList(text: "singles", list: _addedTags),
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
                RectanglePictureSelector(
                  size: GlobalVariables.properWidth,
                  color: Colors.transparent,
                  onImageSelected: (File file) {
                    GlobalVariables.mediaOne = file;
                  },
                ),
                const SizedBox(height: GlobalVariables.mediumSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_addedTags != null)
                      Row(
                        children: [
                          for (int i = 0; i < _addedTags!.length; i++) ...[
                            GenericText(text: "#" + _addedTags![i]),
                            const SizedBox(width: 5),
                          ],
                        ],
                      )
                    else
                      GenericText(text: "tags"),
                    GestureDetector(
                      onTap: () async {
                        final List<String>? selectedTags = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TagFinderView()),
                        );
                        setState(() {
                          _addedTags = selectedTags;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.search,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: GlobalVariables.smallSpacing),
                AudioUploadButton(
                  onFileSelected: (File file) {
                    GlobalVariables.mediaTwo = file;
                  },
                ),
                const SizedBox(height: GlobalVariables.smallSpacing),
                ClearFilledTextField(
                  labelText: "title ",
                  width: GlobalVariables.properWidth,
                  controller: GlobalVariables.inputOne,
                ),
                ClearFilledTextField(
                  labelText: "artists ",
                  width: GlobalVariables.properWidth,
                  controller: GlobalVariables.inputTwo,
                ),
                ClearFilledTextField(
                  labelText: "description ",
                  width: GlobalVariables.properWidth,
                  controller: GlobalVariables.inputThree,
                ),
                ClearButton(
                  text: "Complete",
                  width: GlobalVariables.properWidth,
                  onPressed: () {

                    String documentID = GlobalVariables().generateUUID().toString();
                    Map<String, dynamic> data = {
                      "unique_id": documentID,
                      "title": GlobalVariables.inputOne.text,
                      "artists": GlobalVariables.inputTwo.text,
                      "tags": _addedTags,
                      "user_id": GlobalVariables.userUUID,
                      "description": GlobalVariables.inputThree.text,
                    };

                    Map<String, File> mediaData = {
                      
                      GlobalVariables().generateUUID().toString(): GlobalVariables.mediaTwo!,
                      GlobalVariables().generateUUID().toString(): GlobalVariables.mediaOne!,
                    };

                    FirebaseComponents().setEachDataToFirestore('users/${GlobalVariables.userUUID}/singles/${documentID}', data).then((result) {
                        
                        if (result) {

                          FirebaseComponents().addDocumentRef('$documentID', 'users/${GlobalVariables.userUUID}/singles', 'songs', GlobalVariables.inputOne.text).then((result) {

                            if (result) {
                              FirebaseComponents().addDocumentWithTags(documentID, 'users/${GlobalVariables.userUUID}/singles', 'tags',_addedTags ?? []).then((result) {

                                if (result) {
                                  
                                  FirebaseComponents().setEachMediaToStorage('users/${GlobalVariables.userUUID}/singles', 'users/${GlobalVariables.userUUID}/singles/${documentID}', mediaData).then((result) {
                                    GlobalVariables().disposeInputs();
                                    Navigator.pop(context);
                                  });
                                }
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
