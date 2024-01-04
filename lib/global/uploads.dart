import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:ndy/global/constants.dart';

class CircleImagePicker extends StatefulWidget {
  final double width;
  final double height;
  final Color strokeColor;
  final Function(File) onImagePicked;

  const CircleImagePicker({
    Key? key,
    required this.width,
    required this.height,
    required this.strokeColor,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  _CircleImagePickerState createState() => _CircleImagePickerState();
}

class _CircleImagePickerState extends State<CircleImagePicker> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
      widget.onImagePicked(File(_image!.path)); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _image == null ? Colors.transparent : null,
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
          border: Border.all(color: widget.strokeColor, width: 1),
          shape: BoxShape.circle,
        ),
        child: _image == null
            ? Icon(Icons.add, color: widget.strokeColor, weight: 0.5, size: 15)
            : null,
      ),
    );
  }
}

class RectangleImagePicker extends StatefulWidget {
  final double width;
  final double height;
  final Color strokeColor;
  final Function(File) onImagePicked;

  const RectangleImagePicker({
    Key? key,
    required this.width,
    required this.height,
    required this.strokeColor,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  _RectangleImagePickerState createState() => _RectangleImagePickerState();
}

class _RectangleImagePickerState extends State<RectangleImagePicker> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
      widget.onImagePicked(File(_image!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _image == null ? Colors.transparent : null,
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
          border: Border.all(color: widget.strokeColor, width: 1),
          // The key change for rectangle shape
          borderRadius: BorderRadius.circular(4), // Adjust the radius as needed
        ),
        child: _image == null
            ? Icon(Icons.add, color: widget.strokeColor, size: 15)
            : null,
      ),
    );
  }
}


class MusicUpload extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function(File) onFileSelected;

  MusicUpload({required this.title, required this.icon, required this.onFileSelected});

  @override
  _MusicUploadState createState() => _MusicUploadState();
}

class _MusicUploadState extends State<MusicUpload> {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<void> _pickMusicFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      int duration = await _getDuration(file);
      if (duration > 30000) { // If more than 30 seconds
        file = await _trimAudio(file); // Trim the audio
      }
      widget.onFileSelected(file);
    }
  }

  Future<int> _getDuration(File file) async {
    String dur = "";
    await FlutterFFprobe().getMediaInformation(file.path).then((info) {
      dur = info.getMediaProperties()?['duration'];
    });
    double? result = double.tryParse(dur);
    
    return result!.ceil();
  }

  Future<File> _trimAudio(File file) async {
    String outputPath = "${file.path}_trimmed.mp3"; // Define the output path
    await _flutterFFmpeg.execute("-i ${file.path} -ss 0 -t 30 -acodec copy $outputPath").then((session) async {
    });
    return File(outputPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.title, style: const TextStyle(color: Constant.activeColor, fontSize: Constant.smallMedText)),
              GestureDetector(
                child: Icon(widget.icon, color: Constant.activeColor, size: Constant.smallMedText),
                onTap: _pickMusicFile,
              ),
            ],
          ),
          // Additional UI elements related to music upload can be added here
        ],
      ),
    );
  }
}