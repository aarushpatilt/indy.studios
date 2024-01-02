import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
