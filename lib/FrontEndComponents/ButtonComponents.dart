// Button Component

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'TextComponents.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// Header with previous indicator
import 'package:flutter/material.dart';

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
      title: GenericTextSmall(text: text),

      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Navigate back to the previous screen
          Navigator.pop(context);
        },
        iconSize: 17,
      ),

      backgroundColor: Colors.transparent,
      elevation: 0.0, // Set elevation to 0
    );
  }
}


class HeaderMenuStack extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  HeaderMenuStack({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);  // increase the AppBar height by 50

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,  // remove the default padding
      backgroundColor: Colors.transparent,  // make the AppBar background transparent
      elevation: 0,  // remove shadow underneath AppBar
      title: Padding(
        padding: EdgeInsets.only(top: 50.0),  // add 50.0 padding to the top
        child: Container(
          alignment: Alignment.center,  // center align vertically
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // Add your functionality here
                },
                child: Icon(Icons.menu),  // icon with three horizontal lines
              ),
              Expanded(
                child: Center(
                  child: GenericText(text: title),  // already defined in another file
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Same but also takes a list 
class HeaderPreviousString extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final String? str;

  const HeaderPreviousString({
    Key? key,
    required this.text,
    this.str,
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
          Navigator.pop(context, str);
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

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
        child: 
          GenericTextSmallDark(text: text)
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
        child: 
        GenericTextSmall(text: text)
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
        side: const BorderSide(color: Colors.white, width: 0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
        child: 
        GenericTextSmall(text: text)
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
          border: Border.all(color: Colors.white, width: 0.5), // Add this
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image == null
            ? const Icon(
                Icons.add,
                color: Colors.white,
                size: 15,
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
          border: Border.all( // Added the border property
            color: Colors.white,
            width: 0.5,
          ),
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image == null
            ? const Icon(
                Icons.add,
                color: Colors.white,
                size: 15,
              )
            : null,
      ),
    );
  }
}


// Generic Square selector

class RectanglePictureSelector extends StatefulWidget {
  final double size;
  final Function(File) onImageSelected;
  final Color? color;

  const RectanglePictureSelector({
    Key? key,
    required this.size,
    required this.onImageSelected,
    this.color
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
      const CropAspectRatio aspectRatio = CropAspectRatio(ratioX: 1, ratioY: 1);
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
          color: Colors.transparent,
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
          border: Border.all(
            color: Colors.white,
            width: 0.5,
          ),
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

class SearchBarSong extends StatefulWidget {
  final String collectionPath;
  final Function(String) onDocumentSelected;
  final Function(String) onTitleSelected;
  final Function(String) onAudioSelected;

  SearchBarSong({required this.collectionPath, required this.onDocumentSelected, required this.onTitleSelected, required this.onAudioSelected});

  @override
  _SearchBarSongState createState() => _SearchBarSongState();
}

class _SearchBarSongState extends State<SearchBarSong> {
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<QuerySnapshot>? _searchResultsSubscription;
  String _query = '';
  List<DocumentSnapshot> _searchResults = [];

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
          .orderBy('title')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .snapshots()
          .listen((snapshot) {
        _searchResults = snapshot.docs;
        setState(() {});  // Update the UI
      });
    } else {
      _searchResults = [];
      setState(() {});
    }
  }

  void _startSearch(String value) {
    setState(() {
      _query = value;
    });
    _performSearch(_query);
  }

  void _onButtonPressed(String image, String title, String audio) {
    widget.onDocumentSelected(image);
    widget.onTitleSelected(title);
    widget.onAudioSelected(audio);
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
        ..._searchResults.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final songTitle = data['title'] ?? '';
          final songRef = data['ref'] as DocumentReference;
          return FutureBuilder<DocumentSnapshot>(
            future: songRef.get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('Song not found');
              }
              final songData = snapshot.data!.data() as Map<String, dynamic>;
              final imageUrls = songData['image_urls'];
              final imageUrl = imageUrls[1];
              final songArtist = songData['artists'];
              
              // Wait until image is loaded with precacheImage
              return FutureBuilder<void>(
                future: precacheImage(NetworkImage(imageUrl), context),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return CircularProgressIndicator(); // Display loading indicator while image is loading
                  }
                  return InkWell(
                    onTap: () => _onButtonPressed(songData['image_urls'][1], songTitle, songData['image_urls'][0]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Image.network(
                            imageUrl,
                            width: GlobalVariables.largeSize,
                            height: GlobalVariables.largeSize,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: GlobalVariables.smallSpacing),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericTextReg(text: songTitle),
                              const SizedBox(height: GlobalVariables.smallSpacing - 10) ,
                              GenericTextReg(text: songArtist),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ],
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

class BioPreview extends StatefulWidget {

  final String userID;

  BioPreview( { required this.userID } );

  @override _BioPreviewState createState() => _BioPreviewState();

}

class _BioPreviewState extends State<BioPreview> {
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    Map<String, dynamic> data = {};

    
    var usernameMap = await FirebaseComponents().getSpecificData(documentPath: 'users/${widget.userID}', fields: ['user_id']);
    var bioMap = await FirebaseComponents().getSpecificData(documentPath: 'users/${widget.userID}/bio/story', fields: ['title', 'story', 'image_urls', 'timestamp']);
    
    data.addAll(usernameMap);
    data.addAll(bioMap);



    return data;
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<Map<String, dynamic>>(
    future: futureData,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();  // Show a loading indicator while waiting for data.
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');  // Show an error message if something went wrong.
      } else {
        // If the Future completed with data, display it in your UI.
        Map<String, dynamic> data = snapshot.data!;
        return Stack(
          children: <Widget>[
            // The background image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                data['image_urls'][0],
                width: GlobalVariables.properWidth,
                height: 250, // Set height to 200
                fit: BoxFit.cover,
              ),
            ),
            // The shadow gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: GlobalVariables.properWidth,
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // The overlaying text
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: GlobalVariables.smallSpacing, top: 125, right: GlobalVariables.smallSpacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Aligns column children towards the end
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // The title
                    TitleText(text: data['title']),
                    const SizedBox(height: GlobalVariables.smallSpacing),  // Add spacing between the title and its description.
                    // The story preview, limited to 2 lines
                    Text(
                      data['story'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white), 
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    },
  );
}




}


/* 

Boiler Plate

class BioPreview extends StatefulWidget {

  final String collectionPath;
  final Function(List<String>) onTagsChanged;

  BioPreview({required this.collectionPath, required this.onTagsChanged});

  @override _BioPreviewState createState() => _BioPreviewState();

}

class  _BioPreviewState extends State<BioPreview> {

  // create a data set to hold all values
  late Map<String, dynamic> data;

  // init state
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    // Use your data to build your widget here.
    return Container();  // Replace with your actual widget.
  }
}

*/
















