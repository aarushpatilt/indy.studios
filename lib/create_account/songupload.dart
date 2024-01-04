import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/global/backend.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';
import 'package:ndy/global/inputs.dart';
import 'package:ndy/global/shared.dart';
import 'package:ndy/global/uploads.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class SongUpload extends StatefulWidget {

  final String collectionPath;
  final String type;
  final String? album_uuid;

  const SongUpload({super.key, required this.collectionPath, required this.type, this.album_uuid});

  @override
  _SongUploadState createState() => _SongUploadState();
}

class _SongUploadState extends State<SongUpload> {
  File? profileImage; // Changed to nullable File and moved into state class
  List<String>? tags;
  File? musicFile;
  String musicName = "";
  Future<String?>? imageCover;

  @override
  void initState() {
    super.initState();
    if(widget.album_uuid != null){
      imageCover = _getImageCover();
    }
    
  }
  Future<String?> _getImageCover() async {
    String? uuid = await SharedData().getUserUuid();
    Map<String, dynamic> image_map = await FirebaseBackend().getSpecificFieldsFromDocument('users/$uuid/music/', widget.album_uuid!, ['images']);
    
    return image_map['images'][0] as String;
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Align(
            alignment: Alignment.topCenter, // Center the contents within the padded area
            child: Container(
              color: Colors.transparent, // Red rectangle
              child: Column(
                mainAxisSize: MainAxisSize.min, // Makes the column wrap its content
                children: [
                  const SizedBox(height: Constant.mediumSpacing),
                   CustomAppBar(
                    data: [], title: "select", titleColor: Constant.activeColor, titleSize: Constant.medText, iconColor: Constant.activeColor, iconSize: Constant.medText),
                  Expanded( // Wrap the rest of the content in an Expanded
                    child: SingleChildScrollView( // Wrap the content in a SingleChildScrollView
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: Constant.largeSpacing),
                          FutureBuilder<String?>(
                            future: imageCover,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Or some other loading indicator
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                return Image.network(
                                  snapshot.data!,
                                  width: 350,
                                  height: 350,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return RectangleImagePicker(
                                  width: 350,
                                  height: 350,
                                  strokeColor: Constant.activeColor,
                                  onImagePicked: (File imageFile) {
                                    profileImage = imageFile;
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(height: Constant.largeSpacing),
                          Container(
                    // Container for CustomTextField
                            child: CustomTextField(
                              controller: Constant.textControllerOne,
                              inputTextColor: Colors.white, 
                              titleText: 'title', 
                              titleTextColor: Colors.white, 
                              underTextColor: Colors.grey, 
                              characterLimitEnabled: true, 
                              characterLimitNum: 25, 
                            ),
                          ),
                          const SizedBox(height: Constant.largeSpacing),
                          Container(
                    // Container for CustomTextField
                            child: CustomTextField(
                              controller: Constant.textControllerTwo,
                              inputTextColor: Colors.white, 
                              titleText: 'additional artists', 
                              titleTextColor: Colors.white, 
                              underTextColor: Colors.grey, 
                              characterLimitEnabled: true, 
                              characterLimitNum: 75, 
                            ),
                          ),
                          const SizedBox(height: Constant.largeSpacing),
                          Container(
                            // Container for CustomTextField
                            child: CustomTextField(
                              controller: Constant.textControllerThree,
                              inputTextColor: Colors.white, 
                              titleText: 'description', 
                              titleTextColor: Colors.white, 
                              underTextColor: Colors.grey, 
                              characterLimitEnabled: true, 
                              characterLimitNum: 200, 
                            ),
                          ),
                          const SizedBox(height: Constant.mediumSpacing), 
                          TagComponent(title: "tags", icon: Icons.circle, finalTags: (finalTags) {
                            setState(() {
                              tags = finalTags;
                            });
                          },),
                          const SizedBox(height: Constant.largeSpacing), 
                          MusicUpload(title: "music upload", icon: Icons.circle, onFileSelected: (File bruh) { 
                            setState(() {
                              musicFile = bruh;
                              musicName = musicFile!.path.split('/').last;
                              print(musicName);
                            });
                           },),
                          const SizedBox(height: Constant.smallSpacing), 
                          Text(musicName, style: const TextStyle(color: Constant.activeColor, fontSize: Constant.smallMedText)),
                          const SizedBox(height: Constant.smallSpacing),  
                          CustomButton(
                              borderColor: Colors.transparent, // Example color, change as needed
                              textColor: Constant.activeColor, // Example color, change as needed
                              titleText: 'done', // Button title text
                              onPressed: () async {

                                String? uuid = await SharedData().getUserUuid();
                                String? username = await SharedData().getUsername();
                                String single_uuid = Uuid().v4();

                                Map<String, dynamic> data = {
                                  "uuid" : single_uuid,
                                  "title": Constant.textControllerOne.text,
                                  "artists": username! + " " + Constant.textControllerTwo.text,
                                  "description": Constant.textControllerThree.text,
                                  "tags" : tags,
                                  "images" : [null],
                                  "music" : [null],
                                  "type": widget.type
                                };

                                List<String> url = await FirebaseBackend().uploadFiles([profileImage!], 'users/${uuid}'); 
                                data['images'] = url;

                                List<String> musicUrl = await FirebaseBackend().uploadFiles([musicFile!], 'users/${uuid}'); 
                                data['music'] = musicUrl;

                                await FirebaseBackend().addDocumentToFirestoreWithId(widget.collectionPath, single_uuid, data);

                                Constant.textDispose();

                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, ["Complete"]);

                                // ignore: use_build_context_synchronously
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                              },
                            ),
                        ],

                      ),
                    ),
                    
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
