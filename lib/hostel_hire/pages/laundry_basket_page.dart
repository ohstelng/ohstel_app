import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_hire/model/laundry_basket_model.dart';
import 'package:Ohstel_app/hostel_hire/pages/laundry_address_details_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LaundryBasketPage extends StatefulWidget {
  @override
  _LaundryBasketPageState createState() => _LaundryBasketPageState();
}

class _LaundryBasketPageState extends State<LaundryBasketPage> {
  Box<Map> laundryBox;
  bool loading = true;

  Future<void> getBox() async {
    if (!mounted) return;

    setState(() {
      loading = true;
    });
    laundryBox = await HiveMethods().getOpenBox('laundryBox');
    setState(() {
      loading = false;
    });
  }

  int getPrice() {
    int _price = 0;

    for (Map laundryData in laundryBox.values) {
      _price = _price + laundryData['price'];
    }

    return _price;
  }

  @override
  void initState() {
    getBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          "Laundry Basket",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: ValueListenableBuilder(
                valueListenable: laundryBox.listenable(),
                builder: (context, box, widget) {
                  if (box.values.isEmpty) {
                    return Center(
                      child: Text("Basket list is empty"),
                    );
                  }

                  return ListView(
                    children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          Map data = box.getAt(index);
                          LaundryBookingBasketModel currentLaundry =
                              LaundryBookingBasketModel.fromMap(data.cast());

                          return Card(
                            elevation: 2.5,
                            child: Row(
                              children: [
                                imageWidget(url: currentLaundry.imageUrl),
                                laundryInfo(laundry: currentLaundry),
                                Spacer(),
                                removeButton(),
                              ],
                            ),
                          );
                        },
                      ),
                      pricingInfo(),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget pricingInfo() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Number Of Items:",
                  style: TextStyle(fontSize: 20),
                ),
                Text("${laundryBox.length}", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount:",
                  style: TextStyle(fontSize: 20),
                ),
                Text("${getPrice()}", style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            width: double.infinity,
            child: FlatButton(
              padding: EdgeInsets.all(15),
              color: Color(0xFF202530),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {
                getPrice();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LaundryAddressDetailsPage(),
                  ),
                );
              },
              child: Text(
                'Wash Now',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget removeButton() {
    return Row(
      children: [
        IconButton(
          color: Colors.redAccent,
          icon: Icon(Icons.delete),
          onPressed: () {},
        ),
        Text('Remove'),
      ],
    );
  }

  Widget laundryInfo({@required LaundryBookingBasketModel laundry}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${laundry.clothTypes}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${laundry.laundryMode}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            '${laundry.price}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget({@required String url}) {
    return Container(
      height: 120,
      width: 100,
      color: Colors.grey,
      child: url != null
          ? Image.network(
              url,
              fit: BoxFit.fill,
//        loadingBuilder: (context, child, _){
//                return Center(child: CircularProgressIndicator());
//        },
            )
          : Container(),
    );
  }
}
