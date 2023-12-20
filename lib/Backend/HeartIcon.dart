import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'GlobalComponents.dart';

class HeartIcon extends StatefulWidget {
  final double size;
  final String userID;

  HeartIcon({required this.size, required this.userID});

  @override
  _HeartIconState createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  Future<void> checkIfFollowing() async {
    var doc = await FirebaseFirestore.instance
        .doc('users/${widget.userID}/followers/${GlobalVariables.userUUID}')
        .get();

    setState(() {
      isFollowing = doc.exists;
    });
  }

Future<void> followUser() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference userStatsRef = firestore.doc('users/${widget.userID}');

  return firestore.runTransaction((transaction) async {
    // Get the user's stats
    DocumentSnapshot userStatsSnapshot = await transaction.get(userStatsRef);

    if (!userStatsSnapshot.exists) {
      throw Exception("User does not exist!");
    }

    // Increase follower count
    List<dynamic> stats = List.from(userStatsSnapshot.get('stats'));
    stats[1] = stats[1] + 1;

    transaction.update(userStatsRef, {
      'stats': stats
    });

    // Follow the user
    transaction.set(
      firestore.doc('users/${widget.userID}/followers/${GlobalVariables.userUUID}'),
      {
        'ref': 'users/${GlobalVariables.userUUID}',
        'timestamp': FieldValue.serverTimestamp(),
      }
    );
  }).then((value) {
    setState(() {
      isFollowing = true;
    });
  });
}


Future<void> unFollowUser() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference userStatsRef = firestore.doc('users/${widget.userID}');

  return firestore.runTransaction((transaction) async {
    // Get the user's stats
    DocumentSnapshot userStatsSnapshot = await transaction.get(userStatsRef);

    if (!userStatsSnapshot.exists) {
      throw Exception("User does not exist!");
    }

    // Decrease follower count
    List<dynamic> stats = List.from(userStatsSnapshot.get('stats'));
    stats[1] = stats[1] - 1;

    transaction.update(userStatsRef, {
      'stats': stats
    });

    // Unfollow the user
    transaction.delete(
      firestore.doc('users/${widget.userID}/followers/${GlobalVariables.userUUID}')
    );
  }).then((value) {
    setState(() {
      isFollowing = false;
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFollowing ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: widget.size,
      ),
      onPressed: isFollowing ? unFollowUser : followUser,
    );
  }
}
