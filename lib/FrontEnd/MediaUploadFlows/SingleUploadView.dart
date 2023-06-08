import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

class SingleUploadView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      // No return to previous screen
      appBar: const HeaderPrevious(text: "singles"),

      
      body: Padding (

        padding: const EdgeInsets.only(top: GlobalVariables.largeSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),

        child: Align (

          alignment: Alignment.topLeft,

          child: Column (

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              RectanglePictureSelector(size: GlobalVariables.properWidth, color: Colors.transparent, onImageSelected: (File file) {

                  GlobalVariables.mediaOne = file;
                }
              ),

              const SizedBox(height: GlobalVariables.mediumSpacing),

              const Row (

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  GenericText(text: "tags"),

                  Icon(

                    Icons.search,
                    color: Colors.white,
                    size: 15,
                  ) 
                ],
              ),
              
              const SizedBox(height: GlobalVariables.smallSpacing),

              ClearFilledTextField(labelText: "title ", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),
              ClearFilledTextField(labelText: "artists ", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),

              
            ],
          )
        )
      )
    );
  }
}