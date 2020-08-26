import 'package:Ohstel_app/hostel_market_place/pages/selected_categrioes_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20.0),
          child: PaginateFirestore(
            scrollDirection: Axis.vertical,
            itemsPerPage: 3,
            physics: BouncingScrollPhysics(),
            initialLoader: Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomLoader: Center(
              child: CircularProgressIndicator(),
            ),
            shrinkWrap: true,
            query: Firestore.instance
                .collection('market')
                .document('categories')
                .collection('productsList')
                .orderBy('searchKey', descending: false),
            itemBuilder: (context, DocumentSnapshot documentSnapshot) {
              Map data = documentSnapshot.data;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: Card(
                  elevation: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SelectedCategoriesPage(
                            title: data['searchKey'],
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
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ExtendedImage.network(
                            data['imageUrl'],
                            fit: BoxFit.fill,
                            handleLoadingProgress: true,
                            shape: BoxShape.rectangle,
                            cache: false,
                            enableMemoryCache: true,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              '${data['searchKey']}',
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
