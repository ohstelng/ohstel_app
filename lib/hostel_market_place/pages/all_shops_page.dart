import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_shop_page.dart';
import 'package:Ohstel_app/utilities/shared_widgets.dart';
import 'package:flutter/material.dart';

class AllPartnerShopsPage extends StatefulWidget {
  @override
  _AllPartnerShopsPageState createState() => _AllPartnerShopsPageState();
}

class _AllPartnerShopsPageState extends State<AllPartnerShopsPage> {
  String searchQuery = "";
  bool isSearching = false;

  Widget customSearchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              textInputAction: TextInputAction.done,
              onChanged: (val) {
                searchQuery = val;
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by Shop Name',
                  border: OutlineInputBorder()),
            ),
          ),
        ),
        Container(
          child: InkWell(
            onTap: () {
              // FocusScope.of(context).unfocus();
              if (searchQuery.isNotEmpty) {
                setState(() {
                  isSearching = true;
                });
                print(searchQuery);
              }
            },
            child: Center(
                child: Icon(
              Icons.search,
              size: 35,
            )),
          ),
        ),
        SizedBox(
          width: 8,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            customSearchBar(),
            FutureBuilder(
              future: isSearching
                  ? MarketMethods().searchPartnerShop(searchQuery)
                  : MarketMethods().getPartnerShops(),
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
                            child: cachedNetworkImage(
                                snapshot.data[index].imageUrl),
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
                        subtitle: Text(
                            '${snapshot.data[index].numberOfProducts} products'),
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
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Color(0xFFE9E9F1),
                      thickness: 1.0,
                    ),
                    itemCount: snapshot.data.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
