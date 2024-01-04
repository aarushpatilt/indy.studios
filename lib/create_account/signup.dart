import 'package:flutter/material.dart';
import 'package:ndy/create_account/account.dart';
import 'package:ndy/global/backend.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/inputs.dart';
import 'package:ndy/global/shared.dart';
import 'package:uuid/uuid.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
                  Container(
                    // Container for CustomTextField
                    child: CustomTextField(
                      controller: Constant.textControllerOne,
                      inputTextColor: Colors.white, 
                      titleText: 'first name', 
                      titleTextColor: Colors.white, 
                      underTextColor: Colors.grey, 
                      characterLimitEnabled: false, 
                      characterLimitNum: 50, 
                    ),
                  ),
                  const SizedBox(height: Constant.largeSpacing),
                  Container(
                    // Container for CustomTextField
                    child: CustomTextField(
                      controller: Constant.textControllerTwo,
                      inputTextColor: Colors.white, 
                      titleText: 'last name', 
                      titleTextColor: Colors.white, 
                      underTextColor: Colors.grey, 
                      characterLimitEnabled: false, 
                      characterLimitNum: 50, 
                    ),
                  ),
                  const SizedBox(height: Constant.largeSpacing),        
                  Container(
                    // Container for CustomTextField
                    child: CustomTextField(
                      controller: Constant.textControllerThree,
                      inputTextColor: Colors.white, 
                      titleText: 'email', 
                      titleTextColor: Colors.white,
                      underTextColor: Colors.grey, 
                      characterLimitEnabled: false, 
                      characterLimitNum: 50, 
                    ),
                  ),
                  const SizedBox(height: Constant.largeSpacing), 
                  Container(
                    // Container for CustomTextField
                    child: CustomTextField(
                      controller: Constant.textControllerFour,
                      inputTextColor: Colors.white, 
                      titleText: 'password', 
                      titleTextColor: Colors.white,
                      underTextColor: Colors.grey, 
                      characterLimitEnabled: false, 
                      characterLimitNum: 50, 
                    ),
                  ),
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

            String uuid = const Uuid().v4();

            Map<String, dynamic> data = {

              "UUID": uuid,
              "first_name": Constant.textControllerOne.text,
              "last_name": Constant.textControllerTwo.text,
              "email_address": Constant.textControllerThree.text,
              "password": Constant.textControllerFour.text,
              "stats" : [0, 0, 0, 0],
              "pinned" : [null, null, null]
            };

            await FirebaseBackend().signUp(Constant.textControllerThree.text, Constant.textControllerFour.text);

            await FirebaseBackend().addDocumentToFirestoreWithId('users', uuid, data);

            await SharedData().saveUUID(uuid);
            print(await SharedData().getUserUuid());

            Constant.textDispose();

            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccount()));
          },
        ),
      ),
    );
  }
}
