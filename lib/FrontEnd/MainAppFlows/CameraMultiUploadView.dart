import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/ButtonComponents.dart';
import '../../FrontEndComponents/CustomTabController.dart';
import '../../FrontEndComponents/TextComponents.dart';
import '../MediaUploadFlows/MusicFinderView.dart';
import '../MediaUploadFlows/TagFinderView.dart';

class CameraMultiUploadView extends StatefulWidget {
  @override
  _CameraMultiUploadViewState createState() => _CameraMultiUploadViewState();
}

class _CameraMultiUploadViewState extends State<CameraMultiUploadView> {
  List<File>? _mediaFiles;
  VideoPlayerController? _videoController;

  Future<void> _selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _mediaFiles = result.paths.map((path) => File(path!)).toList();
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostUploadView(
          mediaFiles: _mediaFiles!,
        ),
      ));
    }
  }

  Future<void> _selectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _mediaFiles = result.paths.map((path) => File(path!)).toList();
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostUploadView(
          mediaFiles: _mediaFiles!,
        ),
      ));
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
      appBar: const HeaderPrevious(text: "CAMERA"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
        child: Column(
          children: <Widget>[
            const SizedBox(height: GlobalVariables.mediumSpacing),
            const ProfileText400(text: "Choose a media type that you want to upload", size: 12),
            const SizedBox(height: 5),
            const ProfileText400(text: "You can only chose one type at the moment", size: 12),
            const SizedBox(height: GlobalVariables.largeSpacing),
            InkWell(
              onTap: _selectImage,
              child: _buildRow('SELECT PHOTOS'),
            ),
            const SizedBox(height: GlobalVariables.largeSpacing),
            InkWell(
              onTap: _selectVideo,
              child: _buildRow('SELECT VIDEOS'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: GlobalVariables.smallSpacing),
          ProfileText400(text: text, size: 10),
        ],
      ),
    );
  }
}
 class PostUploadView extends StatefulWidget {
  final List<File> mediaFiles;

  PostUploadView({required this.mediaFiles});

  @override
  _PostUploadViewState createState() => _PostUploadViewState();
}

class _PostUploadViewState extends State<PostUploadView> {
  List<String>? _addedTags;
  String? _title;
  List<VideoPlayerController?> _controllers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.mediaFiles.forEach((file) {
      if (['mp4', 'mov', 'avi'].contains(file.path.split('.').last)) {
        final controller = VideoPlayerController.file(file);
        controller.initialize().then((_) {
          controller.setLooping(true);
          setState(() {});
        });
        _controllers.add(controller);
      } else {
        _controllers.add(null);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPrevious(text: "POST"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: GlobalVariables.largeSpacing,
            left: GlobalVariables.horizontalSpacing,
            right: GlobalVariables.horizontalSpacing,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DISPLAY IMAGES OR VIDEOS HERE
                  Container(
                    height: GlobalVariables.properWidth,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.mediaFiles.length,
                      itemBuilder: (context, index) {
                        String filePath = widget.mediaFiles[index].path;
                        String extension = filePath.split('.').last.toLowerCase();

                        // Debug: Print extension of the file

                        // Add padding between media items
                        return Padding(
                          padding: EdgeInsets.only(right: (index != widget.mediaFiles.length - 1) ? 15 : 0),
                          child: (['jpg', 'png', 'jpeg'].contains(extension))
                              // Display image
                              ? () {
                                  // Debug: Print file path of the image
                                  return Image.file(
                                    widget.mediaFiles[index],
                                    width: GlobalVariables.properWidth,
                                    height: GlobalVariables.properWidth,
                                    fit: BoxFit.cover,
                                  );
                                }()
                              // Assume it's a video
                              : ( _controllers[index] != null &&
                                  _controllers[index]!.value.isInitialized
                                )
                                ? AspectRatio(
                                    aspectRatio: _controllers[index]!.value.aspectRatio,
                                    child: VideoPlayer(_controllers[index]!),
                                  )
                                : Container(),  // show placeholder while video is loading
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: GlobalVariables.largeSpacing),
                  ClearFilledTextField(labelText: "CAPTION", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),

                  ClearButton(
                    text: "COMPLETE",
                    width: GlobalVariables.properWidth,
                    onPressed: () {
                      String documentID = GlobalVariables().generateUUID().toString();
                      Map<String, dynamic> data = {
                        "unique_id": documentID,
                        "caption": GlobalVariables.inputOne.text,
                        "user_id": GlobalVariables.userUUID,
                      };

                      // Loop through the media files and generate the Map
                      Map<String, File> mediaData = {};
                      for (var file in widget.mediaFiles) {
                        mediaData[GlobalVariables().generateUUID().toString()] = file;
                      }

                      FirebaseComponents().setEachDataToFirestore('users/${GlobalVariables.userUUID}/threads/$documentID', data).then((result) {
                        if (result) {

                          FirebaseComponents().addDocumentRef(documentID, 'users/${GlobalVariables.userUUID}/threads', 'threads', 'threads').then((result) {

                            FirebaseComponents().setEachMediaToStorage('users/${GlobalVariables.userUUID}/threads', 'users/${GlobalVariables.userUUID}/threads/${documentID}', mediaData).then((result) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => CustomTabPage()),
                                (Route<dynamic> route) => false,
                              );
                            });
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}