import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import '../../Backend/FirebaseComponents.dart';
import '../Backend/GlobalComponents.dart';
import '../FrontEnd/MainAppFlows/SongMoodView.dart';
import '../FrontEnd/MenuFlow/CommentView.dart';
import 'CustomTabController.dart';
import 'TextComponents.dart';
import 'package:visibility_detector/visibility_detector.dart';


class VideoPlayerModel extends ChangeNotifier {
  late VideoPlayerController controller;
  bool isPlaying = false;

  void initialize(String url) {
    controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        notifyListeners();
      });
  }

  void play() {
    isPlaying = true;
    controller.play();
    notifyListeners();
  }

  void pause() {
    isPlaying = false;
    controller.pause();
    notifyListeners();
  }

  void dispose() {
    controller.dispose();
  }
}


class VideoPlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerModel>(
      builder: (context, model, _) => model.controller.value.isInitialized
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: model.controller.value.aspectRatio,
                  child: VideoPlayer(model.controller),
                ),
                FloatingActionButton(
                  onPressed: () {
                    model.isPlaying ? model.pause() : model.play();
                  },
                  child: Icon(
                    model.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}

class MoodTile extends StatefulWidget {
  final String mediaUrl;
  final String audioUrl;
  final String username;
  final String profileUrl;
  final List<dynamic> tags;
  final String caption;
  final String title;
  final String imageUrl;
  final String uniqueID;
  final String userID;
  final String albumID;
  final String musicID;

  const MoodTile({
    required this.mediaUrl,
    required this.audioUrl,
    required this.username,
    required this.profileUrl,
    required this.tags,
    required this.caption,
    required this.title,
    required this.imageUrl,
    required this.uniqueID,
    required this.userID,
    required this.albumID,
    required this.musicID
  });

  @override
  _MoodTileState createState() => _MoodTileState();
}

class _MoodTileState extends State<MoodTile> with AutomaticKeepAliveClientMixin<MoodTile> {
  late VideoPlayerController _controller;
  late bool isVideo;

  @override
  void initState() {
    super.initState();
    var uri = Uri.parse(widget.mediaUrl);
    var path = uri.path;
    isVideo = path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov');
    if(isVideo) {
      _controller = VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    if(isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Column(
        children: [
          VisibilityDetector(
            key: Key(widget.mediaUrl),
            onVisibilityChanged: (VisibilityInfo info) {
              if(isVideo) {
                if (info.visibleFraction == 1) {
                  _controller.play();
                } else {
                  _controller.pause();
                }
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: GlobalVariables.properHeight - 85),
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: isVideo ? 
                        (_controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : Container()) : 
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: GlobalVariables.properWidth,
                            maxHeight: GlobalVariables.properHeight,
                          ),
                          child: Image.network(
                            widget.mediaUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ProfileText600(text: widget.tags.map((tag) => tag.toString().toUpperCase()).join(', '), size: 10),
                                      const Spacer(), 
                                      LikeDislikeWidget(type: "moods", uniqueID: widget.uniqueID, userID: widget.userID, size: 20),
                                      const SizedBox(width: GlobalVariables.smallSpacing),
                                      const Icon(
                                        Icons.repeat,
                                        color: Color.fromARGB(255, 90, 90, 90),
                                        size: 20.0,
                                      ),
                                      const SizedBox(width: GlobalVariables.smallSpacing),
                                      CommentIcon(size: 20, userID: widget.userID, type: 'moods', uniqueID: widget.uniqueID)
                                    ],
                                  ),
                                  const SizedBox(height: 17),
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          width: 25.0,
                                          height: 25.0,
                                          child: Image.network(widget.profileUrl),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ProfileText400(text: widget.username, size: 15),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ProfileText400(text: widget.caption, size: 15),
                                            const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.circle_outlined,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 8), 
                                                Text(
                                                  widget.title,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => 
                                                SongMoodsView(
                                                  albumID: widget.albumID,
                                                  musicId: widget.musicID, 
                                                  isAlbum: widget.imageUrl.contains('%2Falbums%2F'),
                                                  userID: widget.userID
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(widget.imageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  @override
  bool get wantKeepAlive => true;
}
