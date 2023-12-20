import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:provider/provider.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import '../MediaUploadFlows/AlbumSongsDisplayUploadView.dart';
import '../MediaUploadFlows/SinglesCoverDisplay.dart';
import '../MenuFlow/LikedMoodView.dart';

class SongMoodsView extends StatefulWidget {
  final String albumID;
  final String musicId;
  final bool isAlbum;
  final String userID;

  SongMoodsView({required this.albumID, required this.musicId, required this.isAlbum, required this.userID});

  @override
  _SongMoodsViewState createState() => _SongMoodsViewState();
}

class _SongMoodsViewState extends State<SongMoodsView> {
  String backgroundImageUrl = '';
  Map<String, dynamic> musicData = {};

  @override
  void initState() {
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
      body: CustomScrollView(
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  if (widget.albumID != "null") {
                                    return AlbumSongDisplayUploadView(
                                      albumID: widget.albumID,
                                      userID: widget.userID,
                                    );
                                  } else {
                                    return SingleCoverDisplay(
                                      userID: widget.userID,
                                      singleID: widget.musicId,
                                    );
                                  }
                                }),
                              );
                            },
                            child: Container(
                              child: Row(
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
                                      Container(
                                        width: GlobalVariables.properWidth - 125,
                                        child: ProfileText600(
                                          text: musicData['title'],
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                      ProfileText400(text: musicData['artists'], size: 15),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                            const SizedBox(height: GlobalVariables.mediumSpacing),
                            CreatedMoodsView(userId: widget.userID, documentPath: 'songs/${widget.musicId}/moods', type: 1)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
    );
  }
}
