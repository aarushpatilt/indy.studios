import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/create_account/songupload.dart';
import 'package:ndy/global/backend.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';
import 'package:ndy/global/inputs.dart';
import 'package:ndy/global/shared.dart';
import 'package:ndy/global/uploads.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class AlbumUpload extends StatefulWidget {
  const AlbumUpload({super.key});

  @override
  _AlbumUploadState createState() => _AlbumUploadState();
}

class _AlbumUploadState extends State<AlbumUpload> {
  File? profileImage; // Changed to nullable File and moved into state class
  List<String>? tags;
  File? musicFile;
  String musicName = "";

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
                  const Text(
                    'upload',
                    style: TextStyle(
                      fontSize: Constant.medText,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Expanded( // Wrap the rest of the content in an Expanded
                    child: SingleChildScrollView( // Wrap the content in a SingleChildScrollView
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: Constant.largeSpacing),
                          RectangleImagePicker(
                            width:  MediaQuery.of(context).size.width * 0.95,
                            height:  MediaQuery.of(context).size.width * 0.95,
                            strokeColor: Constant.activeColor,
                            onImagePicked: (File imageFile) {
                              profileImage = imageFile;
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
                          const SizedBox(height: Constant.gapSpacing), 
                          CustomButton(
                              borderColor: Colors.transparent, // Example color, change as needed
                              textColor: Constant.activeColor, // Example color, change as needed
                              titleText: 'done', // Button title text
                              onPressed: () async {

                                String? uuid = await SharedData().getUserUuid();
                                String? username = await SharedData().getUsername();
                                String album_uuid = const Uuid().v4();

                                Map<String, dynamic> data = {

                                  "uuid" : album_uuid,
                                  "title": Constant.textControllerOne.text,
                                  "description": Constant.textControllerThree.text,
                                  "tags" : tags,
                                  "images" : [null],
                                  "type" : "album"
                                };

                                List<String> url = await FirebaseBackend().uploadFiles([profileImage!], 'users/${uuid!}'); 
                                data['images'] = url;


                                await FirebaseBackend().addDocumentToFirestoreWithId('users/${uuid!}/music/', album_uuid, data);

                                Constant.textDispose();

                                // ignore: use_build_context_synchronously
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SongUpload(collectionPath: 'users/${uuid!}/music/${album_uuid}/songs', type: "album", album_uuid: album_uuid,)));
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
