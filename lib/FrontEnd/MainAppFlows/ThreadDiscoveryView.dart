import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/MainAppFlows/Profile.dart';
import 'package:ndy/FrontEndComponents/OptionComponent.dart';
import '../../FrontEndComponents/CustomTabController.dart';
import 'package:video_player/video_player.dart';

import '../../FrontEndComponents/TextComponents.dart';
import '../MenuFlow/CommentView.dart';


class ThreadDiscoveryView extends StatefulWidget {
  ThreadDiscoveryView({Key? key}) : super(key: key);

  @override
  _ThreadDiscoveryViewState createState() => _ThreadDiscoveryViewState();
}

class _ThreadDiscoveryViewState extends State<ThreadDiscoveryView> {
  List<Map<String, dynamic>> _threadData = [];
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _threadData = [];
      _lastDocument = null;
    });
    _loadMoreData();
  }

  Future<void> _loadMoreData() async {
    List<Map<String, dynamic>> newItems = await FirebaseComponents().getPaginatedReferencedData(collectionPath: 'threads', limit: 5, T: "yes", startAfter: _lastDocument);

    if (newItems.isNotEmpty) {
      // Updating the _lastDocument from the Firebase Firestore reference
      _lastDocument = await FirebaseFirestore.instance.collection('threads').doc(newItems.last['unique_id']).get();

      setState(() {
        _threadData.addAll(newItems);
      });
    }
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
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
  itemCount: _threadData.length + 2, // Add 2 to itemCount, 1 for the title and 1 for the loading or end message
  itemBuilder: (context, index) {
    // If index is zero, return the title
    if (index == 0) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 20.0, left: 15),
        child: ProfileText500(text: "Discover", size: 30),
      );
    } 
    // Need to subtract 1 from the index as we added a new widget at the beginning
    index -= 1;
    if (index < _threadData.length) {
      var data = _threadData[index];
      if (data.containsKey('image_urls')) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
            child: PostDisplay(data: data),
          ),
        );
      }
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
          child: ThoughtDisplay(data: data),
        ),
      );
    } else if (_lastDocument != null) {
      // Loading more data when reach the end of the list
      _loadMoreData();
      return const Center(child: ProfileText400(text: "you have reached da end", size: 12));
    } else {
      // All data loaded
      return Container();
    }
  },
),

            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(title: ""),
          ),
        ],
      ),
    );
  }
}



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
      fields: ['image_urls', 'username'],
    );
    setState(() {
      profilePicture = result['image_urls'][0];
      username = result['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Container(
      width: GlobalVariables.properWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: GlobalVariables.properWidth,
              child: MediaFilesDisplay(mediaFiles: data['image_urls'].cast<String>()),
            ),
            const SizedBox(height: GlobalVariables.smallSpacing),
            GestureDetector(
              onTap:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile( userID: widget.data['user_id']),
                      ),
                    );
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        child: ClipOval(
                          child: Image.network(
                            profilePicture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
            Text(
              data['caption'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeDislikeWidget(type: "threads", uniqueID: data['unique_id'], userID: data['user_id'], size: 15, sentence: 'liked your thread'),
                    const SizedBox(width: 10),
                    CommentIcon(size: 15, userID: data['user_id'], type: 'threads', uniqueID: data['unique_id'])
                  ],
                ),
                Container(
                      color: Colors.transparent,
                      width: 20,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: OptionsIcon(size: 15, postReferencePath: 'users/${GlobalVariables.userUUID}/threads/${data['unique_id']}', position: 1),
                      ),
                )
              ],
            ),
            const SizedBox(height: GlobalVariables.mediumSpacing),
          ],
        ),
      ),
    );
  }
}

class ThoughtDisplay extends StatefulWidget {
  final Map<String, dynamic> data;

  ThoughtDisplay({required this.data});

  @override
  _ThoughtDisplayState createState() => _ThoughtDisplayState();
}

class _ThoughtDisplayState extends State<ThoughtDisplay> {
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
      fields: ['image_urls', 'username'],
    );
    setState(() {
      profilePicture = result['image_urls'][0];
      username = result['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile( userID: widget.data['user_id']),
                      ),
                    );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: ClipOval(
                        child: Image.network(
                          profilePicture,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],

            ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              data['caption'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeDislikeWidget(type: "threads", uniqueID: data['unique_id'], userID: data['user_id'], size: 15, sentence: 'liked your thread'),
                    const SizedBox(width: 10),
                    CommentIcon(size: 15, userID: data['user_id'], type: 'threads', uniqueID: data['unique_id']),
                    
                    
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  width: 20,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: OptionsIcon(size: 15, postReferencePath: 'users/${GlobalVariables.userUUID}/threads/${data['unique_id']}', position: 2),
                  ),
                )
              ],
            ),
            const SizedBox(height: GlobalVariables.mediumSpacing),
          ],
        ),
      ),
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.mediaFiles.length,
      itemBuilder: (context, index) {
        String filePath = widget.mediaFiles[index];
        String extension = _extractFileExtension(filePath);
        if (extension == 'mp4' || extension == 'mov') {
          return Padding(
            padding: EdgeInsets.only(right: (index != widget.mediaFiles.length - 1) ? 15 : 0),
            child: ThreadPlayer(videoUrl: filePath, size: (widget.mediaFiles.length == 1) ? GlobalVariables.properWidth - 30 : GlobalVariables.properWidth - 50),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(right: (index != widget.mediaFiles.length - 1) ? 15 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0), // Adjust the value as needed
              child: Image.network(
                filePath,
                width: (widget.mediaFiles.length == 1) ? GlobalVariables.properWidth - 30 : GlobalVariables.properWidth - 50,
                height: (widget.mediaFiles.length == 1) ? GlobalVariables.properWidth - 30 : GlobalVariables.properWidth - 50,
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      },
    );
  }

    String _extractFileExtension(String filePath) {
    String extension = filePath.split('.').last;
    if (extension.contains('?')) {
      extension = extension.substring(0, extension.indexOf('?'));
    }
    return extension.toLowerCase();
  }
}



class ThreadPlayer extends StatefulWidget {
  final String videoUrl;
  final double size;

  ThreadPlayer({required this.videoUrl, required this.size});

  @override
  _ThreadPlayerState createState() => _ThreadPlayerState();
}

class _ThreadPlayerState extends State<ThreadPlayer> {
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
            width: widget.size,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: GlobalVariables.properWidth,
                        maxHeight: GlobalVariables.properWidth,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: VideoPlayer(_controller),
                      )
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}




class LatestThreadDisplay extends StatefulWidget {
  final String userId;

  LatestThreadDisplay({Key? key, required this.userId}) : super(key: key);

  @override
  _LatestThreadDisplayState createState() => _LatestThreadDisplayState();
}

class _LatestThreadDisplayState extends State<LatestThreadDisplay> {
  late Future<Map<String, dynamic>> _latestThreadData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _latestThreadData = FirebaseComponents().getLatestDocumentFromCollection(collectionPath: 'users/${widget.userId}/threads');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _latestThreadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return ProfileText400(text: 'Error: ${snapshot.error}', size: 15);
        } else {
          var data = snapshot.data;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data!.containsKey('image_urls') ? [
                        const ProfileText400(text: "RECENT", size: 12),
                        const SizedBox(height: GlobalVariables.smallSpacing),
                        PostDisplay(data: data),
                      ] : [
                        const ProfileText400(text: "RECENT", size: 12),
                        const SizedBox(height: GlobalVariables.smallSpacing),
                        ThoughtDisplay(data: data),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CreatedThreadView extends StatefulWidget {
  CreatedThreadView({Key? key}) : super(key: key);

  @override
  _CreatedThreadViewState createState() => _CreatedThreadViewState();
}

class _CreatedThreadViewState extends State<CreatedThreadView> {
  List<Map<String, dynamic>> _threadData = [];
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _loadMoreData();
  }

  Future<void> _loadMoreData() async {
    List<Map<String, dynamic>> newItems = await FirebaseComponents().getPaginatedCollectionData(
      collectionPath: 'users/${GlobalVariables.userUUID}/threads', 
      limit: 5, 
      startAfterDocument: _lastDocument
    );

    if (newItems.isNotEmpty) {
      // Updating the _lastDocument from the Firebase Firestore reference
      _lastDocument = await FirebaseFirestore.instance.collection('users/${GlobalVariables.userUUID}/threads').doc(newItems.last['unique_id']).get();

      setState(() {
        _threadData.addAll(newItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 175,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: ListView.builder(
              padding: EdgeInsets.zero, // Remove default padding
              itemCount: _threadData.length + 1,
              itemBuilder: (context, index) {
                if (index < _threadData.length) {
                  var data = _threadData[index];
                  if (data.containsKey('image_urls')) {
                    return Container(
                      child: PostDisplay(data: data),
                    );
                  }
                  return Container(
                    child: ThoughtDisplay(data: data),
                  );
                } else if (_lastDocument != null) {
                  // Loading more data when reach the end of the list
                  _loadMoreData();
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // All data loaded
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



