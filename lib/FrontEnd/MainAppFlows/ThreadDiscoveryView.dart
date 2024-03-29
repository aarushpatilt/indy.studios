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
import '../MenuFlow/LikedSongsView.dart';


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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 23, 23, 23), Colors.black],
          ),
        ),
        
        child: Stack(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: _threadData.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: GlobalVariables.mediumSpacing,left: 15),
                            child: ProfileText500(text: "Discover", size: 30),
                          ),
                        );
                      } 
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
                        _loadMoreData();
                        return const Center(child: ProfileText400(text: "you have reached da end", size: 12));
                      } else {
                        return Container();
                      }
                    },
                  ),
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
                        child: OptionsIcon(size: 15, postReferencePath: 'users/${GlobalVariables.userUUID}/threads/${data['unique_id']}', position: 1, profileImageURL: profilePicture, documentPath:'users/${GlobalVariables.userUUID}/threads/${data['unique_id']}', collectionPath: 'threads', type: "post"),
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
                    child:  OptionsIcon(size: 15, postReferencePath: 'users/${GlobalVariables.userUUID}/threads/${data['unique_id']}', position: 2, profileImageURL: profilePicture, documentPath:'users/${GlobalVariables.userUUID}/threads/${data['unique_id']}', collectionPath: 'threads', type: "post"),
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
    child: AspectRatio(
      aspectRatio: _controller.value.size != null 
                      ? _controller.value.size.width / _controller.value.size.height 
                      : 16 / 9, // fallback ratio if the video's dimensions are not available
      child: VideoPlayer(_controller),
    ),
  ),
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




class PinnedThreadDisplay extends StatefulWidget {
  final String userId;

  PinnedThreadDisplay({Key? key, required this.userId}) : super(key: key);

  @override
  _PinnedThreadDisplayState createState() => _PinnedThreadDisplayState();
}

class _PinnedThreadDisplayState extends State<PinnedThreadDisplay> {
  late Future<Map<String, dynamic>> _latestThreadData;
  late Future<Map<String, dynamic>> _pinnedData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    String documentPath = 'users/${widget.userId}';
    _latestThreadData = FirebaseComponents().getSpecificData(documentPath: documentPath);

    Map<String, dynamic> latestThreadData = await _latestThreadData;
    String pinnedDocPath = latestThreadData['pinned'][1];
    
    setState(() {
      _pinnedData = FirebaseComponents().getSpecialData(documentPath: pinnedDocPath);
    });
  }




@override
Widget build(BuildContext context) {
  return FutureBuilder<Map<String, dynamic>>(
    future: _pinnedData, // Use _pinnedData here instead of _latestThreadData
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Container();
      } else {
        var pinnedData = snapshot.data; // This is the data for _pinnedData
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostDisplay(data: pinnedData!),
          ],
        );
      }
    },
  );
}

}

class PinnedTextDisplay extends StatefulWidget {
  final String userId;

  PinnedTextDisplay({Key? key, required this.userId}) : super(key: key);

  @override
  _PinnedTextDisplayState createState() => _PinnedTextDisplayState();
}

class _PinnedTextDisplayState extends State<PinnedTextDisplay> {
  late Future<Map<String, dynamic>> _latestThreadData;
  late Future<Map<String, dynamic>> _pinnedData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    String documentPath = 'users/${widget.userId}';
    _latestThreadData = FirebaseComponents().getSpecificData(documentPath: documentPath);

    Map<String, dynamic> latestThreadData = await _latestThreadData;
    String pinnedDocPath = latestThreadData['pinned'][2];
    
    setState(() {
      _pinnedData = FirebaseComponents().getSpecialData(documentPath: pinnedDocPath);
    });
  }




@override
Widget build(BuildContext context) {
  return FutureBuilder<Map<String, dynamic>>(
    future: _pinnedData, // Use _pinnedData here instead of _latestThreadData
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Container();
      } else {
        var pinnedData = snapshot.data; // This is the data for _pinnedData
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThoughtDisplay(data: pinnedData!),
          ],
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

class PinnedSongDisplay extends StatefulWidget {
  final String userId;

  PinnedSongDisplay({Key? key, required this.userId}) : super(key: key);

  @override
  _PinnedSongDisplayState createState() => _PinnedSongDisplayState();
}

class _PinnedSongDisplayState extends State<PinnedSongDisplay> {
  late Future<Map<String, dynamic>> _latestThreadData;
  late Future<Map<String, dynamic>> _pinnedData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    String documentPath = 'users/${widget.userId}';
    _latestThreadData = FirebaseComponents().getSpecificData(documentPath: documentPath);

    Map<String, dynamic> latestThreadData = await _latestThreadData;
    String pinnedDocPath = latestThreadData['pinned'][0];
    
    setState(() {
      _pinnedData = FirebaseComponents().getSpecialData(documentPath: pinnedDocPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _pinnedData, // Use _pinnedData here instead of _latestThreadData
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Container();
        } else {
          var data = snapshot.data!; // This is the data for _pinnedData
          return SongRow(imageUrl: data['image_urls'][1], songTitle: data['title'], songArtist: data['artists'], timestamp: data['timestamp'], audioUrl: data['image_urls'][0], albumId: data['album_id'], userID: data['user_id'], tags: data['tags'], barColor: Colors.green, uniqueID: data['unique_id']); //Changed from ThoughtDisplay to SongDisplay
        }
      },
    );
  }
}

