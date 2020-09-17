import 'package:Ohstel_app/hostel_hire/pages/selected_categories_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class HireAllCategoriesPage extends StatefulWidget {
  @override
  _HireAllCategoriesPageState createState() => _HireAllCategoriesPageState();
}

class _HireAllCategoriesPageState extends State<HireAllCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    return PaginateFirestore(
      scrollDirection: Axis.vertical,
      itemsPerPage: 3,
      physics: BouncingScrollPhysics(),
      initialLoader: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomLoader: Center(
        child: CircularProgressIndicator(),
      ),
      shrinkWrap: true,
      query: FirebaseFirestore.instance
          .collection('hire')
          .doc('categories')
          .collection('allCategories')
          .orderBy('searchKey'),
      itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
        Map data = documentSnapshot.data();

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: Card(
            elevation: 2.5,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectedHireCategoryPage(
                      searchKey: data['searchKey'],
                    ),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 200,
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ExtendedImage.network(
                      data['imageUrl'],
                      fit: BoxFit.fill,
                      handleLoadingProgress: true,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      cache: false,
                      enableMemoryCache: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      '${data['searchKey']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemBuilderType: PaginateBuilderType.listView,
    );
  }
}
