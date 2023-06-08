import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

class ArtistUploadView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // No return to previous screen
      appBar: const HeaderPrevious(text: "artist"),

      
      body: Padding (

        padding: const EdgeInsets.only(top: GlobalVariables.largeSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),

        child: Align (

          alignment: Alignment.topLeft,

          child: Column (

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // mood view
              const TitleText(text: "Music"),
              const SizedBox(height: GlobalVariables.smallSpacing),
              const TitleText(text: "Upload"),
              const SizedBox(height: GlobalVariables.largeSpacing),
              const DescriptorText(text: "Upload one single and one album with a piece of music"),

              SizedBox(height: GlobalVariables.properHeight / 2.75),

              Container(

                width: GlobalVariables.properWidth,

                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    ClearButton(text: 'Artist', width: GlobalVariables.properWidth, onPressed: () { Navigator.push( context, MaterialPageRoute(builder: (context) => ArtistUploadView()), );}),
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