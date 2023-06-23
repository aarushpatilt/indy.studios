import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'MoodUploadView.dart'; // Import the MoodUploadView

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
        mediaFile: File(_imageFile!.path),
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
        mediaFile: File(_videoFile!.path),
        isVideo: true,
      ),
    ));
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
        mediaFile: File(_videoFile!.path),
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
    return Padding(
      padding: EdgeInsets.only(top: 100),  // Add padding here
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text('Take Photo'),
                onPressed: _pickImage,
              ),
              ElevatedButton(
                child: Text('Record Video'),
                onPressed: _pickVideo,
              ),
              ElevatedButton(
                child: Text('Select Video'),
                onPressed: _selectVideo,
              ),
            ],
          ),
          if (_imageFile != null)
            CachedNetworkImage(
              imageUrl: _imageFile!.path,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          if (_videoFile != null)
            _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : CircularProgressIndicator(),
        ],
      ),
    );
  }
}
