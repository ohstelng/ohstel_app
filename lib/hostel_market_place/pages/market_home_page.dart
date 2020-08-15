import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/all_categories_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_cart_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_categrioes_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class MarketHomePage extends StatefulWidget {
  @override
  _MarketHomePageState createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  String uniName;

  Future<void> getUniName() async {
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;
  }

  @override
  void initState() {
    getUniName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              searchBar(),
              header(),
            ],
          ),
          advertBanner(),
          categories(),
          lastestProduct(),
        ],
      ),
    );
  }

  Widget lastestProduct() {
    return Expanded(
      child: PaginateFirestore(
        scrollDirection: Axis.horizontal,
        itemsPerPage: 3,
        initialLoader: Container(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomLoader: CircularProgressIndicator(),
        shrinkWrap: true,
        query: Firestore.instance
            .collection('market')
            .document('products')
            .collection('allProducts')
            .orderBy('dateAdded', descending: true)
            .where('uniLocation', isEqualTo: 'unilorin'),
        itemBuilder: (context, DocumentSnapshot documentSnapshot) {
//          print(documentSnapshot.data);
          ProductModel currentProductModel =
              ProductModel.fromMap(documentSnapshot.data);
          return Card(
            elevation: 2.5,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectedProductPage(
                      productModel: currentProductModel,
                    ),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      margin: EdgeInsets.all(10),
                      child: Container(
                        child: ExtendedImage.network(
                          currentProductModel.imageUrls[0],
                          fit: BoxFit.fill,
                          handleLoadingProgress: true,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          cache: false,
                          enableMemoryCache: true,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${currentProductModel.productName}'),
                        Text('\$${currentProductModel.productPrice}'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categories() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('categories'),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Text('See All'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AllCategories(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Flexible(
            child: SizedBox(
              height: 210,
              child: FutureBuilder(
                  future: MarketMethods().getAllCategories(),
                  builder: (context, snapshot) {
                    List<Map> currentDataList = snapshot.data;
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (currentDataList.isEmpty) {
                        return Container(
                          child: Center(
                            child: Text('Empty'),
                          ),
                        );
                      }
                      return GridView.count(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: List.generate(
                          currentDataList.length,
                          (index) {
                            Map currentData = snapshot.data[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelectedCategoriesPage(
                                      title: currentData['searchKey'],
                                      searchKey: currentData['searchKey'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: ExtendedImage.network(
                                        currentData['imageUrl'],
                                        fit: BoxFit.fill,
                                        handleLoadingProgress: true,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        cache: false,
                                        enableMemoryCache: true,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Text(
                                      '${currentData['searchKey']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget advertBanner() {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      height: 150,
      width: double.infinity,
      child: Center(child: Text('Adverts')),
    );
  }

  Widget searchBar() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Search For Product'),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.grey,
          ),
          onPressed: () {
//            saveProduct();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MarketCartPage(),
              ),
            );
          },
        )
      ],
    );
  }
}