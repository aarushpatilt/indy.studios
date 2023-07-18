import 'package:flutter/material.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';

class LikedSongView extends StatefulWidget {
  @override
  _LikedSongViewState createState() => _LikedSongViewState();
}

class _LikedSongViewState extends State<LikedSongView> {
  Future<List<Map<String, dynamic>>>? songData;
  String backgroundImageUrl = '';

  @override
  void initState() {
    super.initState();
    songData = fetchLikedSongsData();
    fetchBackgroundImageUrl();
  }

  Future<List<Map<String, dynamic>>> fetchLikedSongsData() async {
    final data = await FirebaseComponents().getReferencedData(
      collectionPath: 'users/${GlobalVariables.userUUID}/liked_songs',
      limit: 3,
    );
    return data;
  }

  Future<void> fetchBackgroundImageUrl() async {
    final data = await FirebaseComponents().getSpecificData(
      documentPath: 'users/${GlobalVariables.userUUID}',
      fields: ['image_urls'],
    );
    final imageUrls = List<String>.from(data['image_urls'] as List<dynamic>);
    if (imageUrls.isNotEmpty) {
      setState(() {
        backgroundImageUrl = imageUrls[1];
        print(backgroundImageUrl);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: screenHeight * 0.4,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (backgroundImageUrl.isNotEmpty)
                    Image.network(
                      backgroundImageUrl,
                      width: screenWidth,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                height: screenHeight,
                width: screenWidth,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const ProfileText600(
                          text: 'Liked Songs',
                          size: 35,
                        ),
                        ProfilePicture(
                          size: 70,
                        ),
                      ],
                    ),
                    SizedBox(height: 16), // Add additional spacing if needed
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: songData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final songList = snapshot.data;
                          return Column(
                            children: songList?.map((song) {
                              return SongRow(
                                imageUrl: song['image_urls'][1],
                                songTitle: song['title'],
                                songArtist: song['artists'],
                                timestamp: song['timestamp'].toDate(),
                                audioUrl: song['image_urls'][0],
                                albumId: song['album_id'],
                                userID: song['user_id'],
                                tags: song['tags'],
                                barColor: Colors.green,
                                uniqueID: song['unique_id'],
                                
                              );
                            }).toList() ?? [],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class SongRow extends StatelessWidget {
  final String imageUrl;
  final String songTitle;
  final String songArtist;
  final DateTime timestamp;
  final String audioUrl;
  final String? albumId;
  final String userID;
  final List<dynamic> tags;
  final Color barColor;
  final String uniqueID;

  SongRow({
    required this.imageUrl,
    required this.songTitle,
    required this.songArtist,
    required this.timestamp,
    required this.audioUrl,
    required this.albumId,
    required this.userID,
    required this.tags,
    required this.barColor,
    required this.uniqueID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMusicTile(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: GlobalVariables.largeSize,
              height: GlobalVariables.largeSize,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: GlobalVariables.smallSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GenericTextReg(text: songTitle),
                const SizedBox(height: GlobalVariables.smallSpacing - 10),
                GenericTextReg(text: songArtist),
              ],
            ),
          ],
        ),
      ),
    );
  }

void _showMusicTile(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // makes the background transparent
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9, // initial height is 90% of screen height
        minChildSize: 0.5, // minimum height is 50% of screen height
        maxChildSize: 0.9, // maximum height is 90% of screen height
        builder: (BuildContext context, ScrollController scrollController) {
          return ClipRect(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                color: Colors.black,
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Transform.translate(
                    offset: Offset(0, -100), // Shifting the MusicTile upwards by 50 pixels
                    child: MusicTile(
                      title: songTitle,
                      artist: songArtist,
                      timestamp: timestamp,
                      imageUrl: imageUrl,
                      audioUrl: audioUrl,
                      albumId: albumId,
                      userID: userID,
                      tags: tags,
                      barColor: barColor,
                      uniqueID: uniqueID,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}



}
