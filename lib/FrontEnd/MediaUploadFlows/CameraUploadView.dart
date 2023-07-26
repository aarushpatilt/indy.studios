import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import 'MoodUploadView.dart';

class CameraUploadView extends StatefulWidget {
  @override
  _CameraUploadViewState createState() => _CameraUploadViewState();
}

class _CameraUploadViewState extends State<CameraUploadView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  XFile? _videoFile;
  VideoPlayerController? _videoController;

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = selectedImage;
    });
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MoodUploadView(
        mediaFiles: [File(_imageFile!.path)],
        isVideo: false,
      ),
    ));
  }

  Future<void> _pickVideo() async {
    final XFile? selectedVideo = await _picker.pickVideo(source: ImageSource.camera);
    setState(() {
      _videoFile = selectedVideo;
      _videoController = VideoPlayerController.file(File(_videoFile!.path))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    });
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MoodUploadView(
        mediaFiles: [File(_videoFile!.path)],
        isVideo: true,
      ),
    ));
  }

Future<void> _selectImage() async {
  final List<XFile>? selectedImages = await _picker.pickMultiImage();
  if (selectedImages != null) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MoodUploadView(
        mediaFiles: selectedImages.map((file) => File(file.path)).toList(),
        isVideo: false,
      ),
    ));
  }
}


  Future<void> _selectVideo() async {
    final XFile? selectedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = selectedVideo;
      _videoController = VideoPlayerController.file(File(_videoFile!.path))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    });
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MoodUploadView(
        mediaFiles: [File(_videoFile!.path)],
        isVideo: true,
      ),
    ));
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
        padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
        child: Column(
          children: <Widget>[
            const SizedBox(height: GlobalVariables.mediumSpacing),
            const ProfileText400(text: "Choose a media type that you want to upload", size: 12),
            const SizedBox(height: 5),
            const ProfileText400(text: "You can only chose one type at the moment", size: 12),
            const SizedBox(height: GlobalVariables.largeSpacing),
            InkWell(
              onTap: _pickImage,
              child: _buildRow('TAKE A PHOTO'),
            ),
            const SizedBox(height: GlobalVariables.largeSpacing),
            InkWell(
              onTap: _pickVideo,
              child: _buildRow('RECORD A VIDEO'),
            ),
            const SizedBox(height: GlobalVariables.largeSpacing),
            InkWell(
              onTap: _selectVideo,
              child: _buildRow('SELECT A VIDEO'),
            ),
            const SizedBox(height: GlobalVariables.largeSpacing),
            InkWell(
              onTap: _selectImage,
              child: _buildRow('SELECT A PHOTO'),
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
