import 'package:flutter/material.dart';


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate horizontal padding as 2% of the screen width
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Center( // Center the contents within the padded area
          child: Container(
            // Container for additional styling or constraints if needed
            child: Center( // Center the red box within the container
              child: Container(
                height: 50,
                color: Colors.red, // Red rectangle
              ),
            ),
          ),
        ),
      ),
    );
  }
}
