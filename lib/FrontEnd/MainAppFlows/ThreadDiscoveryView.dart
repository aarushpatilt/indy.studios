import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import 'package:video_player/video_player.dart';
import '../../Backend/FirebaseComponents.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/CustomTabController.dart';
import '../../FrontEndComponents/VideoComponent.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostDisplay extends StatefulWidget {
  final Map<String, dynamic> data;

  PostDisplay({required this.data});

  @override
  _PostDisplayState createState() => _PostDisplayState();
}

class _PostDisplayState extends State<PostDisplay> {
  String profilePicture = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var result = await FirebaseComponents().getSpecificData(
        documentPath: 'users/${widget.data['user_id']}',
        fields: ['image_urls', 'username']);
    setState(() {
      profilePicture = result['image_urls'][0];
      username = result['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.network(
                profilePicture,
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
            ),
            ProfileText400(text: username, size: 12),
          ],
        ),
        SizedBox(height: GlobalVariables.smallSpacing),
        ProfileText400(text: widget.data['caption'], size: 12),
        SizedBox(height: GlobalVariables.smallSpacing),
        Container(
          height: 200,  // Adjust this value according to your needs
          child: MediaFilesDisplay(mediaFiles: widget.data['image_urls'].cast<String>()),
        ),
      ],
    );
  }
}


class MediaFilesDisplay extends StatefulWidget {
  final List<String> mediaFiles;

  MediaFilesDisplay({required this.mediaFiles});

  @override
  _MediaFilesDisplayState createState() => _MediaFilesDisplayState();
}

class _MediaFilesDisplayState extends State<MediaFilesDisplay> {
  // Updated code as per your instructions.

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.mediaFiles.length,
      itemBuilder: (context, index) {
        String filePath = widget.mediaFiles[index];
        String extension = filePath.split('.').last.toLowerCase();
        return Padding(
          padding: EdgeInsets.only(right: (index != widget.mediaFiles.length - 1) ? 15 : 0),
          child: Image.network(
            filePath,
            width: GlobalVariables.properWidth,
            height: GlobalVariables.properWidth,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}


class ThreadDiscoveryView extends StatefulWidget {
  ThreadDiscoveryView({Key? key}) : super(key: key);

  @override
  _ThreadDiscoveryViewState createState() => _ThreadDiscoveryViewState();
}

class _ThreadDiscoveryViewState extends State<ThreadDiscoveryView> {
  late Future<List<Map<String, dynamic>>> _threadData;

  @override
  void initState() {
    super.initState();
    _threadData = FirebaseComponents().getReferencedData(collectionPath: 'threads', limit: 8);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _threadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var data = snapshot.data![index];
              if (data.containsKey('image_urls')) {
                return PostDisplay(data: data);
              } else {
                return Text("hey");
              }
            },
          );
        }
      },
    );
  }
}


