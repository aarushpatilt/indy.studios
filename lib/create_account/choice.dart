import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/create_account/albumupload.dart';
import 'package:ndy/create_account/songupload.dart';
import 'package:ndy/global/backend.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';
import 'package:ndy/global/inputs.dart';
import 'package:ndy/global/shared.dart';
import 'package:ndy/global/uploads.dart';
import 'package:uuid/uuid.dart';

class ChoiceView extends StatefulWidget {
  const ChoiceView({super.key});

  @override
  _ChoiceViewState createState() => _ChoiceViewState();
}

class _ChoiceViewState extends State<ChoiceView> {
  File? profileImage; // Changed to nullable File and moved into state class
  List<String>? tags;


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
                children: [// Spacing before the title
                  const SizedBox(height: Constant.mediumSpacing),
                  const Text(
                    'select',
                    style: TextStyle(
                      fontSize: Constant.medText,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: Constant.gapSpacing),
                  ArtistComponent(title: "album upload", icon: Icons.circle, navigateTo: (context) => const AlbumUpload(), finalTags: (finalTags) {

                  }),
                  const SizedBox(height: Constant.largeSpacing),
                  ArtistComponent(title: "single upload", icon: Icons.circle, navigateTo: (context) =>  SongUpload(collectionPath: 'users/${SharedData().getUserUuid()}/music', type: "single"), finalTags: (finalTags) {

                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
        child: CustomButton(
          borderColor: Constant.activeColor, // Example color, change as needed
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

            List<String> url = await FirebaseBackend().uploadFiles([profileImage!], 'users/uuid'); //change in final production
            data['images'] = url;

            await FirebaseBackend().addDocumentToFirestoreWithId('users', uuid, data);

            Constant.textDispose();

            // ignore: use_build_context_synchronously
            //Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
          },
        ),
      ),
    );
  }
}
