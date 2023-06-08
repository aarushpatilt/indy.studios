// Button Component

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'TextComponents.dart';
import 'dart:io';

// Header with previous indicator
class HeaderPrevious extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const HeaderPrevious({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GenericText(text: text),

      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Navigate back to the previous screen
          Navigator.pop(context);
        },
      ),

      backgroundColor: Colors.black,
    );
  }
}

// Button with white background, black text
class WhiteButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const WhiteButton({
    Key? key,
    required this.text,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(

        backgroundColor: Colors.white,
        foregroundColor: Colors.black,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

// Button with no background, white text
class ClearButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const ClearButton({
    Key? key,
    required this.text,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(

        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

// Button with outline, white, transparent background
class WhiteOutlineButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const WhiteOutlineButton({
    Key? key,
    required this.text,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(

        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

// Button with outline, white, transparent background
class BlackOutlineButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const BlackOutlineButton({
    Key? key,
    required this.text,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(

        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black, width: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

// Profile picture selector ( circle )


class ProfilePictureSelector extends StatefulWidget {
  final double size;
  final Color color;
  final Function(File) onImageSelected;

  const ProfilePictureSelector({
    Key? key,
    required this.size,
    required this.color,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _ProfilePictureSelectorState createState() =>
      _ProfilePictureSelectorState();
}

class _ProfilePictureSelectorState extends State<ProfilePictureSelector> {
  XFile? _image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final CroppedFile? croppedImage = (await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        maxHeight: 700,
        maxWidth: 700,
      ));

      if (croppedImage != null) {
        final file = File(croppedImage.path);
        setState(() {
          _image = XFile(file.path);
        });

        widget.onImageSelected(file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: getImage,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image == null
            ? Icon(
                Icons.add,
                color: Colors.white,
                size: widget.size * 0.25,
              )
            : null,
      ),
    );
  }
}

class BackgroundPictureSelector extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final Function(File) onImageSelected;

  const BackgroundPictureSelector({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _BackgroundPictureSelectorState createState() =>
      _BackgroundPictureSelectorState();
}

class _BackgroundPictureSelectorState
    extends State<BackgroundPictureSelector> {
  XFile? _image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });

      widget.onImageSelected(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: getImage,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.color,
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image == null
            ? Icon(
                Icons.add,
                color: Colors.white,
                size: widget.height * 0.15,
              )
            : null,
      ),
    );
  }
}

// Generic Square selector

class RectanglePictureSelector extends StatefulWidget {
  final double size;
  final Color color;
  final Function(File) onImageSelected;

  const RectanglePictureSelector({
    Key? key,
    required this.size,
    required this.color,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _RectanglePictureSelectorState createState() =>
      _RectanglePictureSelectorState();
}

class _RectanglePictureSelectorState extends State<RectanglePictureSelector> {
  XFile? _image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final CropAspectRatio aspectRatio = CropAspectRatio(ratioX: 1, ratioY: 1);
      final ImageCropper imageCropper = ImageCropper();

      final CroppedFile? croppedImage = await imageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: aspectRatio,
        compressQuality: 80,
        maxHeight: GlobalVariables.properWidth.toInt(),
        maxWidth: GlobalVariables.properWidth.toInt(),
      );

      if (croppedImage != null) {
        final file = File(croppedImage.path);
        setState(() {
          _image = XFile(file.path);
        });

        widget.onImageSelected(file);
      }
    }
  }

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: getImage,
    child: Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
        color: widget.color,
        image: _image != null
            ? DecorationImage(
                image: FileImage(File(_image!.path)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: _image == null
          ? Icon(
              Icons.add,
              color: Colors.white,
              size: widget.size * 0.05,
            )
          : null,
    ),
  );
}

}




