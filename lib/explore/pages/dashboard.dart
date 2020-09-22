import 'package:Ohstel_app/explore/models/category.dart';
import 'package:Ohstel_app/explore/models/location.dart';
import 'package:Ohstel_app/explore/pages/user_tickets.dart';
import 'package:Ohstel_app/explore/widgets/category.dart';
import 'package:Ohstel_app/explore/widgets/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utilities/app_style.dart';

class ExploreDashboard extends StatefulWidget {
  @override
  _ExploreDashboardState createState() => _ExploreDashboardState();
}

class _ExploreDashboardState extends State<ExploreDashboard> {
  PageController _pageController;
  String _category;
  String _searchText = "";
  bool _isSearch = false;

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
  // TODO: CONFIGURE LOCATIONS TO SHOW FOR ONLY USER INSTITUTTIONS

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
                    _isSearch = false;
                    _category = doc.data()['name'];
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

  buildLocations({String category, bool isSearch, String searchText}) {
    return FutureBuilder(
        future: isSearch
            ? exploreLocationsRef
                .where('name', isGreaterThanOrEqualTo: searchText)
                .where('name', isLessThan: searchText + 'z')
                .get()
            : category == null || category == ''
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
              ),
            );
          }

          if (snapshot.hasError) {
            return Column(
              children: [
                Icon(Icons.error),
                Text('Error Loading Locations'),
              ],
            );
          }

          print(snapshot.data.docs);
          print(_isSearch);
          print(_searchText);

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
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.grey),
          onPressed: () => showSearchButtomSheet(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserTickets())),
              child: CircleAvatar(
                radius: 18.0,
                backgroundColor: Theme.of(context).primaryColor,
                child: ImageIcon(
                  AssetImage('asset/ticket.png'),
                  color: Colors.white,
                ),
              ),
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
                buildLocations(
                  category: _category,
                  isSearch: _isSearch,
                  searchText: _searchText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showSearchButtomSheet(context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    color: Colors.green[50],
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Search For a Location",
                        suffixIcon: Icon(Icons.location_city),
                        border: InputBorder.none,
                      ),
                      autofocus: true,
                      onChanged: (String value) {
                        _searchText = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: FlatButton(
                      onPressed: () {
                        print(_searchText);
                        setState(() {
                          _isSearch = true;
                        });
                        Navigator.pop(context);
                      },
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Search',
                        style: body1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        });
  }
}
