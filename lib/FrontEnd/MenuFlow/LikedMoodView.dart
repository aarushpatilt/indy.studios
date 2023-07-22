import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import '../../FrontEndComponents/VideoComponent.dart';
import '../MainAppFlows/ThreadDiscoveryView.dart';

class LikedMoodsView extends StatefulWidget {
  @override
  _LikedMoodsViewState createState() => _LikedMoodsViewState();
}

class _LikedMoodsViewState extends State<LikedMoodsView> {
  late LikedMoodsProvider _likedMoodsProvider;
  String backgroundImageUrl = '';

  @override
  void initState() {
    super.initState();
    _likedMoodsProvider = LikedMoodsProvider('users/${GlobalVariables.userUUID}/liked_moods');
    _likedMoodsProvider.fetchLikedMoodsData();
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
              padding: const EdgeInsetsDirectional.symmetric(horizontal: GlobalVariables.horizontalSpacing),
              child: Column(
                children: [
                SizedBox(height: GlobalVariables.mediumSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ProfileText600(
                      text: 'Liked Moods',
                      size: 35,
                    ),
                    ProfilePicture(
                      size: 70,
                    ),
                  ],
                ),
                SizedBox(height: GlobalVariables.mediumSpacing),
                CreatedMoodsView(userId: GlobalVariables.userUUID,),
                ],
              ),
            ), // Use the CreatedMoodsView widget instead of duplicating the same logic
          ),
        ],
      ),
    );
  }
}

class MoodContainersRow extends StatelessWidget {
  final List<Map<String, dynamic>> moodList;

  MoodContainersRow({required this.moodList});

  @override
  Widget build(BuildContext context) {
    assert(moodList.length <= 9, 'The moodList should contain at most 9 elements.');

    final int numContainers = moodList.length;
    final int numEmptyContainers = 3 - numContainers % 3;

    return Row(
      children: _buildMoodContainersWithSpacing() + _buildEmptyContainers(numEmptyContainers),
    );
  }

  List<Widget> _buildMoodContainersWithSpacing() {
    List<Widget> list = [];
    for (int i = 0; i < moodList.length; i++) {
      list.add(Container(
        child: MoodContainer(
          mediaUrl: moodList[i]['image_urls'][2],
          audioUrl: moodList[i]['image_urls'][0],
          tags: moodList[i]['tags'],
          caption: moodList[i]['caption'],
          title: moodList[i]['title'],
          imageUrl: moodList[i]['image_urls'][1],
          uniqueID: moodList[i]['unique_id'],
          userID: moodList[i]['user_id'],
          musicID: moodList[i]['music_id']
        ),
      ));

      if (i < moodList.length - 1) {
        list.add(SizedBox(width:10));  // Adds an adjustable, empty space between each MoodContainer
      }
    }
    return list;
  }

  List<Widget> _buildEmptyContainers(int numEmptyContainers) {
    return List<Widget>.generate(numEmptyContainers, (index) => Expanded(child: Container()));
  }
}





class MoodContainer extends StatefulWidget {
  final String mediaUrl;
  final String audioUrl;
  final List<dynamic> tags;
  final String caption;
  final String title;
  final String imageUrl;
  final String uniqueID;
  final String userID;
  final String musicID;

  MoodContainer({
    required this.mediaUrl,
    required this.audioUrl,
    required this.tags,
    required this.caption,
    required this.title,
    required this.imageUrl,
    required this.uniqueID,
    required this.userID,
    required this.musicID,
  });

  @override
  _MoodContainerState createState() => _MoodContainerState();
}

class _MoodContainerState extends State<MoodContainer> {
  String? profileUrl;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final result = await FirebaseComponents().getSpecificData(
        documentPath: 'users/${widget.userID}',
        fields: ['image_urls', 'username'],
      );

      setState(() {
        profileUrl = result['image_urls'][0];
        username = result['username'];
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final largeSize = MediaQuery.of(context).size.width / 3;

    return GestureDetector(
      onTap: () => _showMoodTile(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: (GlobalVariables.properWidth / 3.4) - (0.01 * GlobalVariables.properWidth) ,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: _buildMediaWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildMediaWidget() {
  if (widget.mediaUrl.contains('.MOV') || widget.mediaUrl.contains('.mp4')) {
    return AspectRatio(
      aspectRatio: 16 / 9, // You can adjust the aspect ratio to match your video's aspect ratio
      child: FittedBox(
        fit: BoxFit.cover,
        child: MoodPlayer(videoUrl: widget.mediaUrl),
      ),
    );
  } else if (widget.mediaUrl.contains('.jpg') ||
      widget.mediaUrl.contains('.jpeg') ||
      widget.mediaUrl.contains('.png')) {
    return Image.network(
      widget.mediaUrl,
      fit: BoxFit.cover,
    );
  } else {
    return Container();
  }
}



  void _showMoodTile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return ClipRect(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                  color: Colors.black,
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -50),
                      child: MoodTile(
                        mediaUrl: widget.mediaUrl,
                        audioUrl: widget.audioUrl,
                        username: username!,
                        profileUrl: profileUrl!,
                        tags: widget.tags,
                        caption: widget.caption,
                        title: widget.title,
                        imageUrl: widget.imageUrl,
                        uniqueID: widget.uniqueID,
                        userID: widget.userID,
                        albumID: "",
                        musicID: widget.musicID,

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



class LikedMoodsProvider with ChangeNotifier {
  final String _collectionPath;
  final List<Map<String, dynamic>> _moodList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _error = '';

  LikedMoodsProvider(this._collectionPath); // Add this constructor

  List<Map<String, dynamic>> get moodList => _moodList;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get error => _error;

  Future<void> fetchLikedMoodsData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await FirebaseComponents().getReferencedData(
        collectionPath: _collectionPath,
        limit: 9,
      );
      _moodList.addAll(data);
      
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

class CreatedMoodsProvider with ChangeNotifier {
  final String _collectionPath;
  final List<Map<String, dynamic>> _moodList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _error = '';
  DocumentSnapshot? _lastDocument;

  CreatedMoodsProvider(this._collectionPath);

  List<Map<String, dynamic>> get moodList => _moodList;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get error => _error;

  Future<void> fetchCreatedMoodsData() async {
    try {
      _isLoading = true;
      notifyListeners();

      List<Map<String, dynamic>> data;
      if (_lastDocument == null) {
        data = await FirebaseComponents().getPaginatedCollectionData(
          collectionPath: _collectionPath,
          limit: 9,
        );
      } else {
        data = await FirebaseComponents().getPaginatedCollectionData(
          collectionPath: _collectionPath,
          limit: 9,
          startAfterDocument: _lastDocument,
        );
      }

      if (data.isNotEmpty) {
        _lastDocument = _lastDocument != null ? data.last['_docSnapshot'] : null;
        _moodList.addAll(data.map((map) => map..remove('_docSnapshot')));
      }

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



class MoodPlayer extends StatefulWidget {
  final String videoUrl;

  MoodPlayer({required this.videoUrl});

  @override
  _MoodPlayerState createState() => _MoodPlayerState();
}

class _MoodPlayerState extends State<MoodPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Container(
            width: GlobalVariables.properWidth - 50,
            height: GlobalVariables.properWidth - 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: VideoPlayer(_controller),
            ),
          )
        : Container();
  }
}


class CreatedMoodsView extends StatefulWidget {
  final String userId;

  CreatedMoodsView({required this.userId});

  @override
  _CreatedMoodsViewState createState() => _CreatedMoodsViewState();
}

class _CreatedMoodsViewState extends State<CreatedMoodsView> {
  late CreatedMoodsProvider _createdMoodsProvider;

  @override
  void initState() {
    super.initState();
    _createdMoodsProvider = CreatedMoodsProvider('users/${widget.userId}/moods');
    _createdMoodsProvider.fetchCreatedMoodsData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider<CreatedMoodsProvider>.value(
      value: _createdMoodsProvider,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(top: 0),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 0,
            ),
            height: screenHeight,
            width: screenWidth,
            color: Colors.transparent,
            child: Consumer<CreatedMoodsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.hasError) {
                  return Center(child: Text('Error: ${provider.error}'));
                } else {
                  final moodList = provider.moodList;
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                        _createdMoodsProvider.fetchCreatedMoodsData();
                      }
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add additional spacing if needed
                          Column(
                            children: [
                              for (int i = 0; i < moodList.length; i += 3)
                                MoodContainersRow(
                                  moodList: moodList.sublist(i, i + 3 < moodList.length ? i + 3 : moodList.length),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
