// User deciedes between Sign In or Sign Up
import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';


class UserAuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: const Icon(Icons.brightness_low_outlined, size: 15),
        title: const Text('@indie.app.studios', style: TextStyle(fontSize: 15)),
        // AppBar Modifiers
        backgroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Padding(
        // Padding
        padding: const EdgeInsets.only(top: GlobalVariables.smallSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),
        child: Align(
          // Alignment
          alignment: Alignment.topLeft,
          child: Column(
            // Pushes text to left
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const TitleText(text: 'Welcome'),
              const SizedBox(height: 15),

              const Row(
                children: [

                  TitleText(text: 'to'),
                  SizedBox(width: 15),
                  Text('Studios', style: TextStyle(fontSize: 50, color: Colors.white, decoration: TextDecoration.underline))
                ],
              ),
              // Add more body content here if needed
              const SizedBox(height: 45),

              const DescriptorText(text: 'A groundbreaking platform and disruptive marketing to reshape the way the world discovers talent'),       
              SizedBox(height: GlobalVariables.properHeight / 2.75),

              Container(

                width: GlobalVariables.properWidth,

                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    ClearButton(text: 'Sign In', width: GlobalVariables.properWidth, onPressed: () {}),
                    const SizedBox(height: 10),

                    WhiteButton(text: 'Sign Up', width: GlobalVariables.properWidth, onPressed: () { GlobalVariables.instance.openSignUpSheet(context); }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


