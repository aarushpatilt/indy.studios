import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumUploadView.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import 'package:intl/intl.dart';
import '../../FrontEndComponents/AudioComponents.dart';

class MusicDiscoveryView extends StatefulWidget {
  @override
  _MusicDiscoveryViewState createState() => _MusicDiscoveryViewState();
}

class _MusicDiscoveryViewState extends State<MusicDiscoveryView> {
  final playNotifier = ValueNotifier<bool>(false);
  final firestoreService = FirestoreService();
  List<Map<String, dynamic>> documents = [];
  final _pageController = PageController(viewportFraction: 1); // Change viewportFraction based on your needs

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
      appBar: const HeaderPrevious(text: "discover"),
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          final docData = documents[index];
          return MusicTile(
            title: docData['title'],
            artist: docData['artists'],
            timestamp: docData['timestamp'].toDate(),
            imageUrl: docData['image_urls'][1],
            audioUrl: docData['image_urls'][0],
          );
        },
      ),
    );
  }
}
