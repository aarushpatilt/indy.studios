import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MainAppFlows/CameraMultiUploadView.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumCoverUploadView.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import '../Backend/FirebaseComponents.dart';
class OptionsIcon extends StatelessWidget {
  final double size;
  final String postReferencePath;
  final int position;
  final String profileImageURL;

  OptionsIcon({required this.size, required this.postReferencePath, required this.position, required this.profileImageURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.white, size: size),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true, 
            builder: (BuildContext context) {
              return OptionsBottomSheet(postReferencePath: postReferencePath, position: position, profileImageURL: profileImageURL,);
            },
          );
        },
      ),
    );
  }
}

class OptionsBottomSheet extends StatefulWidget {
  final String postReferencePath;
  final int position;
  final String profileImageURL;

  OptionsBottomSheet({required this.postReferencePath, required this.position, required this.profileImageURL});

  @override
  _OptionsBottomSheetState createState() => _OptionsBottomSheetState();
}

class _OptionsBottomSheetState extends State<OptionsBottomSheet> {
  late Future<Map<String, dynamic>> pinnedPaths;

  @override
  void initState() {
    super.initState();
    pinnedPaths = FirebaseComponents().getSpecificData(documentPath: 'users/${GlobalVariables.userUUID}');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight,
      child: Stack(
        children: [
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: screenHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 3),
            child: Wrap(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.profileImageURL,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 35),
                    const ProfileText400(text: 'adding more options soon!', size: 12),
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Column(
                        children: [
                          FutureBuilder<Map<String, dynamic>>(
                            future: pinnedPaths,
                            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                              if (snapshot.hasData) {
                                bool isPinned = (snapshot.data!['pinned'][widget.position] == widget.postReferencePath);
                                return GestureDetector(
                                  child: Row(
                                    children: [
                                      Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                                      SizedBox(width: 15),
                                      ProfileText400(text: isPinned ? "UNPIN" : "PIN", size: 12),
                                    ],
                                  ),
                                  onTap: () async {
                                    isPinned ? await FirebaseComponents().getSpecificData(documentPath: 'users/${GlobalVariables.userUUID}', fields: ['pinned']).then((result) {

                                      List<dynamic> newResult = result['pinned'];
                                      print(newResult);
                                      newResult[widget.position] = '';
                                      print(newResult);
                                      FirebaseComponents().updateSpecificField(documentPath: 'users/${GlobalVariables.userUUID}', newData:  { 'pinned' : newResult });
                                    }) :
                                     FirebaseComponents().setPin(widget.postReferencePath, widget.position);


                                     Navigator.of(context).pop();
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          const SizedBox(height: 35),
                          GestureDetector(
                            child: const Row(
                              children: [
                                Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                                SizedBox(width: 15),
                                ProfileText400(text: "DELETE - coming soon", size: 12),
                              ],
                            ),
                            onTap: () {
                              print("HEY");
                            },
                          ),
                          const SizedBox(height: 35),
                          GestureDetector(
                            child: const Row(
                              children: [
                                Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                                SizedBox(width: 15),
                                ProfileText400(text: "REPORT - coming soon", size: 12),
                              ],
                            ),
                            onTap: () {
                              print("HEY");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class SelectorIcon extends StatelessWidget {
  final double size;
  final String postReferencePath;
  final int position;
  final String profileImageURL;

  SelectorIcon({required this.size, required this.postReferencePath, required this.position, required this.profileImageURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.white, size: size),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true, 
            builder: (BuildContext context) {
              return SelectorBottomSheet(postReferencePath: postReferencePath, position: position, profileImageURL: profileImageURL,);
            },
          );
        },
      ),
    );
  }
}

class SelectorBottomSheet extends StatelessWidget {
  final String postReferencePath;
  final int position;
  final String profileImageURL;

  SelectorBottomSheet({required this.postReferencePath, required this.position, required this.profileImageURL});

@override
Widget build(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;

  return Container(
    height: screenHeight, // 100% of the screen height
    child: Stack(
      children: [
        // This container takes full height. Add any background image or color here
        // Frosted glass effect
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: screenHeight,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // change this to a darker color and adjust opacity
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),

        // Your current content
        Padding(
          padding: EdgeInsets.only(top: screenHeight / 3),
          child: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      profileImageURL, // Your image URL here
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 35),
                  const ProfileText400(text: 'adding more options soon!', size: 12),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: const Row(
                            children: [
                              Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                              SizedBox(width: 15),
                              ProfileText400(text: "PIN", size: 12),
                            ],
                          ),
                          onTap: () {
                            FirebaseComponents().setPin(postReferencePath, position);
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 35),
                        GestureDetector(
                          child: const Row(
                            children: [
                              Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                              SizedBox(width: 15),
                              ProfileText400(text: "DELETE - coming soon", size: 12),
                            ],
                          ),
                          onTap: () {
                            print("HEY");
                          },
                        ),
                        const SizedBox(height: 35),
                        GestureDetector(
                          child: const Row(
                            children: [
                              Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                              SizedBox(width: 15),
                              ProfileText400(text: "REPORT - coming soon", size: 12),
                            ],
                          ),
                          onTap: () {
                            print("HEY");
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}