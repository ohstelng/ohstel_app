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
  String _category;

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
            return Center(
                child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ));
          }

          List<Widget> _categories = [];

          snapshot.data.docs.forEach((doc) {
            _categories.add(
              GestureDetector(
                onTap: () {
                  setState(() {
                    _category = doc.data()['name'];
                    print('set cat successfully');
                  });
                },
                child: ExploreCategoryWidget(
                  ExploreCategory.fromDocs(
                    doc.data(),
                  ),
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

  buildLocations(String category) {
    return FutureBuilder(
        future: category == null || category == ''
            ? exploreLocationsRef.orderBy('dateAdded').get()
            : exploreLocationsRef
                .where('category', isEqualTo: category)
                .orderBy('dateAdded')
                .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ));
          }

          if (snapshot.hasError) {
            return Column(
              children: [
                Icon(Icons.error),
                Text('Error Loading Locations'),
              ],
            );
          }

          List<ExploreLocationWidget> _locations = [];

          snapshot.data.docs.forEach((doc) {
            _locations.add(
              ExploreLocationWidget(
                ExploreLocation.fromDoc(
                  doc.data(),
                ),
              ),
            );
          });

          return _locations.length > 0
              ? Container(
                  // initially 500.0
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: PageView(
                    controller: _pageController,
                    children: _locations,
                  ),
                )
              : Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('asset/OHstel.png'),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'No location at this moment',
                          style: heading1,
                        ),
                      ],
                    ),
                  ),
                );
        });
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
            fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF4F4F4),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                buildLocations(_category),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
