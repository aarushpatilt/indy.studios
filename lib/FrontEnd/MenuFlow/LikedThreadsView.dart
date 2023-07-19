import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import '../../FrontEndComponents/CustomTabController.dart';
import 'package:video_player/video_player.dart';

import '../MainAppFlows/ThreadDiscoveryView.dart';
class LikedThreadView extends StatefulWidget {
  LikedThreadView({Key? key}) : super(key: key);

  @override
  _LikedThreadViewState createState() => _LikedThreadViewState();
}

class _LikedThreadViewState extends State<LikedThreadView> {
  late Future<List<Map<String, dynamic>>> _threadData;

  @override
  void initState() {
    super.initState();
    _threadData = FirebaseComponents().getReferencedData(collectionPath: '/users/${GlobalVariables.userUUID}/liked_threads', limit: 5);
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: const Drawer(
      child: MenuSideBar(),
    ),
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50), // Add top padding of 50
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _threadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("");
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    if (data.containsKey('image_urls')) {
                      return Container(
                        child: PostDisplay(data: data),
                      );
                    }
                    return Container(
                      child: ThoughtDisplay(data: data)
                    );
                  },
                );
              }
            },
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBar(title: "LIKED"),
        ),
      ],
    ),
  );
}
}