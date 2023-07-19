import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';

import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';

import '../../FrontEndComponents/CustomTabController.dart';
import '../../FrontEndComponents/VideoComponent.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ThreadDiscoveryView extends StatefulWidget {
  ThreadDiscoveryView({Key? key}) : super(key: key);

  @override
  _ThreadDiscoveryViewState createState() => _ThreadDiscoveryViewState();
}

class _ThreadDiscoveryViewState extends State<ThreadDiscoveryView> {
  late Future<List<Map<String, dynamic>>> _threadData;

  @override
  void initState() {
    super.initState();
    _threadData = FirebaseComponents().getReferencedData(collectionPath: 'threads', limit: 5, T: "yes");
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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _threadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("");
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    if (data.containsKey('image_urls')) {
                      return Container(
                        child: PostDisplay(data: data),
                      );
                    }
                    return Container(
                      child: ThoughtDisplay(data: data)
                    );
                  },
                );
              }
            },
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBar(),
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
        padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: GlobalVariables.properWidth,
              child: MediaFilesDisplay(mediaFiles: data['image_urls'].cast<String>()),
            ),
            const SizedBox(height: GlobalVariables.smallSpacing),
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
            const SizedBox(height: 10),
            Text(
              data['caption'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: GlobalVariables.smallSpacing),
            Row(
              children: [
                LikeDislikeWidget(type: "threads", uniqueID: data['unique_id'], userID: data['user_id'], size: 15),
                const SizedBox(width: 10),
                const Icon(
                  Icons.circle_outlined,
                  color: Colors.white,
                  size: 15,
                ),
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
      width: GlobalVariables.properWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 10),
            Text(
              data['caption'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: GlobalVariables.smallSpacing),
            Row(
              children: [
                LikeDislikeWidget(type: "threads", uniqueID: data['unique_id'], userID: data['user_id'], size: 15),
                const SizedBox(width: 10),
                const Icon(
                  Icons.circle_outlined,
                  color: Colors.white,
                  size: 15,
                ),
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
            child: ThreadPlayer(videoUrl: filePath),
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

  ThreadPlayer({required this.videoUrl});

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
          width: GlobalVariables.properWidth - 50,
          height: GlobalVariables.properWidth - 50,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: VideoPlayer(_controller),
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
        )
      : Container();
}

}
