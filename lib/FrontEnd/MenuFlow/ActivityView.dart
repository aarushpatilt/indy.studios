import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import '../../FrontEndComponents/CustomTabController.dart';
import 'package:video_player/video_player.dart';

import '../../FrontEndComponents/TextComponents.dart';
import '../MenuFlow/CommentView.dart';


class ActivityView extends StatefulWidget {
  ActivityView({Key? key}) : super(key: key);

  @override
  _ActivityViewState createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
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
    List<Map<String, dynamic>> newItems = await FirebaseComponents().getPaginatedReferencedData(collectionPath: 'users/${GlobalVariables.userUUID}/activity', limit: 20, T: 'R', startAfter: _lastDocument);

    if (newItems.isNotEmpty) {
      // Updating the _lastDocument from the Firebase Firestore reference
      _lastDocument = newItems[newItems.length - 1]['unique_id'];

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
                itemCount: _threadData.length + 1,
                itemBuilder: (context, index) {
                  if (index < _threadData.length) {
                    var data = _threadData[index];
                    return Container(
                      child:
                      Padding(
                        padding: const EdgeInsets.fromLTRB(GlobalVariables.horizontalSpacing, 0, GlobalVariables.horizontalSpacing, GlobalVariables.smallSpacing),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                data['image_urls'][1], 
                                width: 35, 
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: GlobalVariables.smallSpacing - 10),
                            ProfileText400(text: data['text'], size: 12)
                          ],
                        ),
                      )
                    );
                  } else if (_lastDocument != null) {
                    // Loading more data when reach the end of the list
                    _loadMoreData();
                    return Center(child: CircularProgressIndicator());
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
            child: CustomAppBar(),
          ),
        ],
      ),
    );
  }
}
