import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/ProfileCreationView.dart';
import 'package:ndy/FrontEnd/TextComponents.dart';
import 'ButtonComponents.dart';

class SignUpView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const HeaderPrevious(text: 'create'),
      body: Padding(
        
        padding: const EdgeInsets.only(top: GlobalVariables.largeSpacing, left: GlobalVariables.horizontalSpacing, right: GlobalVariables.horizontalSpacing),
        child: Align (

          alignment: Alignment.topLeft,
          
          child: Column (

            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [

              const TitleText(text: "Create"),
              const SizedBox(height: GlobalVariables.smallSpacing),
              const TitleText(text: "Account"),
              const SizedBox(height: GlobalVariables.largeSpacing),
              const DescriptorText(text: "general information needed before creating your platform"),
              const SizedBox(height: GlobalVariables.largeSpacing),

              Row (

                children: [

                  ClearFilledTextField(labelText: "First name", width: (GlobalVariables.properWidth - (GlobalVariables.smallSpacing * 4)) / 2, controller: GlobalVariables.inputOne),
                  const SizedBox(width: GlobalVariables.smallSpacing),
                  ClearFilledTextField(labelText: "Last name", width: (GlobalVariables.properWidth - (GlobalVariables.smallSpacing * 4)) / 2, controller: GlobalVariables.inputTwo),
                ],
              ),
              const SizedBox(height: GlobalVariables.smallSpacing),
              ClearFilledTextField(labelText: "Email address",  width: (GlobalVariables.properWidth), controller: GlobalVariables.inputThree),
              const SizedBox(height: GlobalVariables.smallSpacing),
              ClearFilledTextField(labelText: "Password",  width: (GlobalVariables.properWidth), controller: GlobalVariables.inputFour),
              SizedBox(height: GlobalVariables.properHeight / 10),
              ClearButton(text: "Complete", width: (GlobalVariables.properWidth), onPressed: () { 

                String uuid = GlobalVariables().generateUUID();
                // Data
                Map<String, dynamic> data = {
                  "UUID": uuid,
                  "first_name" : GlobalVariables.inputOne.text,
                  "last_name" : GlobalVariables.inputTwo.text,
                  "email_address" : GlobalVariables.inputThree.text,
                  "password": GlobalVariables.inputFour.text,
                };
                  
                  
                FirebaseComponents().signUp(GlobalVariables.inputThree.text, GlobalVariables.inputFour.text).then( (result) {

                  if (result) {

                    FirebaseComponents().setEachDataToFirestore('/users/$uuid', data).then ( (result)  {

                      if (result) {
                        
                        GlobalVariables.userUUID = uuid;
                        GlobalVariables().disposeInputs();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileCreationView()));
                      }
                    }); 
                  }
                });    
              }), 
            ],
          )
        )
        // Add your sign-up view content here
      ),
    );
  }
}
