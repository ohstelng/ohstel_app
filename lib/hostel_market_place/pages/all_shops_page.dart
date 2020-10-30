import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/shop_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/search_shop_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_shop_page.dart';
import 'package:Ohstel_app/utilities/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AllPartnerShopsPage extends StatefulWidget {
  @override
  _AllPartnerShopsPageState createState() => _AllPartnerShopsPageState();
}

class _AllPartnerShopsPageState extends State<AllPartnerShopsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            searchBar(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Partnered Shops',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Divider(),
            partnerShopList(),
          ],
        ),
      ),
    );
  }

  Widget partnerShopList() {
    return Expanded(
      child: PaginateFirestore(
        itemsPerPage: 8,
        initialLoader: Center(child: CircularProgressIndicator()),
        bottomLoader: Container(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        itemBuilder: (int index, context, DocumentSnapshot snapshot) {
          ShopModel shop = ShopModel.fromMap(snapshot.data());
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: shop.imageUrl != null
                  ? Container(
                      height: 50.0,
                      width: 50.0,
                      child: cachedNetworkImage(shop.imageUrl))
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
              shop.shopName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3A3A3A),
                fontFamily: 'Lato',
              ),
            ),
            subtitle: Text('${shop.numberOfProducts} products'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectedShopPage(shop),
              ),
            ),
          );
        },
        query: MarketMethods()
            .shopCollection
            .where('isPartner', isEqualTo: true)
            .orderBy('shopName'),
        itemBuilderType: PaginateBuilderType.listView,
      ),
    );
  }

  Widget searchBar() {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 48,
      decoration: BoxDecoration(),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SearchShopsPage(),
            ),
          );
        },
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.search, color: Colors.black, size: 19),
            SizedBox(width: 24),
            Text(
              'Search For Shop By Shop Name',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
