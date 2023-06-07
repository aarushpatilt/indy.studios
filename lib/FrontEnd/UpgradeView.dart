import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/ButtonComponents.dart';
import 'package:ndy/FrontEnd/TextComponents.dart';

class UpgradeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // No return to previous screen
      appBar: AppBar(

        leading: const Icon(Icons.brightness_low_outlined, size: 15),
        title: const Text('@indie.app.studios', style: TextStyle(fontSize: 15)),
        // AppBar Modifiers
        backgroundColor: Colors.black,
        centerTitle: false,
      ),

      
      body: const Padding (

        padding: EdgeInsets.only(top: GlobalVariables.largeSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),

        child: Align (

          alignment: Alignment.topLeft,

          child: Column (

            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [

              TitleText(text: "Artist"),
              SizedBox(height: GlobalVariables.smallSpacing),
              TitleText(text: "or Listener?")
            ],
          )
        )
      )
    );
  }
}