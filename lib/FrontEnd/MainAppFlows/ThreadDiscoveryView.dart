import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';

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
    _threadData = FirebaseComponents().getReferencedData(collectionPath: 'threads', limit: 8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _threadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
        padding: EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data['caption'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: GlobalVariables.smallSpacing),
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
        padding: EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data['caption'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: GlobalVariables.smallSpacing),
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
        String extension = filePath.split('.').last.toLowerCase();
        return Padding(
          padding: EdgeInsets.only(right: (index != widget.mediaFiles.length - 1) ? 15 : 0),
          child: Image.network(
            filePath,
            width: GlobalVariables.properWidth,
            height: GlobalVariables.properWidth,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
