import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/OptionComponent.dart';
import 'package:provider/provider.dart';

import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';

class LikedSongView extends StatefulWidget {
  @override
  _LikedSongViewState createState() => _LikedSongViewState();
}

class _LikedSongViewState extends State<LikedSongView> {
  late LikedSongsProvider _likedSongsProvider;
  String backgroundImageUrl = '';

  @override
  void initState() {
    super.initState();
    _likedSongsProvider = LikedSongsProvider();
    _likedSongsProvider.fetchLikedSongsData();
    fetchBackgroundImageUrl();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ChangeNotifierProvider<LikedSongsProvider>.value(
        value: _likedSongsProvider,
        builder: (context, child) {
          return CustomScrollView(
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
                    padding: EdgeInsets.symmetric(
                        horizontal: GlobalVariables.horizontalSpacing),
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
                        Consumer<LikedSongsProvider>(
                          builder: (context, provider, _) {
                            if (provider.isLoading) {
                              return CircularProgressIndicator();
                            } else if (provider.hasError) {
                              return Text('Error: ${provider.error}');
                            } else {
                              final songList = provider.songList;
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
          );
        },
      ),
    );
  }
}

class LikedSongsProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _songList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _error = '';

  List<Map<String, dynamic>> get songList => _songList;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get error => _error;

  Future<void> fetchLikedSongsData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await FirebaseComponents().getReferencedData(
        collectionPath: 'users/${GlobalVariables.userUUID}/liked_songs',
        limit: 6,
      );

      _songList.addAll(data);
      _isLoading = false;
      _hasError = false;
      _error = '';
    } catch (error) {
      _isLoading = false;
      _hasError = true;
      _error = error.toString();
    } finally {
      notifyListeners();
    }
  }
}

class SongRow extends StatelessWidget {
  final String imageUrl;
  final String songTitle;
  final String songArtist;
  final String timestamp;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: GlobalVariables.smallSpacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileText500(text: songTitle, size: 15),
                    const SizedBox(height: GlobalVariables.smallSpacing - 10),
                    ProfileText400(text: songArtist, size: 12),
                  ],
                ),                
              ],
            ),
            Column(
              children: [
                OptionsIcon(postReferencePath: albumId != null ? 'users/$userID/albums/$albumId/collections/$uniqueID' : 'users/$userID/singles/$uniqueID', position: 0, profileImageURL: imageUrl, size: 20)
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showMusicTile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.89,
          minChildSize: 0.5,
          maxChildSize: 0.89,
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
                      offset: Offset(0, -100),
                      child: MusicTile(
                        title: songTitle,
                        artist: songArtist,
                        timestamp: timestamp.toString(),
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
