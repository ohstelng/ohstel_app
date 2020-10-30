import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/shop_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_shop_page.dart';
import 'package:Ohstel_app/utilities/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchShopsPage extends StatefulWidget {
  @override
  _SearchShopsPageState createState() => _SearchShopsPageState();
}

class _SearchShopsPageState extends State<SearchShopsPage> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<ShopModel> searchList = [];
  String query = '';
  bool isStillLoadingData = false;
  bool moreShopAvailable = true;
  bool gettingMoreShop = false;
  bool searchStarted = false;
  ShopModel lastShop;
  String lastQuery;

  void search() {
    setState(() {
      searchStarted = true;
      isStillLoadingData = true;
    });

    try {
      MarketMethods().searchPartnerShop(query).then((List<ShopModel> list) {
        setState(() {
          if (list.isNotEmpty) {
            if (list.length < 5) {
              moreShopAvailable = false;
            } else {
              moreShopAvailable = true;
            }

            searchList = list;
            lastShop = searchList[searchList.length - 1];
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
    if (moreShopAvailable == false) {
      return;
    }

    if (gettingMoreShop == true) {
      return;
    }

    try {
      gettingMoreShop = true;
      MarketMethods()
          .searchMorePartnerShop(query: query, lastShop: lastShop)
          .then((List<ShopModel> list) {
        setState(() {
          if (list.length < 3) {
            moreShopAvailable = false;
          }

          searchList.addAll(list);
          lastShop = searchList[searchList.length - 1];

          gettingMoreShop = false;
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
          children: [
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
//          shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: searchList.length,
        controller: scrollController,
        itemBuilder: ((context, index) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: searchList[index].imageUrl != null
                  ? Container(
                      height: 50.0,
                      width: 50.0,
                      child: cachedNetworkImage(searchList[index].imageUrl))
                  : Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Icon(Icons.image),
                      ),
                    ),
            ),
            title: Text(
              searchList[index].shopName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3A3A3A),
                fontFamily: 'Lato',
              ),
            ),
            subtitle: Text('${searchList[index].numberOfProducts} products'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectedShopPage(
                  searchList[index],
                ),
              ),
            ),
          );
        }),
      );
    }
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
                hintText: 'Search by Shop Name',
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
                  Icons.shop_two,
                  color: Colors.grey,
                  size: 85.0,
                ),
                Text(
                  'Sorry No Shop Was Found With The keyWord $query :(',
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
              'Search For Shop By Name',
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
