import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../FrontEndComponents/ButtonComponents.dart';
import 'ProfileCreationView.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPrevious(text: 'CREATE'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClearFilledTextField(labelText: "First name", width: GlobalVariables.properWidth, controller: GlobalVariables.inputOne),
                const SizedBox(height: GlobalVariables.smallSpacing),
                ClearFilledTextField(labelText: "Last name", width: GlobalVariables.properWidth, controller: GlobalVariables.inputTwo),
                const SizedBox(height: GlobalVariables.smallSpacing),
                ClearFilledTextField(labelText: "Email address", width: GlobalVariables.properWidth, controller: GlobalVariables.inputThree),
                const SizedBox(height: GlobalVariables.smallSpacing),
                ClearFilledTextField(labelText: "Password", width: GlobalVariables.properWidth, controller: GlobalVariables.inputFour),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: ClearButton(
                text: "CONTINUE", 
                width: GlobalVariables.properWidth, 
                onPressed: () { 
                  String uuid = GlobalVariables().generateUUID();
                  // Data
                  Map<String, dynamic> data = {
                    "UUID": uuid,
                    "first_name" : GlobalVariables.inputOne.text,
                    "last_name" : GlobalVariables.inputTwo.text,
                    "email_address" : GlobalVariables.inputThree.text,
                    "password": GlobalVariables.inputFour.text,
                    "stats" : [ 0, 0, 0, 0]
                  };
                    
                  FirebaseComponents().signUp(GlobalVariables.inputThree.text, GlobalVariables.inputFour.text).then( (result) {
                    if (result) {
                      FirebaseComponents().setEachDataToFirestore('/users/$uuid', data).then ( (result) {
                        if (result) {
                          GlobalVariables.userUUID = uuid;
                          GlobalVariables().disposeInputs();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileCreationView()));
                        }
                      }); 
                    }
                  });    
                } // closing parenthesis for the onPressed method
              ), // closing parenthesis for the ClearButton
            ),
          ],
        ),
      ),
    );
  }
}
