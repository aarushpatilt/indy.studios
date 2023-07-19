  import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';
import 'package:ndy/FrontEnd/MainAppFlows/MoodDiscoveryView.dart';
import 'package:ndy/FrontEnd/MainAppFlows/Profile.dart';
import 'package:ndy/FrontEnd/MainAppFlows/SearchMasterView.dart';
import 'package:ndy/FrontEnd/MainAppFlows/ThreadDiscoveryView.dart';
import 'package:ndy/FrontEnd/MainAppFlows/UploadMasterView.dart';

  import '../Backend/GlobalComponents.dart';
import '../FrontEnd/MainAppFlows/Feed.dart';
  import '../FrontEnd/MainAppFlows/MusicDiscoveryView.dart';
  import '../FrontEnd/MediaUploadFlows/MusicDiscoverView.dart';
  import '../FrontEnd/MenuFlow/LikedMoodView.dart';
import '../FrontEnd/MenuFlow/LikedSongsView.dart';
import 'TextComponents.dart';

class CustomTabController extends StatefulWidget {
  final List<Widget> tabs;  // Type changed from List<String> to List<Widget>
  final List<Widget> tabViews;

  CustomTabController({required this.tabs, required this.tabViews});

  @override
  _CustomTabControllerState createState() => _CustomTabControllerState();
}

class _CustomTabControllerState extends State<CustomTabController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabViews,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0), // Adjust the bottom padding value as needed
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs.map((tab) => Container(
              height: 70, 
              child: Align(
                alignment: Alignment.center,
                child: tab,
              ),
            )).toList(),
            indicatorColor: Colors.transparent,
          ),
        ),
      ),

    );
  }
}



class CustomTabPage extends StatefulWidget {
  @override
  _CustomTabPageState createState() => _CustomTabPageState();
}

class _CustomTabPageState extends State<CustomTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showMoodDiscoveryView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _toggleMoodDiscoveryView() {
    setState(() {
      _showMoodDiscoveryView = !_showMoodDiscoveryView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTabController(
      tabs: [
        ProfileText400(text: 'MUSIC', size: 10), 
        ProfileText400(text: 'THREAD', size: 10),
        ProfileText400(text: 'UPLOAD', size: 10),
        ProfileText400(text: 'EXPLORE', size: 10),
        ProfilePicture(size: 25)
      ],
      tabViews: [
        const CustomSliderBar(),
        ThreadDiscoveryView(),
        UploadMasterView(),
        SearchMasterView(),
        Profile(userID: GlobalVariables.userUUID,),
      ],
    );
  }
}



class CustomAppBar extends StatelessWidget {
  const CustomAppBar();

@override
Widget build(BuildContext context) {
  return Container(
    color: Colors.black,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 50, 5, 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ProfilePicture(size: 30),
                  ),
                ),
              ),
            ),
          ),
          const ProfileText500(
            text: 'DISCOVER',
            size: 10,
          ),
          Expanded(
            child: Text(""),
          ),
          // Expanded(
          //   child: Builder(
          //     builder: (context) => IconButton(
          //       icon: const Icon(
          //         Icons.circle_outlined,
          //         size: 30.0,
          //         color: Color.fromARGB(255, 142, 57, 57),
          //       ),
          //       onPressed: () {
          //         Scaffold.of(context).openDrawer();
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    ),
  );
}


}


class CustomSliderBar extends StatelessWidget {
  const CustomSliderBar();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,  
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        drawer: const Drawer(
          child: MenuSideBar(),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                MoodDiscoveryView(),
                const MusicDiscoveryView(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
              child: Material(
                color: Colors.transparent,  
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: ProfilePicture(size: 30),
                      ),
                    ),
                    const Expanded(
                      child: TabBar(
                        indicator: BoxDecoration(),
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.white,
                        tabs: [
                          Tab(
                            child: Text(
                              'MOOD',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'MUSIC',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.circle_outlined, size: 30, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MenuSideBar extends StatelessWidget {
  const MenuSideBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      color: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 75),  // add left padding of 10
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,  // aligns the children to the start (left)
                    children: <Widget>[
                      ProfilePicture(size: 75),
                      const SizedBox(height: GlobalVariables.smallSpacing),
                      ProfileUsername(size: 25),
                      const SizedBox(height: GlobalVariables.mediumSpacing),
                      const ProfileText500(text: "activity", size: 20),                      
                      const SizedBox(height: GlobalVariables.smallSpacing),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LikedSongView(),
                            ),
                          );
                        },
                        child: const ProfileText500(text: "songs", size: 20),
                      ),
                     
                      const SizedBox(height: GlobalVariables.smallSpacing),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LikedMoodsView(),
                            ),
                          );
                        },
                        child: const ProfileText500(text: "moods", size: 20),
                      ),                      
                      const SizedBox(height: GlobalVariables.smallSpacing),
                      const ProfileText500(text: "thoughts", size: 20),                      
                      SizedBox(height:  MediaQuery.of(context).size.height * 0.35),
                      const ProfileText400(text: "edit", size: 15),  
                      const SizedBox(height: GlobalVariables.smallSpacing), 
                      const ProfileText400(text: "settings", size: 15), 

                      // add more widgets below to have them listed in a column
                      // for example:
                      // Text('User name'),
                      // Text('User bio'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
