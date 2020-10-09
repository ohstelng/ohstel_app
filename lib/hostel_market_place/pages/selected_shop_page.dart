import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/hostel_market_place/models/shop_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_product_page.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:Ohstel_app/utilities/shared_widgets.dart';
import 'package:flutter/material.dart';

class SelectedShopPage extends StatefulWidget {
  final ShopModel shop;
  SelectedShopPage(this.shop);
  @override
  _SelectedShopPageState createState() => _SelectedShopPageState();
}

class _SelectedShopPageState extends State<SelectedShopPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  buildAllItems() {
    return FutureBuilder(
        future: MarketMethods().getShopItems(widget.shop.shopName),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data.length > 0
              ? GridView.builder(
                  padding: EdgeInsets.only(top: 24.0),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 21.0,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Center(child: ShopItemWidget(snapshot.data[index]));
                  },
                )
              : buildNoItem(context, text: 'Shop has no item.');
        });
  }

  buildGroceries() {
    return FutureBuilder(
        future: MarketMethods().getPartnerShopCategoryItems(
            shopName: widget.shop.shopName, category: 'Groceries'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data.length > 0
              ? GridView.builder(
                  padding: EdgeInsets.only(top: 24.0),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 21.0,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Center(child: ShopItemWidget(snapshot.data[index]));
                  },
                )
              : buildNoItem(context, text: 'Shop has no grocery item.');
        });
  }

  buildDrinks() {
    return FutureBuilder(
        future: MarketMethods().getPartnerShopCategoryItems(
            shopName: widget.shop.shopName, category: 'Toiletries'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data.length > 0
              ? GridView.builder(
                  padding: EdgeInsets.only(top: 24.0),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 21.0,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Center(child: ShopItemWidget(snapshot.data[index]));
                  },
                )
              : buildNoItem(context, text: 'Shop has no drink item.');
        });
  }

  buildToiletries() {
    return FutureBuilder(
        future: MarketMethods().getPartnerShopCategoryItems(
            shopName: widget.shop.shopName, category: 'Groceries'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data.length > 0
              ? GridView.builder(
                  padding: EdgeInsets.only(top: 24.0),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 21.0,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Center(child: ShopItemWidget(snapshot.data[index]));
                  },
                )
              : buildNoItem(context, text: 'Shop has no toiletry item.');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          cartWidget(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.shop.shopName,
              style: screenTitle,
            ),
            Text(
              '${widget.shop.numberOfProducts} products',
              style: TextStyle(
                fontFamily: 'roboto',
                fontSize: 15.0,
                color: Color(0xFFC4C4C4),
              ),
            ),
            SizedBox(height: 40.0),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              unselectedLabelStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lato',
              ),
              unselectedLabelColor: Colors.black,
              labelColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lato',
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 24.0),
              isScrollable: true,
              tabs: [
                Text('All'),
                Text('Groceries'),
                Text('Drinks'),
                Text('Toiletries'),
              ],
            ),
            Divider(
              color: Colors.black.withOpacity(0.12),
              thickness: 1.0,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildAllItems(),
                  buildGroceries(),
                  buildDrinks(),
                  buildToiletries(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopItemWidget extends StatelessWidget {
  final ProductModel item;
  ShopItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedProductPage(
            productModel: item,
          ),
        ),
      ),
      child: Container(
        width: 147.0,
        color: Color(0xaffF4F5F6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 153.0,
              width: 147.0,
              child: cachedNetworkImage(
                item.imageUrls[0],
                // 'https://www.jessicagavin.com/wp-content/uploads/2019/05/types-of-peppers-1.jpg',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50.0,
                    child: Text(
                      item.productName,
                      style: TextStyle(
                        color: Color(0xFF3A3A3A),
                        fontSize: 14.0,
                        fontFamily: 'Lato',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'N${item.productPrice}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
