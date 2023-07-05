import 'package:flutter/material.dart';
import 'package:ndy/FrontEndComponents/CustomTabController.dart';
import 'MoodDiscoveryView.dart';
import 'MusicDiscoveryView.dart';

class CustomTabPanel extends StatelessWidget {
  final TabController tabController;

  CustomTabPanel({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 30,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 75.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(Icons.circle_outlined, color: Colors.white),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TabBar(
                    controller: tabController,
                    indicatorColor: Colors.white,
                    tabs: const [
                      Tab(text: 'mood'),
                      Tab(text: 'music'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(Icons.circle_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              MoodDiscoveryView(),
              CustomTabPage(),
            ],
          ),
          CustomTabPanel(tabController: _tabController),
        ],
      ),
    );
  }
}
