import 'package:Ohstel_app/hostel_hire/methods/hire_methods.dart';
import 'package:Ohstel_app/hostel_hire/pages/all_hire_categories_page.dart';
import 'package:Ohstel_app/hostel_hire/pages/hire_search_page.dart';
import 'package:Ohstel_app/hostel_hire/pages/selected_categories_page.dart';
import 'package:flutter/material.dart';

class HireHomePage extends StatefulWidget {
  @override
  _HireHomePageState createState() => _HireHomePageState();
}

class _HireHomePageState extends State<HireHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            searchBar(),
            advert(),
            Container(
              margin: EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HireAllCategoriesPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text('Veiw All'),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            categories(),
          ],
        ),
      ),
    );
  }

  Widget categories() {
    List<Map> categoriesList = HireMethods().catList;

    return Expanded(
      child: GridView.count(
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(
          categoriesList.length,
          (index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectedHireCategoryPage(
                      searchKey: categoriesList[index]['searchKey'],
                    ),
                  ),
                );
              },
              child: Container(
                child: Card(
                  color: Colors.grey,
                  child: Center(
                    child: Text('${categoriesList[index]['searchKey']}'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget advert() {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width * .95,
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Text('Adverts'),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HireSearchPage(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Search'),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}
