import 'package:flutter/material.dart';

import '../../landing_page/custom_navigation_bar.dart';
import '../../utilities/app_style.dart';

class ExploreDashboard extends StatefulWidget {
  @override
  _ExploreDashboardState createState() => _ExploreDashboardState();
}

class _ExploreDashboardState extends State<ExploreDashboard> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.90,
    );
  }

  buildCategories() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 100.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 10.0),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.orange,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.orange,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.orange,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.orange,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.orange,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLocations() {
    return Container(
      height: 450.0,
      child: PageView(
        controller: _pageController,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        leading: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
        ],
        title: Text(
          'Explore',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF4F4F4),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCategories(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'My locations',
                  textAlign: TextAlign.start,
                  style: heading2,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              buildLocations(),
            ],
          ),
        ],
      ),
    );
  }
}
