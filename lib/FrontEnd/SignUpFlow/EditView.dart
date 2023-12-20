import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../FrontEndComponents/ButtonComponents.dart';
import 'ProfileCreationView.dart';

class EditView extends StatefulWidget {
  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  late Future<Map<String, dynamic>> specificData;

  @override
  void initState() {
    super.initState();
    specificData = FirebaseComponents().getSpecificData(documentPath: 'users/${GlobalVariables.userUUID}');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPrevious(text: 'PERSONAL INFO'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: specificData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            GlobalVariables.inputOne.text = snapshot.data['first_name'];
            GlobalVariables.inputTwo.text = snapshot.data['last_name'];
            GlobalVariables.inputThree.text = snapshot.data['email_address'];
            GlobalVariables.inputFour.text = snapshot.data['password'];
            return Padding(
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
                        String uuid = GlobalVariables.userUUID;
                        Map<String, dynamic> data = {

                          "UUID": uuid,
                          "first_name" : GlobalVariables.inputOne.text,
                          "last_name" : GlobalVariables.inputTwo.text,
                          "email_address" : GlobalVariables.inputThree.text,
                          "password": GlobalVariables.inputFour.text,
                        };
                        
                        FirebaseComponents().updatePassword( snapshot.data['email_address'], snapshot.data['password'], GlobalVariables.inputFour.text).then((result) {
                          if (result) {
                            FirebaseComponents().updateEmail(GlobalVariables.inputThree.text, snapshot.data['password'], snapshot.data['email_address']).then((result) {
                              if (result){
                                FirebaseComponents().updateEachDataToFirestore('/users/$uuid', data).then ( (result) {
                                  if (result) {
                                    GlobalVariables.userUUID = uuid;
                                    GlobalVariables().disposeInputs();
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            });
                          }
                        });
                      }
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

