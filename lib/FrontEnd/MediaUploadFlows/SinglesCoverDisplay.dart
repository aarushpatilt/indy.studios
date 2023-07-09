import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var data = snapshot.data!;
          print(data);
          return Scaffold(
            backgroundColor: Colors.black,
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.black,
                  expandedHeight: MediaQuery.of(context).size.height / 2.5,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(data['image_urls'][1])
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                  ),
                ),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SubTitleText(text: '${data['title']}'),
                                        const SizedBox(height: GlobalVariables.smallSpacing),
                                        Row(
                                          children: [
                                            const InformationText(text: "Album, "),
                                            InformationText(text: DateFormat('MMMM d yyyy')
                                                .format(data['timestamp'].toDate())),
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
                              const SizedBox(height: GlobalVariables.largeSpacing),
                              GenericTextSemi(
                                  text: (data['tags'] as List<dynamic>)
                                      .map((tag) => tag.toString().toUpperCase())
                                      .join(', ')),
                              const SizedBox(height: GlobalVariables.largeSpacing),
                              GenericTextRegSmall(text: '${data['description']}'),
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
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
