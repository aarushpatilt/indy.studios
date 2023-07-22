import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ndy/FrontEnd/MainAppFlows/ThreadDiscoveryView.dart';

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
  late Future<DocumentSnapshot> _futureProfileData;

  @override
  void initState() {
    super.initState();
    _futureProfileData = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID) // Use the widget.userID parameter
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureProfileData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            final profileData = snapshot.data!.data() as Map<String, dynamic>;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.black,
                  expandedHeight: 400.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), 
                            BlendMode.darken,
                          ),
                          child: Image.network(
                            profileData['image_urls'][1],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const ProfileText600(text: "artist", size: 15),
                                const SizedBox(height: GlobalVariables.smallSpacing - 15),

                                Row(
                                  children: [
                                    ProfileText500(text: profileData['first_name'], size: 30),
                                    const SizedBox(width: GlobalVariables.smallSpacing - 15),
                                    ProfileText500(text: profileData['last_name'], size: 30),
                                  ],
                                ),

                                const SizedBox(height: GlobalVariables.smallSpacing - 10),  
                                ProfileText400(text: '${profileData['stats'][3].toString()} total listeners', size: 15),
                                const SizedBox(height: GlobalVariables.smallSpacing - 10), 
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                        child: 
                        Column(
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
                                    const SizedBox(height: GlobalVariables.mediumSpacing - 5),
                                    ProfileText400(text: profileData['bio'], size: 15),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: GlobalVariables.largeSpacing ),
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
                  ),
                ),
              ],
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

