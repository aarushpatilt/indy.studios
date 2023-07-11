import 'package:flutter/material.dart';
import '../../Backend/GlobalComponents.dart';
import '../../FrontEndComponents/TextComponents.dart';

class SearchMasterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GlobalVariables.horizontalSpacing),
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.topCenter,
                child: ProfileText400(
                  text: "SEARCH", 
                  size: 10
                ),
              ),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              const ProfileText500(text: "More content will be avaliable soon!", size: 12),
              const ProfileText500(text: "For now, you can search songs and artists", size: 12),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              SearchSliderMenu(
                initialIndex: 0, 
                userID: GlobalVariables.userUUID
              ),
            ],
          ),
        ),
      ),
    );
  }
}

