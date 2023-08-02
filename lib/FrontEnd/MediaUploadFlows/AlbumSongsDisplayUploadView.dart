import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumUploadView.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import 'package:intl/intl.dart';

import '../../FrontEndComponents/CustomTabController.dart';

class AlbumSongDisplayUploadView extends StatefulWidget {
  final String albumID;
  final String userID;
  String? something;

  AlbumSongDisplayUploadView({required this.albumID, required this.userID, this.something});

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
    _albumDataFuture = FirebaseComponents().getSpecificData(
      documentPath: '/users/${GlobalVariables.userUUID}/albums/${widget.albumID}',
    );
    _collectionDataDisplay = CollectionDataDisplay(  // create an instance of the new class
      collectionPath: '/users/${GlobalVariables.userUUID}/albums/${widget.albumID}/collections',
      fields: ['title', 'artists', 'image_urls'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color of the Scaffold
      body: Stack(
        children: [
          
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: _albumDataFuture,
                        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: GlobalVariables.largeSpacing,
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
                                          const SizedBox(height: GlobalVariables.largeSpacing),
                                          ProfileText500(text: (snapshot.data?['tags'] as List<dynamic>).map((tag) => tag.toString().toUpperCase()).join(', '), size: 10),
                                          const SizedBox(height: GlobalVariables.smallSpacing),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // This will put as much space as possible between each child
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,  // This will make the text start from the left
                                                children: [
                                                  SubTitleText(text: '${snapshot.data?['title']}'),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ProfileText400(text: "ALBUM, ", size: 10),
                                                      ProfileText400(text: snapshot.data?['timestamp'], size: 10),
                                                    ],
                                                  ),
                                                ],
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: GlobalVariables.largeSpacing),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(snapshot.data!['image_urls'][0]),
                                ),
                                const SizedBox(height: GlobalVariables.largeSpacing),
                                ProfileText400(text: '${snapshot.data?['description']}', size: 12),
                                if(widget.userID == GlobalVariables.userUUID)
                                Column(
                                  children: [
                                    const SizedBox(height: GlobalVariables.largeSpacing),
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
                                      child: 
                                        const GenericTextSemi(text:
                                          "ADD SONG",
                                        ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      _collectionDataDisplay.displayData(),
                      const SizedBox(height: GlobalVariables.mediumSpacing),
                    ],
                  ),
                ),
              )
            ],
          ),
          const CustomBackBar(title: "ALBUM"),
        ],
      ),
    );
  }
}
