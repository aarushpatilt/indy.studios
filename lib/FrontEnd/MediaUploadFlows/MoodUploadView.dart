import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../SignUpFlow/UpgradeView.dart';
import 'MusicFinderView.dart';
import 'TagFinderView.dart';
import 'package:video_player/video_player.dart';

class MoodUploadView extends StatefulWidget {
  final File? mediaFile;
  final bool isVideo;

  MoodUploadView({this.mediaFile, this.isVideo = false});

  @override
  _MoodUploadViewState createState() => _MoodUploadViewState();
}

class _MoodUploadViewState extends State<MoodUploadView> {
  List<String>? _addedTags;
  VideoPlayerController? _videoController;
  String? _title;
  String? _audioRef;
  String? _imageRef;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.file(widget.mediaFile!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No return to previous screen
      appBar: HeaderPreviousList(text: "MOODS", list: _addedTags),
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
                // DISPLAY IMAGE OR VIDEO HERE
                if (widget.isVideo)
                  _videoController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      : CircularProgressIndicator()
                else
                  Image.file(
                    widget.mediaFile!,
                    width: GlobalVariables.properWidth,
                    height: GlobalVariables.properWidth,
                    fit: BoxFit.cover,
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
                    const ProfileText400(text: "TAGS", size: 12),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_title != null)
                      Row(
                        children: [
                            GenericText(text: _title!),
                        ],
                      )
                    else
                        const ProfileText400(text: "MUSIC SELECT", size: 12),
                        GestureDetector(
                          onTap: () async {
                            final List<String> title = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MusicFinderView()),
                            );
                            setState(() {
                              _title = title[0];
                              _imageRef = title[1];
                              _audioRef = title[2];
                              
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
                ClearFilledTextField(
                  labelText: "CAPTION",
                  width: GlobalVariables.properWidth,
                  controller: GlobalVariables.inputOne,
                ),
                ClearButton(
                  text: "COMPLETE",
                  width: GlobalVariables.properWidth,
                  onPressed: () {

                    String documentID = GlobalVariables().generateUUID().toString();
                    Map<String, dynamic> data = {
                      "unique_id": documentID,
                      "caption": GlobalVariables.inputOne.text,
                      "tags": _addedTags,
                      "user_id": GlobalVariables.userUUID,
                      "image_urls": [_audioRef, _imageRef],
                      "title": _title
                    };


                    Map<String, File> mediaData = {
                    
                      GlobalVariables().generateUUID().toString(): widget.mediaFile!,
                    };

                    FirebaseComponents().setEachDataToFirestore('users/${GlobalVariables.userUUID}/moods/${documentID}', data).then((result) {
                        
                        if (result) {

                          FirebaseComponents().addDocumentWithTags(documentID, 'users/${GlobalVariables.userUUID}/moods', 'moods', _addedTags ?? []).then((result) {

                            if (result) {
                              
                              FirebaseComponents().setEachMediaToStorage('users/${GlobalVariables.userUUID}/moods', 'users/${GlobalVariables.userUUID}/moods/${documentID}', mediaData).then((result) {
                                  print("done");
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
