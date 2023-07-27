import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MainAppFlows/CameraMultiUploadView.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumCoverUploadView.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import '../Backend/FirebaseComponents.dart';
class OptionsIcon extends StatelessWidget {
  final double size;
  final String postReferencePath;
  final int position;

  OptionsIcon({required this.size, required this.postReferencePath, required this.position});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.white, size: size),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return OptionsBottomSheet(postReferencePath: postReferencePath, position: position,);
            },
          );
        },
      ),
    );
  }
}

class OptionsBottomSheet extends StatelessWidget {
  final String postReferencePath;
  final int position;

  OptionsBottomSheet({required this.postReferencePath, required this.position});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.25, // 25% of the screen height
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 50),
        child: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileText400(text: 'adding more options soon!', size: 12),
                const SizedBox(height: 35),
            GestureDetector(
              child: const Row(
                children: [
                  Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                  SizedBox(width: 15),
                  ProfileText400(text: "PIN IT!", size: 12),
                ],
              ),
              onTap: () {
                FirebaseComponents().setPin(postReferencePath, position);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 35),
            GestureDetector(
              child: const Row(
                children: [
                  Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                  SizedBox(width: 15),
                  ProfileText400(text: "DELETE", size: 12),
                ],
              ),
              onTap: () {
                print("HEY");
              },
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



