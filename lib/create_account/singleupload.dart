import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/global/backend.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';
import 'package:ndy/global/inputs.dart';
import 'package:ndy/global/uploads.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class SingleUpload extends StatefulWidget {
  const SingleUpload({super.key});

  @override
  _SingleUploadState createState() => _SingleUploadState();
}

class _SingleUploadState extends State<SingleUpload> {
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
                    'sign up',
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
                            width: 350,
                            height: 350,
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
                              titleText: 'artists', 
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
                              characterLimitNum: 100, 
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

                                String uuid = const Uuid().v4();

                                Map<String, dynamic> data = {

                                  "username": Constant.textControllerOne.text,
                                  "bio": Constant.textControllerTwo.text,
                                  "link": Constant.textControllerThree.text,
                                  "images" : [null],
                                  "tags" : tags
                                };

                                List<String> url = await FirebaseBackend().uploadImages([profileImage!], 'users/uuid'); //change in final production
                                data['images'] = url;

                                await FirebaseBackend().addDocumentToFirestoreWithId('users', uuid, data);

                                Constant.textDispose();

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