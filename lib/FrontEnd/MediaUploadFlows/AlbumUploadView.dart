import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../SignUpFlow/UpgradeView.dart';
import 'TagFinderView.dart';

class AlbumUploadView extends StatefulWidget {
  final String albumID;
  final String albumImageRef;

  AlbumUploadView({Key? key, required this.albumID, required this.albumImageRef }) : super(key: key);

  @override
  _AlbumUploadViewState createState() => _AlbumUploadViewState();
}

class _AlbumUploadViewState extends State<AlbumUploadView> {
  List<String>? _addedTags;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No return to previous screen
      appBar: HeaderPreviousList(text: "albums", list: _addedTags),
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
                FirstImageDisplay(documentPath: '/users/5f0b7cc7-8235-4ac6-b0e6-dcd1ba3d3d9a/albums/${widget.albumID}'),
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
                ClearButton(
                  text: "Complete",
                  width: GlobalVariables.properWidth,
                  onPressed: () {

                    String documentID = GlobalVariables().generateUUID().toString();
                    Map<String, dynamic> data = {
                      "unique_id": documentID,
                      "title": GlobalVariables.inputOne.text,
                      "artists": GlobalVariables.inputTwo.text,
                      "tags": _addedTags
                    };

                    Map<String, File> mediaData = {

                      widget.albumImageRef : GlobalVariables.mediaOne!,
                      GlobalVariables().generateUUID().toString(): GlobalVariables.mediaTwo!,
                    };

                    FirebaseComponents().setEachDataToFirestore('users/${GlobalVariables.userUUID}/albums/${widget.albumID}/collections/${documentID}', data).then((result) {
                        
                        if (result) {

                          FirebaseComponents().addDocumentRef('$documentID', 'users/${GlobalVariables.userUUID}/albums/${widget.albumID}/collections', 'songs', GlobalVariables.inputOne.text).then((result) {

                            if (result) {

                              FirebaseComponents().addDocumentWithTags(widget.albumID, 'users/${GlobalVariables.userUUID}/albums', 'tags',_addedTags ?? []).then((result) {

                                if (result) {
                                  
                                  FirebaseComponents().setEachMediaToStorage('users/${GlobalVariables.userUUID}/albums', 'users/${GlobalVariables.userUUID}/albums/${widget.albumID}/collections/${documentID}', mediaData).then((result) {
                                      GlobalVariables().disposeInputs();
                                      print("done");
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
