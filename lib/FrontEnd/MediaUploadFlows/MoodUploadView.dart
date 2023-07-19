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
  Map<String, dynamic>? _selectedList;
  List<String>? _addedTags;
  VideoPlayerController? _videoController;
  String? _title;
  String? _audioRef;
  String? _imageRef;
  String? _musicID;
  String? _albumID = null;

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

  void _handleListSelected(Map<String, dynamic>? list) {
    setState(() {
      _selectedList = list;
      if (list != null && list.containsKey('title')) {
        _title = list['title'] as String?;
      }
    });
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
                        final List<String>? selectedTags =
                            await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TagFinderView(),
                          ),
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
                        final Map<String, dynamic>? list =
                            await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicFinderView(
                              onListSelected: _handleListSelected,
                            ),
                          ),
                        );
                        setState(() {
                          if (list != null) {
                            _selectedList = list;
                            _title = list['title'] as String?;
                            _audioRef = list['image_urls'][0] as String?;
                            _imageRef = list['image_urls'][1] as String?;
                            _musicID= list['unique_id']as String?;
                            if(list['album_id'] != null){
                              _albumID = list['album_id'] as String?;
                            }
                          }
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
                    // Your code for completing the upload

                    String documentID =
                        GlobalVariables().generateUUID().toString();
                        Map<String, dynamic> data = {
                          "unique_id": documentID,
                          "caption": GlobalVariables.inputOne.text,
                          "tags": _addedTags,
                          "user_id": GlobalVariables.userUUID,
                          "image_urls": [_selectedList!['image_urls'][0], _selectedList!['image_urls'][1]],
                          "title": _title,
                          "music_id" : _selectedList!['unique_id']
                        };

                        if (_selectedList!['album_id']!= null) {
                          data["albumID"] = _selectedList!['album_id'];
                        }
                        print(_selectedList);
                        print(_title);
                        print(_selectedList!['image_urls'][0]);
                        Map<String, File> mediaData = {
                          GlobalVariables().generateUUID().toString():
                              widget.mediaFile!,
                        };

                    FirebaseComponents()
                        .setEachDataToFirestore(
                            'users/${GlobalVariables.userUUID}/moods/$documentID',
                            data)
                        .then((result) {
                      if (result) {
                        FirebaseComponents()
                            .addDocumentWithTags(
                                documentID,
                                'users/${GlobalVariables.userUUID}/moods',
                                'moods',
                                _addedTags ?? [])
                            .then((result) {
                          if (result) {
                            FirebaseComponents()
                                .setEachMediaToStorage(
                                    'users/${GlobalVariables.userUUID}/moods',
                                    'users/${GlobalVariables.userUUID}/moods/$documentID',
                                    mediaData)
                                .then((result) {
                              FirebaseComponents().addDocumentToCollection(
                                  'songs/${_selectedList!['unique_id']}/moods',
                                  {'ref': 'users/${GlobalVariables.userUUID}/moods/$documentID'},
                                  documentID);
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
