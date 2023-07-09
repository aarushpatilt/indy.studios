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
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 50,
        color: Colors.white,
      ),
    );
  }
}

class SubTitleText extends StatelessWidget {
  final String text;

  const SubTitleText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis, // Add this line
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 35,
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
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300,
        fontSize: 15,
        color: Colors.white,
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
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}

class GenericTextSemi extends StatelessWidget {
  final String text;

  const GenericTextSemi ({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}

class GenericTextReg extends StatelessWidget {
  final String text;

  const GenericTextReg ({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}

class ProfileText400 extends StatelessWidget {
  final String text;
  final double size;

  const ProfileText400 ({
    Key? key,
    required this.text,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: size,
        color: Colors.white,
      ),
    );
  }
}

class ProfileText500 extends StatelessWidget {
  final String text;
  final double size;

  const ProfileText500 ({
    Key? key,
    required this.text,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: size,
        color: Colors.white,
      ),
    );
  }
}

class ProfileText600 extends StatelessWidget {
  final String text;
  final double size;

  const ProfileText600 ({
    Key? key,
    required this.text,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: size,
        color: Colors.white,
      ),
    );
  }
}

class GenericTextSmall extends StatelessWidget {
  final String text;

  const GenericTextSmall({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: Colors.white,
      ),
    );
  }
}

class GenericTextSmallDark extends StatelessWidget {
  final String text;

  const GenericTextSmallDark({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }
}

class GenericTextRegSmall extends StatelessWidget {
  final String text;

  const GenericTextRegSmall ({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300,
        fontSize: 15,
        color: Colors.white,
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
    return Container (
      width: width,
      child: TextFormField(
        controller: controller, // Assigned the TextEditingController
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: false,
          helperText: '',

          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
           
          ),

          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5), // Update this line
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

  const ParagraphTextField({
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
            width: 0.5, // specified the border width
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 0.5, // specified the border width
          ),
        ),
      ),
    );
  }
}

class TransparentCircleWithBorder extends StatelessWidget {

  const TransparentCircleWithBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10, // Adjust the size of the circle as needed
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
    );
  }
}







