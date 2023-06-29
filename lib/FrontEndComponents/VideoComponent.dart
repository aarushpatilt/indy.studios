import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import '../../Backend/FirebaseComponents.dart';
import '../Backend/GlobalComponents.dart';
import 'TextComponents.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
      ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
      : Container();
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

  const MoodTile({

    required this.mediaUrl,
    required this.audioUrl,
    required this.username,
    required this.profileUrl,
    required this.tags,
    required this.caption,
    required this.title,
    required this.imageUrl
  });

  @override
  _MoodTileState createState() => _MoodTileState();
}

class _MoodTileState extends State<MoodTile> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Column(
        children: [
          Container(
            height: GlobalVariables.properHeight - 85,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: VideoPlayerWidget(url: widget.mediaUrl),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,    // For proper positioning
                  right: 0,   // For proper positioning
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing), 
                    child: Row(
                      children: [
                        Expanded( // This makes sure the Column takes up all remaining space in the Row
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,  // This line aligns text to the left
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 25.0,
                                      height: 25.0,
                                      child: Image.network(widget.profileUrl)
                                    ),
                                  ),
                                  const SizedBox(width: GlobalVariables.smallSpacing - 5),
                                  GenericTextReg(text: widget.username),
                                ],
                              ),
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // This line aligns text to the left
                                      children: [
                                        const SizedBox(height: GlobalVariables.smallSpacing - 5),
                                        GenericTextReg(text: widget.caption),
                                        const SizedBox(height: GlobalVariables.smallSpacing - 10),
                                        GenericTextRegSmall(text: widget.title),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(widget.imageUrl), // replace 'IMAGE_URL' with your actual image url
                                          fit: BoxFit.cover,
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
          Container(
            height: 85,
            color: Colors.black,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                child: Row(
                  children: [
                    GenericTextSmall(text: widget.tags.map((tag) => tag.toString().toUpperCase()).join(', ')),
                    const Spacer(),
                    const Icon(
                      Icons.favorite_border,
                      color: Color.fromARGB(255, 90, 90, 90),
                      size: 20.0,
                    ),
                    const SizedBox(width: GlobalVariables.smallSpacing),
                    const Icon(
                      Icons.repeat,
                      color: Color.fromARGB(255, 90, 90, 90),
                      size: 20.0,
                    ),
                    const SizedBox(width: GlobalVariables.smallSpacing),
                    const Icon(
                      Icons.circle_outlined,
                      color: Color.fromARGB(255, 90, 90, 90),
                      size: 20.0,
                    ),
                  ]
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

}
