import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumUploadView.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import 'package:intl/intl.dart';

class AlbumSongDisplayUploadView extends StatefulWidget {
  final String albumID;

  AlbumSongDisplayUploadView({required this.albumID});

  @override
  _AlbumSongDisplayUploadViewState createState() =>
      _AlbumSongDisplayUploadViewState();
}

class _AlbumSongDisplayUploadViewState extends State<AlbumSongDisplayUploadView> {
  late Future<Map<String, dynamic>> _albumDataFuture;
  late CollectionDataDisplay _collectionDataDisplay; 

  @override
  void initState() {
    super.initState();
    print(widget.albumID);
    _albumDataFuture = FirebaseComponents().getSpecificData(
      documentPath: '/users/${GlobalVariables.userUUID}/albums/${widget.albumID}',
      fields: ['title', 'timestamp', 'tags', 'description', 'image_urls'],
    );
    _collectionDataDisplay = CollectionDataDisplay(  // create an instance of the new class
      collectionPath: '/users/5f0b7cc7-8235-4ac6-b0e6-dcd1ba3d3d9a/albums/22af7a8d-e92d-4ac5-887f-6e8401a86c7b/collections',
      fields: ['title', 'artists', 'image_urls'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color of the Scaffold
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.black, // Set the background color of the AppBar
            expandedHeight: MediaQuery.of(context).size.height / 2.5,  // half of the screen
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FittedBox( // Added FittedBox
                    child: FirstImageDisplay(documentPath: '/users/${GlobalVariables.userUUID}/albums/${widget.albumID}'),
                    fit: BoxFit.fill,  // Change BoxFit.cover to BoxFit.fill
                  ),
                  Container(  // black rectangle over the image
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                    future: _albumDataFuture,
                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: GlobalVariables.mediumSpacing,
                          left: GlobalVariables.horizontalSpacing,
                          right: GlobalVariables.horizontalSpacing,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // This aligns everything to the start (left)
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center, // This centers the children vertically
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SubTitleText(text: '${snapshot.data?['title']}'),
                                      const SizedBox(height: GlobalVariables.smallSpacing),
                                      Row(
                                        children: [
                                          const InformationText(text: "Album, "),
                                          InformationText(text: DateFormat('MMMM d yyyy').format(snapshot.data?['timestamp'].toDate())),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ClipOval(
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    child: FirstImageDisplay(documentPath: '/users/${GlobalVariables.userUUID}')
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: GlobalVariables.largeSpacing),
                            GenericTextSemi(text: '${(snapshot.data?['tags'] as List<dynamic>).map((tag) => tag.toString().toUpperCase())?.join(', ')}'),
                            SizedBox(height: GlobalVariables.largeSpacing),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlbumUploadView(
                                      albumID: widget.albumID,
                                      albumImageRef: (snapshot.data?['image_urls'] as List<dynamic>)[0].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "ADD SONG",
                                style: TextStyle(
                                  color: Colors.white, // or any other color
                                  fontSize: 18, // adjust to your needs
                                  decoration: TextDecoration.underline, // make the text underlined
                                ),
                              ),
                            )

                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: GlobalVariables.smallSpacing),
                  _collectionDataDisplay.displayData(),
                  const SizedBox(height: GlobalVariables.mediumSpacing),



                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
