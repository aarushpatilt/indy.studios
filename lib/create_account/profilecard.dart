import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ndy/global/backend.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';
import 'package:ndy/global/inputs.dart';
import 'package:ndy/global/shared.dart';
import 'package:ndy/global/uploads.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'package:flutter/material.dart';
// Import other necessary packages, like Firebase

class ProfileCard extends StatefulWidget {
  final String uuid;

  const ProfileCard({super.key, required this.uuid});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Future<Map<String, dynamic>>? userData;

  @override
  void initState() {
    super.initState();
    userData = _getData();
  }

  Future<Map<String, dynamic>> _getData() async {
    Map<String, dynamic> userData = await FirebaseBackend().getDocumentData('users', widget.uuid);
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Constant.mediumSpacing),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Show LinearProgressIndicator while data is loading
                           return const SizedBox(
                            height: 50,
                            child: LinearProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          // Handle error state
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // Data is loaded, build the profile card
                          Map<String, dynamic> userData = snapshot.data!;
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter, // Aligns the Column to the bottom of the Stack
                                  children: [
                                    Image.network(
                                      userData['images'][0],
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding:EdgeInsets.symmetric(horizontal: horizontalPadding),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min, // Makes the column wrap its content
                                        children: [
                                          Row(
                                            children: [
                                              Text(userData['first_name'], style: const TextStyle(color: Constant.activeColor, fontSize: 40, fontWeight: FontWeight.w500),),
                                              const SizedBox(width: Constant.smallSpacing),
                                              Text(userData['last_name'], style:  const TextStyle(color: Constant.activeColor, fontSize: 40, fontWeight: FontWeight.w500),)
                                              ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${userData['stats'][3]} total listeners",
                                              style: const TextStyle(
                                                color: Constant.activeColor,
                                                fontSize: Constant.medText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        } else {
                          // Handle the case where no data is returned
                          return Text('No data available');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
  }
}
