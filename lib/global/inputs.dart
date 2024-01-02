import 'package:flutter/material.dart';
import 'package:ndy/global/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color inputTextColor;
  final String titleText;
  final Color titleTextColor;
  final Color inactiveColor;
  final Color activeColor;
  final bool characterLimitEnabled;
  final int characterLimitNum;
  final Color underTextColor;

  const CustomTextField({
    required this.controller,
    required this.inputTextColor,
    required this.titleText,
    required this.titleTextColor,
    this.inactiveColor = Constant.inactiveColor,
    this.activeColor = Constant.activeColor,
    this.characterLimitEnabled = false,
    this.characterLimitNum = 0,
    required this.underTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: TextStyle(fontSize: Constant.smallMedText, color: titleTextColor),
        ),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: Constant.medText, color: inputTextColor),
          cursorColor: activeColor,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: inactiveColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: activeColor),
            ),
            // Additional styling can be added here
          ),
          maxLength: characterLimitEnabled ? characterLimitNum : null,
        ), // Conditionally display the limit text
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color borderColor;
  final Color textColor;
  final String titleText;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.borderColor,
    required this.textColor,
    required this.titleText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: Colors.transparent,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      child: Text(
        titleText,
        textAlign: TextAlign.center, // Ensure the title is centered
      ),
    );
  }
}
