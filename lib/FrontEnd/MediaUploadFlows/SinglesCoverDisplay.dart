import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ndy/FrontEndComponents/CustomTabController.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import 'AlbumUploadView.dart'; // Required for date formatting

class SingleCoverDisplay extends StatefulWidget {
  final String userID;
  final String singleID;

  SingleCoverDisplay({required this.userID, required this.singleID});

  @override
  _SingleCoverDisplayState createState() => _SingleCoverDisplayState();
}

class _SingleCoverDisplayState extends State<SingleCoverDisplay> {
  late Future<Map<String, dynamic>> _specificDataFuture;

  @override
  void initState() {
    super.initState();
    _specificDataFuture = FirebaseComponents().getSpecificData(
      documentPath: 'users/${widget.userID}/singles/${widget.singleID}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _specificDataFuture,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var data = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: GlobalVariables.mediumSpacing,
                                left: GlobalVariables.horizontalSpacing,
                                right: GlobalVariables.horizontalSpacing,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: GlobalVariables.largeSpacing + 10),
                                      ProfileText500(
                                      text: (data['tags'] as List<dynamic>)
                                          .map((tag) => tag.toString().toUpperCase())
                                          .join(', '), size: 10),
                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SubTitleText(text: '${data['title']}'),
                                                const SizedBox(height: GlobalVariables.smallSpacing - 5),
                                                const Row(
                                                  children: [
                                                    ProfileText400(text: "SINGLE, ", size: 10),
                                                    InformationText(text: ''),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ClipOval(
                                            child: Container(
                                              width: 70.0,
                                              height: 70.0,
                                              child: FirstImageDisplay(
                                                  documentPath: 'users/${widget.userID}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: GlobalVariables.largeSpacing),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(data['image_urls'][1]),
                                ),

                                  const SizedBox(height: GlobalVariables.largeSpacing),
                                  ProfileText400(text: '${data['description']}', size: 12),
                                  const SizedBox(height: GlobalVariables.largeSpacing),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
                                child: SongImageDisplay(
                                  url: data['image_urls'][1],
                                  title: data['title'],
                                  artists: data['artists'],
                                ),
                              ),
                            const SizedBox(height: 50)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const CustomBackBar(title: "SINGLE"),
              ],
            ),
          );
        }
      },
    );
  }
}
