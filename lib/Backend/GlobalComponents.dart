// Global variables used for the application

// Single Instance Class

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEnd/SignUpFlow/SignUpView.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '../FrontEnd/MainAppFlows/Profile.dart';
import '../FrontEnd/MediaUploadFlows/TagFinderView.dart';
import '../FrontEndComponents/TextComponents.dart';
import 'FirebaseComponents.dart';

class GlobalVariables {
  // Single instance
  static final GlobalVariables _instance = GlobalVariables._internal();
  static GlobalVariables get instance => _instance;

  factory GlobalVariables() => _instance;

  GlobalVariables._internal();

  final String baseColor = '#000000';
  final String textColor = '#FFFFFF';
  // Screen size
  static double properWidth = _getProperWidth();
  static double properHeight = _getProperHeight();
  // Spacing
  static const double smallSpacing = 20;
  static const double mediumSpacing = 35;
  static const double largeSpacing = 65;
  static const double horizontalSpacing = 15;
  // Sizing
  static const double smallSize = 15;
  static const double mediumSize = 30;
  static const double largeSize = 45;
  static const double largerSize = 50;
  // Inputs
  static final inputOne = TextEditingController();
  static final inputTwo = TextEditingController();
  static final inputThree = TextEditingController();
  static final inputFour = TextEditingController();
  static final inputFive = TextEditingController();
  static final inputSix = TextEditingController();
  // uuid
  static var userUUID = '63da0b53-e51e-43e0-ae2d-441e65373974';
  // Media
  static File? mediaOne;
  static File? mediaTwo;
  static File? mediaThree;
  // Genres
  


  static double _getProperWidth() {
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
  }

  static double _getProperHeight() {
    return MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;
  }

  String generateUUID() {
    final uuid = const Uuid();
    return uuid.v4();
  }

  // Refreshes inputs
  void disposeInputs(){

    inputOne.text = "";
    inputTwo.text = "";
    inputThree.text = "";
    inputFour.text = "";
    inputFive.text = "";
    inputSix.text = "";
  }

  // Refreshes media
  // void disposeMedia() {

  //   mediaOne = null;
  //   mediaTwo = null;
  //   mediaThree = null;
  // }
  
  
  void openSignUpSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(

        height: GlobalVariables.properHeight / 2,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),

        child: Align(

          alignment: Alignment.topLeft,

          child: Column ( 

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const TitleTextDark(text: 'Sign Up'),
              const SizedBox(height: 10),
              const DescriptorText(text: 'one step closer to having your own platform'),
              const SizedBox(height: 30),
              BlackOutlineButton(text: 'Email', width: GlobalVariables.properWidth, 
                onPressed: () { Navigator.push( context, MaterialPageRoute(builder: (context) => SignUpView()), ); }),
              const SizedBox(height: 10),
              BlackOutlineButton(text: 'Google', width: GlobalVariables.properWidth, onPressed: () {}),
              const SizedBox(height: 10),
              BlackOutlineButton(text: 'Coming Soon', width: GlobalVariables.properWidth, onPressed: () {}),
              const SizedBox(height: 40),
              const Align( 
                
                alignment: Alignment.center,
                child: GenericTextDark(text: 'more options coming soon!'),
              ),
            ]
          ),
        ),
      );
    },
  );
  }

  // users/${GlobalVariables.userUUID}
  // artists/${GlobalVariables.userUUID}/profile
  void uploadMixedData(BuildContext context, String dataPath, String mediaPath, Widget nextView, Map<String, dynamic> data, Map<String, File> mediaData){


    FirebaseComponents().setEachDataToFirestore(dataPath, data).then( (result) {

      if (result) {

        // FirebaseComponents().setEachMediaToStorage(mediaPath, mediaData).then( (result) {

        //   if (result) {

        //     GlobalVariables().disposeInputs();
        //     //GlobalVariables().disposeMedia();
            
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => nextView),);
        //   }
        // });
        print("lol");
      }
    });
  }
}

class TagsComponent extends StatefulWidget {
  final void Function(List<String> tags)? onTagsChanged;

  TagsComponent({this.onTagsChanged});

  @override
  _TagsComponentState createState() => _TagsComponentState();
}

class _TagsComponentState extends State<TagsComponent> {
  List<String>? _addedTags;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GlobalVariables.properWidth, // Set the width using GlobalVariables.properWidth
      child: Row(
        children: [
          if (_addedTags != null)
            Row(
              children: [
                for (int i = 0; i < _addedTags!.length; i++) ...[
                  ProfileText400(text: "#" + _addedTags![i], size: 12),
                  const SizedBox(width: 5),
                ],
              ],
            )
          else
            const ProfileText400(text: "TAGS", size: 12),
          const Spacer(), // Adds a spacer widget to create space between text and icon
          GestureDetector(
            onTap: () async {
              final List<String>? selectedTags = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TagFinderView()),
              );
              if (selectedTags != null) {
                setState(() {
                  _addedTags = selectedTags;
                });
                widget.onTagsChanged?.call(selectedTags);
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.search,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class TabSliderMenu extends StatefulWidget {
  final int initialIndex;
  final String userID;  // Assuming that userID is passed from parent to this widget

  TabSliderMenu({this.initialIndex = 0, required this.userID});

  @override
  _TabSliderMenuState createState() => _TabSliderMenuState();
}

class _TabSliderMenuState extends State<TabSliderMenu> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildTabItem('Profile', 0),
              const SizedBox(width: 15),
              buildTabItem('Moods', 1),
            ],
          ),
        ),
        if (selectedIndex == 0) 
          ProfileSubView(userID: widget.userID),
          const SizedBox(height: GlobalVariables.smallSpacing),
        // Add here the widget to display when selectedIndex == 1 for "Moods" tab
        // if (selectedIndex == 1) 
        //   MoodsSubView(userID: widget.userID),
      ],
    );
  }

  Widget buildTabItem(String title, int index) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: GlobalVariables.smallSpacing),
        child: ProfileText400(
          text: title,
          size: 15,
        ),
      ),
    );
  }

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class SearchSliderMenu extends StatefulWidget {
  final int initialIndex;
  final String userID;  // Assuming that userID is passed from parent to this widget

  SearchSliderMenu({this.initialIndex = 0, required this.userID});

  @override
  _SearchSliderMenuState createState() => _SearchSliderMenuState();
}

class _SearchSliderMenuState extends State<SearchSliderMenu> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildTabItem('SONGS', 0),
              buildTabItem('ARTISTS', 1),
              buildTabItem('TAGS', 2),
            ],
          ),
        ),
        if (selectedIndex == 0) 
          SearchBarSong(collectionPath: 'songs', type: 1),
        if (selectedIndex == 1)
          SearchBarUser(collectionPath: 'users')
        // Add here the widget to display when selectedIndex == 1 for "Moods" tab
        // if (selectedIndex == 1) 
        //   MoodsSubView(userID: widget.userID),
      ],
    );
  }

  Widget buildTabItem(String title, int index) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: GlobalVariables.smallSpacing),
        child: ProfileText500(
          text: title,
          size: 10,
        ),
      ),
    );
  }

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class SongImageDisplay extends StatelessWidget {
  final String url;
  final String title;
  final String artists;

  SongImageDisplay({
    required this.url,
    required this.title,
    required this.artists,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: GlobalVariables.smallSpacing - 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileText600(text: title, size: 15,),
              const SizedBox(height: 10),
              ProfileText400(text: artists, size: 15),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.favorite_border, color: Colors.white),
      ],
    );
  }
}
