import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import '../../Backend/FirebaseComponents.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicDiscoveryView extends StatefulWidget {
  const MusicDiscoveryView({super.key});

  @override
  _MusicDiscoveryViewState createState() => _MusicDiscoveryViewState();
}

class _MusicDiscoveryViewState extends State<MusicDiscoveryView> {
  final playNotifier = ValueNotifier<bool>(false);
  final firestoreService = FirestoreService('songs');
  List<Map<String, dynamic>> documents = [];
  final _pageController = PageController(viewportFraction: 1);

  PaletteGenerator? paletteGenerator;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _updatePaletteGenerator();
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

  Future<void> _updatePaletteGenerator() async {
    if (currentPage < documents.length) {
      final generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(documents[currentPage]['image_urls'][1]),
      );
      setState(() {
        paletteGenerator = generator;
      });
    }
  }

  Future<String?> _getAlbumId() async {
    if(documents[currentPage]['image_urls'][1].contains('%2Falbums%2F')){ //does contain
      Map<String, dynamic> data = await FirebaseComponents().getSpecificData(documentPath: documents[currentPage]['ref'], fields: ['album_id']);
      return data['album_id'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                paletteGenerator?.dominantColor?.color ?? Colors.black,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // The Scaffold is on top of the gradient
        Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView.builder(
            controller: _pageController,
            itemCount: documents.length,
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
              _updatePaletteGenerator();
            },
            itemBuilder: (BuildContext context, int index) {
              final docData = documents[index];
              return FutureBuilder<String?>(
                future: _getAlbumId(), 
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();  // Or some other placeholder
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return 
                    MusicTile(
                      title: docData['title'],
                      artist: docData['artists'],
                      timestamp: docData['timestamp'].toDate(),
                      imageUrl: docData['image_urls'][1],
                      audioUrl: docData['image_urls'][0],
                      albumId: snapshot.data, // Now you are providing a String or null, as your function specifies
                      userID: docData['user_id'],
                      tags: docData['tags']
                    );
                  }
                }
              );
            },
          ),
        ),
      ],
    );
  }
}
