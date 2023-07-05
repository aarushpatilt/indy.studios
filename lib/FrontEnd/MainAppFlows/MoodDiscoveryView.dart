import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../Backend/FirebaseComponents.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../FrontEndComponents/VideoComponent.dart';

class MoodDiscoveryView extends StatefulWidget {
  @override
  _MoodDiscoveryViewState createState() => _MoodDiscoveryViewState();
}

class _MoodDiscoveryViewState extends State<MoodDiscoveryView> {
  final playNotifier = ValueNotifier<bool>(false);
  final firestoreService = FirestoreService('moods/mix/collection');
  List<Map<String, dynamic>> documents = [];
  final _pageController = PageController(viewportFraction: 1);

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _pageController.addListener(() {
      if (_pageController.position.atEdge) {
        if (_pageController.position.pixels != 0) _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    final newDocs = await firestoreService.fetchNextBatch();
    setState(() {
      documents.addAll(newDocs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: PageView.builder(
          controller: _pageController,
          pageSnapping: true,
          scrollDirection: Axis.vertical,
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            final docData = documents[index];
            currentPage = index;
            return 
            MoodTile(
              mediaUrl: docData['image_urls'][2],
              audioUrl: docData['image_urls'][0],
              username: docData['username'],
              profileUrl: docData['profile'],
              tags: docData['tags'],
              caption: docData['caption'],
              title: docData['title'],
              imageUrl: docData['image_urls'][1],
            );
          },
        ),
      ),
    );
  }
}
