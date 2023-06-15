import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

class MusicDiscoverView extends StatelessWidget {

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

      
      body: Padding (

        padding: const EdgeInsets.only(top: GlobalVariables.largeSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),

        child: Align (

          alignment: Alignment.topLeft,

          child: Column (

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // mood view
              const TitleText(text: "Artist"),
              const SizedBox(height: GlobalVariables.smallSpacing),
              const TitleText(text: "or Listener?"),
              const SizedBox(height: GlobalVariables.largeSpacing),
              const DescriptorText(text: "You must have atleast one single and one album with a minimum of one song for the artist role."),

              SizedBox(height: GlobalVariables.properHeight / 2.75),

              Container(

                width: GlobalVariables.properWidth,

                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    ClearButton(text: 'Artist', width: GlobalVariables.properWidth, onPressed: () {}),
                    const SizedBox(height: 10),

                    WhiteButton(text: 'Listener', width: GlobalVariables.properWidth, onPressed: () { GlobalVariables.instance.openSignUpSheet(context); }),
                  ],
                ),
              )
            ],



          )
        )
      )
    );
  }
}