// Global variables used for the application

// Single Instance Class

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEnd/SignUpFlow/SignUpView.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '../FrontEndComponents/TextComponents.dart';
import 'FirebaseComponents.dart';

class GlobalVariables {
  // Single instance
  static final GlobalVariables _instance = GlobalVariables._internal();
  static GlobalVariables get instance => _instance;

  factory GlobalVariables() => _instance;

  GlobalVariables._internal();

  final String baseColor = '#000000';
  final String textColor = '#FFFFFF';
  // Screen size
  static double properWidth = _getProperWidth();
  static double properHeight = _getProperHeight();
  // Spacing
  static const double smallSpacing = 20;
  static const double mediumSpacing = 35;
  static const double largeSpacing = 65;
  static const double horizontalSpacing = 20;
  // Sizing
  static const double smallSize = 15;
  static const double mediumSize = 30;
  static const double largeSize = 45;
  static const double largerSize = 50;
  // Inputs
  static final inputOne = TextEditingController();
  static final inputTwo = TextEditingController();
  static final inputThree = TextEditingController();
  static final inputFour = TextEditingController();
  static final inputFive = TextEditingController();
  static final inputSix = TextEditingController();
  // uuid
  static var userUUID = '86462c92-9908-463f-b307-438c2456f181';
  // Media
  static File? mediaOne;
  static File? mediaTwo;
  static File? mediaThree;
  // Genres
  


  static double _getProperWidth() {
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
  }

  static double _getProperHeight() {
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;
  }

  String generateUUID() {
    final uuid = Uuid();
    return uuid.v4();
  }

  // Refreshes inputs
  void disposeInputs(){

    inputOne.text = "";
    inputTwo.text = "";
    inputThree.text = "";
    inputFour.text = "";
    inputFive.text = "";
    inputSix.text = "";
  }

  // Refreshes media
  // void disposeMedia() {

  //   mediaOne = null;
  //   mediaTwo = null;
  //   mediaThree = null;
  // }
  
  
  void openSignUpSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(

        height: GlobalVariables.properHeight / 2,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),

        child: Align(

          alignment: Alignment.topLeft,

          child: Column ( 

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const TitleTextDark(text: 'Sign Up'),
              const SizedBox(height: 10),
              const DescriptorText(text: 'one step closer to having your own platform'),
              const SizedBox(height: 30),
              BlackOutlineButton(text: 'Email', width: GlobalVariables.properWidth, 
                onPressed: () { Navigator.push( context, MaterialPageRoute(builder: (context) => SignUpView()), ); }),
              const SizedBox(height: 10),
              BlackOutlineButton(text: 'Google', width: GlobalVariables.properWidth, onPressed: () {}),
              const SizedBox(height: 10),
              BlackOutlineButton(text: 'Coming Soon', width: GlobalVariables.properWidth, onPressed: () {}),
              const SizedBox(height: 40),
              const Align( 
                
                alignment: Alignment.center,
                child: GenericTextDark(text: 'more options coming soon!'),
              ),
            ]
          ),
        ),
      );
    },
  );
  }

  // users/${GlobalVariables.userUUID}
  // artists/${GlobalVariables.userUUID}/profile
  void uploadMixedData(BuildContext context, String dataPath, String mediaPath, Widget nextView, Map<String, dynamic> data, Map<String, File> mediaData){


    FirebaseComponents().setEachDataToFirestore(dataPath, data).then( (result) {

      if (result) {

        // FirebaseComponents().setEachMediaToStorage(mediaPath, mediaData).then( (result) {

        //   if (result) {

        //     GlobalVariables().disposeInputs();
        //     //GlobalVariables().disposeMedia();
            
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => nextView),);
        //   }
        // });
        print("lol");
      }
    });
  }
}

 

