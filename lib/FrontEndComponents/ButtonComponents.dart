// Button Component

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'TextComponents.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

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

// Same but also takes a list 
class HeaderPreviousList extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final List<String>? list;

  const HeaderPreviousList({
    Key? key,
    required this.text,
    this.list,
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
          // Navigate back to the previous screen and send the list
          Navigator.pop(context, list);
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


class AudioUploadButton extends StatefulWidget {
  final Function(File) onFileSelected;

  const AudioUploadButton({Key? key, required this.onFileSelected})
      : super(key: key);

  @override
  _AudioUploadButtonState createState() => _AudioUploadButtonState();
}

class _AudioUploadButtonState extends State<AudioUploadButton> {
  File? _selectedFile;

  Future<void> filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
      });
      widget.onFileSelected(file);
    } else {
      print("User cancelled file picker");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _selectedFile != null
                ? GenericText(text: _selectedFile!.path.split('/').last)
                : const GenericText(text: "select audio"),
            GestureDetector(
              onTap: filePicker,
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}



class TextClearButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TextClearButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

class SearchBarTag extends StatefulWidget {
  final String collectionPath;
  final Function(List<String>) onTagsChanged;

  SearchBarTag({required this.collectionPath, required this.onTagsChanged});

  @override
  _SearchBarTagState createState() => _SearchBarTagState();
}

class _SearchBarTagState extends State<SearchBarTag> {
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<QuerySnapshot>? _searchResultsSubscription;
  String _query = '';
  List<String> _searchResults = [" "];
  List<String> _addedTags = [];

  @override
  void dispose() {
    _searchController.dispose();
    _searchResultsSubscription?.cancel();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(widget.collectionPath);

      _searchResultsSubscription?.cancel();
      _searchResultsSubscription = collectionReference
          .orderBy('tag_field')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .snapshots()
          .listen((snapshot) {
        final searchResults = snapshot.docs;
        if (searchResults.isEmpty) {
          _searchResults = [query];
        } else {
          _searchResults = [];
          searchResults.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final tagName = data['tag_field'] ?? '';
            _searchResults.add(tagName);
          });
        }
        setState(() {});  // Update the UI
      });
    } else {
      _searchResults = [" "];
      setState(() {});
    }
  }

  void _startSearch(String value) {
    setState(() {
      _query = value;
    });
    _performSearch(_query);
  }

  void _onButtonPressed(String value) {
    if (!_addedTags.contains(value) && _addedTags.length < 3) {
      setState(() {
        _addedTags.add(value);
        widget.onTagsChanged(_addedTags);
      });
    }
  }

  void _onDelete(String tag) {
    setState(() {
      _addedTags.remove(tag);
      widget.onTagsChanged(_addedTags);
    });
  }

   @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'search...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.grey),
                  onChanged: _startSearch,
                ),
              ),
              const Icon(Icons.search, color: Colors.white, size: 15),
            ],
          ),
        ),
        ..._searchResults.map((result) {
          return Container(
            width: GlobalVariables.properWidth,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, GlobalVariables.mediumSpacing, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: GenericText(text: "# " + result),
                ),
                GestureDetector(
                  onTap: () => _onButtonPressed(result),
                  child: (_query == result)
                      ? const Text("create", style: TextStyle(fontSize: 12, color: Colors.grey))
                      : const Text("add", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                const SizedBox(width: 10),
                const Text("save", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: GlobalVariables.mediumSpacing),
        const Align(
          alignment: Alignment.centerLeft,
          child: GenericText(text: "added"),
        ),
        ..._addedTags.map((tag) => Container(
          width: GlobalVariables.properWidth,
          padding: const EdgeInsets.fromLTRB(0, GlobalVariables.mediumSpacing, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenericText(text: "# " + tag),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _addedTags.remove(tag);
                  });
                },
                child: const Text(
                  "delete",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}
















