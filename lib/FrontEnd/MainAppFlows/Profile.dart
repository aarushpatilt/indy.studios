import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';

class Profile extends StatefulWidget {
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
        .doc(GlobalVariables.userUUID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureProfileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            final profileData = snapshot.data!.data() as Map<String, dynamic>;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
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
