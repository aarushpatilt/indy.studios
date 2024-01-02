import 'package:flutter/material.dart';

class Constant {

  static const Color mainColor = Colors.pink;
  static const Color backgroundColor = Colors.black;
  static const Color activeColor = Colors.white;
  static const Color inactiveColor = Color.fromARGB(255, 48, 48, 48);

  static const double smallText = 10;
  static const double smallMedText = 12;
  static const double medText = 15;
  static const double medLargeText = 18;
  static const double largeText = 20;

  static const double smallSpacing = 10;
  static const double mediumSpacing = 15;
  static const double largeSpacing = 20;
  static const double largePlusSpacing = 25;
  static const double gapSpacing = 50;

  static final TextEditingController textControllerOne = TextEditingController();
  static final TextEditingController textControllerTwo = TextEditingController();
  static final TextEditingController textControllerThree = TextEditingController();
  static final TextEditingController textControllerFour = TextEditingController();
  static final TextEditingController textControllerFive = TextEditingController();

  static void textDispose() {
    textControllerOne.clear();
    textControllerTwo.clear();
    textControllerThree.clear();
    textControllerFour.clear();
    textControllerFive.clear();
  }


}
