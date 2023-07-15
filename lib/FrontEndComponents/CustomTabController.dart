  import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MainAppFlows/MoodDiscoveryView.dart';
import 'package:ndy/FrontEnd/MainAppFlows/Profile.dart';
import 'package:ndy/FrontEnd/MainAppFlows/SearchMasterView.dart';
import 'package:ndy/FrontEnd/MainAppFlows/ThreadDiscoveryView.dart';
import 'package:ndy/FrontEnd/MainAppFlows/UploadMasterView.dart';

  import '../Backend/GlobalComponents.dart';
import '../FrontEnd/MainAppFlows/Feed.dart';
  import '../FrontEnd/MainAppFlows/MusicDiscoveryView.dart';
  import '../FrontEnd/MediaUploadFlows/MusicDiscoverView.dart';
  import 'TextComponents.dart';

  class CustomTabController extends StatefulWidget {
    final List<String> tabs;
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
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs
                .map((tab) => Tab(child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),  // Adjust this value to suit your needs
                  child: ProfileText500(text: tab, size: 10),
                )))
                .toList(),
            indicatorColor: Colors.transparent, // This makes the indicator invisible
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
      tabs: const ['MUSIC', 'THREAD', 'UPLOAD', 'SEARCH', 'PROFILE'],
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

  CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.circle_outlined,
                size: 25.0,
                color: Color.fromARGB(255, 142, 57, 57),
              ),
              padding: const EdgeInsets.all(0),
              onPressed: () {},
            ),
            const ProfileText500(
              text: 'DISCOVER',
              size: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.circle_outlined,
                size: 25.0,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(0),
              onPressed: () {
                // TODO: Add implementation
              },
            ),
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
      initialIndex: 1,  // The 'RUNNER' tab is now the default tab
      child: Scaffold(
        backgroundColor: Colors.transparent, // Making Scaffold background transparent
        body: Stack(
          children: [
            TabBarView(
              children: [
                MoodDiscoveryView(),
                const MusicDiscoveryView(),
                // You need to replace the Container with the widget you want to show for the 'RUNNER' tab.
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0), // Top and horizontal padding
              child: Material(
                color: Colors.transparent,  // Making Material background transparent
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, size: 25, color: Colors.white), // Leading Icon
                    Expanded(
                      child: TabBar(
                        indicator: BoxDecoration(), // Removes the blue underline
                        unselectedLabelColor: Colors.grey, // Unselected tab text color
                        labelColor: Colors.white, // Selected tab text color
                        tabs: [
                          Tab(
                            child: Text(
                              'DISCOVER',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'RUNNER',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.circle_outlined, size: 25, color: Colors.white), // Trailing Icon
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
