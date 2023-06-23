import 'package:flutter/material.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumCoverUploadView.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/SingleUploadView.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:ndy/FrontEndComponents/CustomTabController.dart';
import 'package:ndy/FrontEndComponents/TextComponents.dart';

import 'ArtistUploadView.dart';

class UpgradeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPrevious(text: "DISCOVER"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          GlobalVariables.horizontalSpacing,
          GlobalVariables.largeSpacing,
          GlobalVariables.horizontalSpacing,
          50,
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const GenericTextReg(text: "Want your music to be discovered?"),
              const GenericTextReg(text: "A few steps and you'll be ready"),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              Row(

                children: [

                  const SizedBox(width: GlobalVariables.horizontalSpacing),

                  const TransparentCircleWithBorder(),

                  ClearButton(
                      text: 'ADD SINGLE',
                      width: 125,
                      onPressed: () {

                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleUploadView(),
                            ),
                          );

                      },
                  ),

                ]
              ),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              Row(
                
                children: [

                  const SizedBox(width: GlobalVariables.horizontalSpacing),
                  const TransparentCircleWithBorder(),

                  ClearButton(
                      text: 'ADD ALBUM',
                      width: 125,
                      onPressed: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumCoverUploadView(),
                            ),
                          );
                      },
                  ),

                ]
              ),
              Expanded(
                child: Container(
                  width: GlobalVariables.properWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClearButton(
                        text: 'SKIP',
                        width: GlobalVariables.properWidth,
                        onPressed: () {},
                      ),
                      SizedBox(height: 10),
                      WhiteOutlineButton(
                        text: 'SUBMIT',
                        width: GlobalVariables.properWidth,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomTabPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
