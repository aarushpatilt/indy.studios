  import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MainAppFlows/MoodDiscoveryView.dart';
import 'package:ndy/FrontEnd/MainAppFlows/Profile.dart';
import 'package:ndy/FrontEnd/MainAppFlows/SearchMasterView.dart';

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

  class CustomTabPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return CustomTabController(
        tabs: const ['MUSIC', 'MOOD', 'SEARCH', 'PROFILE'],
        tabViews: [
          const MusicDiscoveryView(),
          MoodDiscoveryView(),
          SearchMasterView(),
          Profile(),
        ],
      );
    }
  }

  
