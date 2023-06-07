// Text Pre Sets
import 'package:flutter/material.dart';

// Title ( largest )
class TitleText extends StatelessWidget {
  final String text;

  const TitleText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 50,
        color: Colors.white,
      ),
    );
  }
}

class TitleTextDark extends StatelessWidget {
  final String text;

  const TitleTextDark({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 50,
        color: Colors.black,
      ),
    );
  }
}
// Title Descriptor 
class DescriptorText extends StatelessWidget {
  final String text;

  const DescriptorText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }
}

// Information Text
class InformationText extends StatelessWidget {
  final String text;

  const InformationText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.grey,
      ),
    );
  }
}

// Generic Text
class GenericText extends StatelessWidget {
  final String text;

  const GenericText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}

class GenericTextDark extends StatelessWidget {
  final String text;

  const GenericTextDark({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }
}

// Clear textfield
class ClearFilledTextField extends StatelessWidget {
  final String labelText;
  final double width;
  final TextEditingController controller; // Added TextEditingController property

  const ClearFilledTextField({
    Key? key,
    required this.labelText,
    required this.width,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextFormField(
        controller: controller, // Assigned the TextEditingController
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: false,
          helperText: '',

          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),

          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class ParagraphTextField extends StatelessWidget {

  final String text;
  final TextEditingController controller; 

  const ParagraphTextField ({
    Key? key,
    required this.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}





