import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';

import 'package:flutter/material.dart';

class SearchTagView extends StatefulWidget {

  final Function(List<String>) finalTags;

  const SearchTagView({super.key, required this.finalTags});

  @override
  _SearchTagViewState createState() => _SearchTagViewState();
}

class _SearchTagViewState extends State<SearchTagView> {
  // Create a List<String> called tags
  List<String> tags = [];

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                CustomAppBar(data: [], title: "tags", titleColor: Constant.activeColor, titleSize: Constant.smallMedText, iconColor: Constant.activeColor, iconSize: Constant.smallMedText),
                const SizedBox(height: Constant.largeSpacing),
                CustomSearchBar(rectangleColor: Constant.inactiveColor, title: "tag", titleColor: Constant.activeColor, titleSize: Constant.smallMedText, onTagsUpdated: (updatedTags) {
                  setState(() {
                    tags = updatedTags;
                    print("HEY");
                    print(tags);
                    widget.finalTags(tags);
                  });

                  
                },),
                // Other widgets can be added here to interact with 'tags'
              ],
            ),
          ),
        ),
      ),
    );
  }
}
