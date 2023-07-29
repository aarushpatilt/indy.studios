import 'package:flutter/material.dart';
import '../../Backend/FirebaseComponents.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/CustomTabController.dart';
import '../../FrontEndComponents/TextComponents.dart';

class CommentIcon extends StatelessWidget {
  final String userID;
  final String uniqueID;
  final String type;
  final double size;
  String? albumID;

  CommentIcon({
    required this.userID,
    required this.uniqueID,
    required this.type,
    required this.size,
    this.albumID
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentSection(
              userID: userID,
              uniqueID: uniqueID,
              type: type,
              albumID: albumID,
            ),
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        child: Icon(Icons.circle_outlined, color: Colors.grey, size: size),
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  final String userID;
  final String uniqueID;
  final String type;
  String? albumID;

  CommentSection({
    required this.userID,
    required this.uniqueID,
    required this.type,
    this.albumID
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  List<Map<String, dynamic>> comments = [];
  bool isCommenting = false;

  void addComment() async {
    String documentID = GlobalVariables().generateUUID().toString();
    final comment = {
      'ref': GlobalVariables.userUUID,
      'text': GlobalVariables.inputOne.text,
    };
    setState(() {
      comments.add(comment);
      isCommenting = true;
    });
    if(widget.type == "albums"){
      print("HEY");
      print(widget.albumID);
      await FirebaseComponents().setEachDataToFirestore(
        'users/${widget.userID}/${widget.type}/${widget.albumID}/collections/${widget.uniqueID}/comments/$documentID',
        comment,
      );
    } else {
      await FirebaseComponents().setEachDataToFirestore(
        'users/${widget.userID}/${widget.type}/${widget.uniqueID}/comments/$documentID',
        comment,
      );
    }
    setState(() {
      isCommenting = false;
    });
    GlobalVariables.inputOne.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomBackBar(),
          ),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GlobalVariables.horizontalSpacing,
                vertical: 0,
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: widget.albumID != null ? 
                  FirebaseComponents().getCollectionData(
                      collectionPath:  'users/${widget.userID}/${widget.type}/${widget.albumID}/collections/${widget.uniqueID}/comments',
                  )
                  :
                  FirebaseComponents().getCollectionData(
                      collectionPath: '/users/${widget.userID}/${widget.type}/${widget.uniqueID}/comments',
                  ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: ProfileText500(
                        text: "No comments on post",
                        size: 15,
                      ),
                    );
                  }
                  comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final commentData = comments[index];
                      return Column(children: [

                        CommentDisplay(
                          userID: commentData['ref'],
                          text: commentData['text'],
                        ),
                        const SizedBox(height: GlobalVariables.mediumSpacing)
                      ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 25,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GlobalVariables.horizontalSpacing,
              ),
              child: Row(
                children: [
                  ProfilePicture(size: 35),
                  const SizedBox(width: GlobalVariables.smallSpacing),
                  Expanded(
                    child: ClearFilledTextField(
                      labelText: "comment",
                      width: 75,
                      controller: GlobalVariables.inputOne,
                    ),
                  ),
                  const SizedBox(width: GlobalVariables.smallSpacing),
                  GestureDetector(
                    onTap: addComment,
                    child: isCommenting
                        ? const CircularProgressIndicator()
                        : const ProfileText400(text: "ENTER", size: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class CommentDisplay extends StatelessWidget {
  final String userID;
  final String text;

  CommentDisplay({
    required this.userID,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: FirebaseComponents().getSpecificData(
        documentPath: '/users/$userID',
        fields: ['image_urls', 'username'],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final returnData = snapshot.data!;
        final profilePictureURL = returnData['image_urls'][0];

        return Row(
          children: [
            ClipOval(
              child: Image.network(
                profilePictureURL,
                width: 35,
                height: 35,
              ),
            ),
            const SizedBox(width: GlobalVariables.smallSpacing - 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileText500(
                  text: returnData['username'],
                  size: 12,
                ),
                const SizedBox(height: 4),
                ProfileText400(
                  text: text,
                  size: 12,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
