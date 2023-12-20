import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  static Future<File?> selectImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}

