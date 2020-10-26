import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/pages/search_shop_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_shop_page.dart';
import 'package:Ohstel_app/utilities/shared_widgets.dart';
import 'package:flutter/material.dart';

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
                'Top Shops',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Divider(),
            topShopList(),
          ],
        ),
      ),
    );
  }

  Widget topShopList() {
    return FutureBuilder(
      future: MarketMethods().getPartnerShops(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    child: cachedNetworkImage(snapshot.data[index].imageUrl),
                  ),
                ),
                title: Text(
                  snapshot.data[index].shopName,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3A3A3A),
                    fontFamily: 'Lato',
                  ),
                ),
                subtitle:
                    Text('${snapshot.data[index].numberOfProducts} products'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectedShopPage(
                      snapshot.data[index],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Color(0xFFE9E9F1),
              thickness: 1.0,
            ),
            itemCount: snapshot.data.length,
          ),
        );
      },
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
