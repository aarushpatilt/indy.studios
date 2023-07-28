import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ndy/FrontEnd/MainAppFlows/ThreadDiscoveryView.dart';
import 'package:ndy/main.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/ButtonComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';

class Profile extends StatefulWidget {
  final String userID;

  Profile({required this.userID});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _futureProfileData;
  late Color _dominantColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _futureProfileData = FirebaseComponents().getSpecificData(documentPath: 'users/${widget.userID}');
    _futureProfileData.then((profileData) {
      _getDominantColor(profileData['image_urls'][1]).then((dominantColor) {
        setState(() {
          _dominantColor = dominantColor;
        });
      });
    });
  }

  Future<Color> _getDominantColor(String imageUrl) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );
    return generator.dominantColor?.color ?? Colors.black;
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        FutureBuilder<Map<String, dynamic>>(
          future: _futureProfileData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final profileData = snapshot.data!;
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: 400,  // set the height to 200
                        width: double.infinity,  // let it take the full width of the screen
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), 
                            BlendMode.darken,
                          ),
                          child: Image.network(
                            profileData['image_urls'][1],
                            fit: BoxFit.fitWidth,  // change this to BoxFit.fill to maintain the aspect ratio
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: constraints.maxHeight,  // set the height to 100% of the parent height
                          child: DraggableScrollableSheet(
                            initialChildSize: 0.75,  // initial height 50% of the parent height
                            minChildSize: 0.75,  // minimum height 50% of the parent height
                            maxChildSize: 1.0,  // maximum height 100% of the parent height
                            builder: (BuildContext context, ScrollController scrollController) {
                              return ListView(
                                controller: scrollController,
                                physics: const ClampingScrollPhysics(),
                                children: [
Padding(
                              padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ProfileText600(text: "user", size: 15),
                                  const SizedBox(height: GlobalVariables.smallSpacing - 15),
                                  Row(
                                    children: [
                                      ProfileText600(text: profileData['first_name'], size: 35),
                                      const SizedBox(width: GlobalVariables.smallSpacing - 15),
                                      ProfileText600(text: profileData['last_name'], size: 35),
                                    ],
                                  ),
                                  const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                  ProfileText400(text: '${profileData['stats'][3].toString()} total listeners', size: 15),
                                  const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                ],
                              ),
                            ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [_dominantColor.darken(40), Colors.black],
                                        begin: Alignment.topCenter,
                                        end: Alignment.center,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: GlobalVariables.largeSpacing - 10),
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                profileData['image_urls'][0],
                                                width: 75,
                                                height: 75,
                                              ),
                                            ),
                                            const SizedBox(width: 30),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ProfileText600(text: profileData['username'], size: 25),
                                                const SizedBox(height: GlobalVariables.mediumSpacing - 10),
                                                ProfileText400(text: profileData['bio'], size: 15),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: GlobalVariables.largeSpacing),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GenericTextReg(text: profileData['stats'][0].toString()),
                                                const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                                const ProfileText400(text: "listening", size: 15),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GenericTextReg(text: profileData['stats'][1].toString()),
                                                const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                                const ProfileText400(text: "listeners", size: 15),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GenericTextReg(text: profileData['stats'][2].toString()),
                                                const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                                const ProfileText400(text: "monthly", size: 15),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: GlobalVariables.largeSpacing),
                                        TabSliderMenu(initialIndex: 0, userID: GlobalVariables.userUUID),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
    );
  }
}

class ProfileSubView extends StatefulWidget {
  final String userID;

  ProfileSubView({required this.userID});

  @override
  _ProfileSubViewState createState() => _ProfileSubViewState();
}

class _ProfileSubViewState extends State<ProfileSubView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          const SizedBox(height: GlobalVariables.smallSpacing),
          BioPreview(userID: widget.userID),
          const SizedBox(height: GlobalVariables.mediumSpacing),
          LatestThreadDisplay(userId: widget.userID),
          AlbumListDisplay(userID: widget.userID, collectionPath: '/users/${widget.userID}/albums', title: 'ALBUMS'),
          const SizedBox(height: GlobalVariables.mediumSpacing),
          AlbumListDisplay(userID: widget.userID, collectionPath: '/users/${widget.userID}/singles', title: 'SINGLES', type: 1)
        ],
      ),
    );
  }
}

