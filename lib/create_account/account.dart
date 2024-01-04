import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/create_account/choice.dart';
import 'package:ndy/global/backend.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';
import 'package:ndy/global/inputs.dart';
import 'package:ndy/global/shared.dart';
import 'package:ndy/global/uploads.dart';
import 'package:uuid/uuid.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
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
                    'sign up',
                    style: TextStyle(
                      fontSize: Constant.medText,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: Constant.gapSpacing),
                  CircleImagePicker(width: 95, height: 95, strokeColor: Constant.activeColor, onImagePicked: (File imageFile) {
                    profileImage = imageFile;
                  },),
                  const SizedBox(height: Constant.gapSpacing),
                  Container(
                    // Container for CustomTextField
                    child: CustomTextField(
                      controller: Constant.textControllerOne,
                      inputTextColor: Colors.white, 
                      titleText: 'username', 
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
                      titleText: 'bio', 
                      titleTextColor: Colors.white, 
                      underTextColor: Colors.grey, 
                      characterLimitEnabled: true, 
                      characterLimitNum: 100, 
                    ),
                  ),
                  const SizedBox(height: Constant.largeSpacing),        
                  Container(
                    // Container for CustomTextField
                    child: CustomTextField(
                      controller: Constant.textControllerThree,
                      inputTextColor: Colors.white, 
                      titleText: 'link', 
                      titleTextColor: Colors.white,
                      underTextColor: Colors.grey, 
                      characterLimitEnabled: true, 
                      characterLimitNum: 100, 
                    ),
                  ),
                  const SizedBox(height: Constant.mediumSpacing),  
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "3 tags that describe you or your music: ",
                      style: TextStyle(
                        fontSize: Constant.smallText,
                        color: Constant.activeColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: Constant.mediumSpacing),  
                  TagComponent(title: "tags", icon: Icons.circle, finalTags: (finalTags) {
                    setState(() {
                      tags = finalTags;
                      print(tags);
                    });
                  },)
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

            String? uuid = await SharedData().getUserUuid();

            Map<String, dynamic> data = {

              "username": Constant.textControllerOne.text,
              "bio": Constant.textControllerTwo.text,
              "link": Constant.textControllerThree.text,
              "images" : [null],
              "tags" : tags
            };

            List<String> url = await FirebaseBackend().uploadFiles([profileImage!], 'users/uuid'); //change in final production
            data['images'] = url;

            await FirebaseBackend().updateDocumentInFirestore('users/', uuid!, data);
            
            SharedData().saveUsername(Constant.textControllerOne.text);

            Constant.textDispose();

            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChoiceView()));
          },
        ),
      ),
    );
  }
}
