import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:provider/provider.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import '../MenuFlow/LikedMoodView.dart';

class SongMoodsView extends StatefulWidget {
  final String albumID;
  final String musicId;
  final bool isAlbum;

  SongMoodsView({required this.albumID, required this.musicId, required this.isAlbum});

  @override
  _SongMoodsViewState createState() => _SongMoodsViewState();
}

class _SongMoodsViewState extends State<SongMoodsView> {
  late LikedMoodsProvider _SongMoodsProvider;
  String backgroundImageUrl = '';
  Map<String, dynamic> musicData = {};

  @override
  void initState() {
    super.initState();
    _SongMoodsProvider = LikedMoodsProvider('songs/${widget.musicId}/moods');
    _SongMoodsProvider.fetchLikedMoodsData();
    fetchBackgroundImageUrl();
  }

  Future<void> fetchBackgroundImageUrl() async {
    final data = await FirebaseComponents().getReferencedDocumentData(
      documentPath: 'songs/${widget.musicId}',
    );
    musicData = data;
    setState(() {
      backgroundImageUrl = musicData['image_urls'][1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider<LikedMoodsProvider>.value(
        value: _SongMoodsProvider,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: GlobalVariables.horizontalSpacing,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    backgroundImageUrl,
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: GlobalVariables.smallSpacing),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  ProfileText600(
                                    text: musicData['title'],
                                    size: 35,
                                  ),
                                  const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                  ProfileText400(text: musicData['artists'], size: 15)
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: GlobalVariables.mediumSpacing),
                            Consumer<LikedMoodsProvider>(
                              builder: (context, provider, _) {
                                if (provider.isLoading) {
                                  return CircularProgressIndicator();
                                } else if (provider.hasError) {
                                  return Text('Error: ${provider.error}');
                                } else {
                                  final moodList = provider.moodList;
                                  return Column(
                                    children: [
                                      for (int i = 0; i < moodList.length; i += 3)
                                        MoodContainersRow(
                                          moodList: moodList.sublist(i, i + 3 < moodList.length ? i + 3 : moodList.length),
                                        ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
