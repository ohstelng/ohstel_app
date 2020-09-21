import 'package:Ohstel_app/explore/models/category.dart';
import 'package:Ohstel_app/explore/models/location.dart';
import 'package:Ohstel_app/explore/widgets/category.dart';
import 'package:Ohstel_app/explore/widgets/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utilities/app_style.dart';

class ExploreDashboard extends StatefulWidget {
  @override
  _ExploreDashboardState createState() => _ExploreDashboardState();
}

class _ExploreDashboardState extends State<ExploreDashboard> {
  PageController _pageController;
  final exploreRef = FirebaseFirestore.instance.collection('explore');
  final exploreCategoriesRef = FirebaseFirestore.instance
      .collection('explore')
      .doc('categories')
      .collection('allCategories');
  final exploreLocationsRef = FirebaseFirestore.instance
      .collection('explore')
      .doc('locations')
      .collection('allLocations');

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.90,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  buildCategories() {
    return FutureBuilder(
        future: exploreCategoriesRef.orderBy('name').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<ExploreCategoryWidget> _categories = [];

          snapshot.data.docs.forEach((doc) {
            _categories.add(
              ExploreCategoryWidget(
                ExploreCategory.fromDocs(
                  doc.data(),
                ),
              ),
            );
          });

          return ConstrainedBox(
            constraints: BoxConstraints.expand(height: 100.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 10.0),
              children: _categories,
            ),
          );
        });
  }

  Widget buildLocations() {
    return Container(
      height: 500.0,
      child: PageView(
        controller: _pageController,
        children: [
          ExploreLocationWidget(),
          ExploreLocationWidget(),
          ExploreLocationWidget(),
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
          SizedBox(
            height: 20.0,
          ),
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
