import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_product_page.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketSearchPage extends StatefulWidget {
  @override
  _MarketSearchPageState createState() => _MarketSearchPageState();
}

class _MarketSearchPageState extends State<MarketSearchPage> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<ProductModel> searchList = [];
  String query = '';
  bool isStillLoadingData = false;
  bool moreProductAvailable = true;
  bool gettingMoreProduct = false;
  bool searchStarted = false;
  ProductModel lastProduct;
  String uniName;
  String lastQuery;

  Future<void> getUserDetails() async {
    uniName = await HiveMethods().getUniName();
  }

  void search() {
    setState(() {
      searchStarted = true;
      isStillLoadingData = true;
    });

    try {
      MarketMethods()
          .getProductByKeyword(keyword: query)
          .then((List<ProductModel> list) {
        setState(() {
          if (list.isNotEmpty) {
            if (list.length < 5) {
              moreProductAvailable = false;
            } else {
              moreProductAvailable = true;
            }

            searchList = list;
            lastProduct = searchList[searchList.length - 1];
            isStillLoadingData = false;
          } else {
            searchList = list;
            isStillLoadingData = false;
          }
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);

      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void getMore() {
    if (moreProductAvailable == false) {
      return;
    }

    if (gettingMoreProduct == true) {
      return;
    }

    try {
      gettingMoreProduct = true;
      MarketMethods()
          .getMoreProductByKeyword(keyword: query, lastProduct: lastProduct)
          .then((List<ProductModel> list) {
        setState(() {
          if (list.length < 3) {
            moreProductAvailable = false;
          }

          searchList.addAll(list);
          lastProduct = searchList[searchList.length - 1];

          gettingMoreProduct = false;
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
    }
  }

  void startSearch() {
    if (query.trim() != '') {
      search();
      searchController.clear();
    }
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      getMore();
    }
  }

  @override
  void initState() {
    getUserDetails();
    scrollController.addListener(() {
      _scrollListener();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            customSearchBar(),
            searchStarted
                ? Expanded(
                    child: isStillLoadingData == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: resultList(),
                          ),
                  )
                : greetingWidget(),
          ],
        ),
      ),
    );
  }

  Widget resultList() {
    if (searchList.isEmpty || searchList == null) {
      return notFound();
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: searchList.length,
        controller: scrollController,
        itemBuilder: ((context, index) {
          ProductModel currentProductModel = searchList[index];
          return Column(
            children: <Widget>[
              Card(
                elevation: 1.5,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectedProductPage(
                            productModel: currentProductModel),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        displayMultiPic(
                            imageList: currentProductModel.imageUrls),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child:
                                productDetails(product: currentProductModel)),
                      ],
                    ),
                  ),
                ),
              ),
              index == (searchList.length - 1)
                  ? Container(
                      height: 50,
                      child: Center(
                        child: moreProductAvailable == false
                            ? Container()
                            : CircularProgressIndicator(),
                      ),
                    )
                  : Container(),
            ],
          );
        }),
      );
    }
  }

  Widget productDetails({@required ProductModel product}) {
    return Container(
      margin: EdgeInsets.only(left: 2.0),
      constraints: BoxConstraints(
        maxHeight: 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          isShippedFromDifferentState(origin: product.productOriginLocation),
          productNameAndPriceDetails(product: product),
        ],
      ),
    );
  }

  Widget productNameAndPriceDetails({@required ProductModel product}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Text(
            '${product.productName} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '₦ ${product.productPrice}',
            style: TextStyle(
              color: Color(0xffc4c4c4),
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '${product.productDescription}',
            style: TextStyle(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget isShippedFromDifferentState({@required String origin}) {
    if (uniName != null) {
      if (uniName != origin) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
          ),
          child: Text(
            'Shipped From Other State',
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container(
        child: Text('Error!'),
      );
    }
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 150,
        maxWidth: MediaQuery.of(context).size.width * .35,
      ),
      child: imageList != null
          ? Carousel(
              images: imageList.map(
                (images) {
                  return Container(
                    child: ExtendedImage.network(
                      images,
                      fit: BoxFit.fill,
                      handleLoadingProgress: true,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      cache: false,
                      enableMemoryCache: true,
                    ),
                  );
                },
              ).toList(),
              autoplay: true,
              indicatorBgPadding: 0.0,
              dotPosition: DotPosition.bottomCenter,
              dotSpacing: 15.0,
              dotSize: 4,
              dotIncreaseSize: 2.5,
              dotIncreasedColor: Theme.of(context).primaryColor,
              dotBgColor: Colors.transparent,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(milliseconds: 2000),
            )
          : Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(Icons.image),
              ),
            ),
    );
  }

  Widget customSearchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              textInputAction: TextInputAction.search,
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  query = val.trim();
                });
              },
              onSubmitted: (_) {
                startSearch();
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by Product Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget notFound() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.local_hotel,
                  color: Colors.grey,
                  size: 85.0,
                ),
                Text(
                  'Sorry No Product Was Found With The keyWord $query :(',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget greetingWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.local_grocery_store,
              color: Colors.grey,
              size: 85.0,
            ),
            Text(
              'Search For Product By Name',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
