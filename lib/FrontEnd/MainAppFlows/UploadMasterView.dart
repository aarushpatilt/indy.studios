import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MainAppFlows/CameraMultiUploadView.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumCoverUploadView.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';
import '../MediaUploadFlows/CameraUploadView.dart';
import '../MediaUploadFlows/MoodUploadView.dart';
import '../MediaUploadFlows/SingleUploadView.dart';

class UploadMasterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Align(
                alignment: Alignment.topCenter,
                child: ProfileText400(
                  text: "UPLOAD", 
                  size: 10
                ),
              ),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              const ProfileText400(text: "You can find anything you want to upload here", size: 12),
              const SizedBox(height: 5),
              const ProfileText400(text: "Your idea, presented any way you like", size: 12),
              const SizedBox(height: GlobalVariables.largeSpacing),
              
              InkWell(
                onTap: () {
                  // onTap functionality for the first row.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraMultiUploadView()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0), // Added leading padding.
                  child: Row(
                    children: [
                      Container(
                        width: 12, // Circle size reduced.
                        height: 12, // Circle size reduced.
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1, // Border width reduced.
                          ),
                        ),
                      ),
                      const SizedBox(width: GlobalVariables.smallSpacing), // Added spacing between circle and text.
                      const ProfileText400(text: "CREATE A POST", size: 10),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: GlobalVariables.largeSpacing),

              InkWell(
                onTap: () {
                  // onTap functionality for the second row.
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0), // Added leading padding.
                  child: Row(
                    children: [
                      Container(
                        width: 12, // Circle size reduced.
                        height: 12, // Circle size reduced.
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1, // Border width reduced.
                          ),
                        ),
                      ),
                      const SizedBox(width: GlobalVariables.smallSpacing), // Added spacing between circle and text.
                      const ProfileText400(text: "CREATE A THOUGHT", size: 10),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: GlobalVariables.largeSpacing),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraUploadView()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0), // Added leading padding.
                  child: Row(
                    children: [
                      Container(
                        width: 12, // Circle size reduced.
                        height: 12, // Circle size reduced.
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1, // Border width reduced.
                          ),
                        ),
                      ),
                      const SizedBox(width: GlobalVariables.smallSpacing), // Added spacing between circle and text.
                      const ProfileText400(text: "CREATE A MOOD", size: 10),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: GlobalVariables.largeSpacing),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SingleUploadView()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0), // Added leading padding.
                  child: Row(
                    children: [
                      Container(
                        width: 12, // Circle size reduced.
                        height: 12, // Circle size reduced.
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1, // Border width reduced.
                          ),
                        ),
                      ),
                      const SizedBox(width: GlobalVariables.smallSpacing), // Added spacing between circle and text.
                      const ProfileText400(text: "UPLOAD SINGLE", size: 10),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: GlobalVariables.largeSpacing),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlbumCoverUploadView()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0), // Added leading padding.
                  child: Row(
                    children: [
                      Container(
                        width: 12, // Circle size reduced.
                        height: 12, // Circle size reduced.
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1, // Border width reduced.
                          ),
                        ),
                      ),
                      const SizedBox(width: GlobalVariables.smallSpacing), // Added spacing between circle and text.
                      const ProfileText400(text: "UPLOAD ALBUM", size: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
