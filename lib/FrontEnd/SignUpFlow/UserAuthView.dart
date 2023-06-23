// User deciedes between Sign In or Sign Up
import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

class UserAuthView extends StatelessWidget {

  const UserAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://media4.giphy.com/media/3oGRFmRn07P3Vc5t7y/giphy.gif?cid=ecf05e47ni7vhiiv1rtoo3w6zkuxbre18xrhh3vacub5o05b&rid=giphy.gif&ct=g'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
          child: Stack(
            children: [
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GenericTextReg(text: "INDY"),
                    SizedBox(height: GlobalVariables.smallSpacing),
                    GenericTextReg(text: "Take your photography"),
                    GenericTextReg(text: "to the next level"),
                  ],
                ),
              ),
              Positioned(
                left: GlobalVariables.horizontalSpacing,
                right: GlobalVariables.horizontalSpacing,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: SizedBox(
                    width: GlobalVariables.properWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClearButton(text: 'SIGN IN', width: GlobalVariables.properWidth, onPressed: () {}),
                        const SizedBox(height: 10),
                        WhiteButton(text: 'SIGN UP', width: GlobalVariables.properWidth, onPressed: () { GlobalVariables.instance.openSignUpSheet(context); }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
