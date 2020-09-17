import 'package:Ohstel_app/hostel_hire/model/laundry_booking_model.dart';
import 'package:Ohstel_app/hostel_hire/pages/laundry_option_pop_up.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectLaundryPage extends StatefulWidget {
  final List laundryList;

  SelectLaundryPage({@required this.laundryList});

  @override
  _SelectLaundryPageState createState() => _SelectLaundryPageState();
}

class _SelectLaundryPageState extends State<SelectLaundryPage> {
  void selectOption({@required LaundryBookingModel laundry}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: LaundryOptionPopUp(
              laundryDetails: laundry,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          header(),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.laundryList.length,
      itemBuilder: (context, index) {
        LaundryBookingModel currentLaundry =
            LaundryBookingModel.fromMap(widget.laundryList[index]);

        return Container(
//          margin: EdgeInsets.all(5.0),
          child: Card(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Center(
                    child: Container(
                      height: 70,
                      width: 60,
                      margin: EdgeInsets.only(right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: currentLaundry.imageUrl != null
                          ? ExtendedImage.network(
                              currentLaundry.imageUrl,
                              fit: BoxFit.fill,
                              handleLoadingProgress: true,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              cache: false,
                              enableMemoryCache: true,
                            )
                          : Center(
                              child: Icon(Icons.person),
                            ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${currentLaundry.clothTypes}'),
                      SizedBox(height: 20),
                      Text(
                          '${currentLaundry.laundryModeAndPrice['Wash Only']}'),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
//                      setPrice();
                      selectOption(
                        laundry: currentLaundry,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add_shopping_cart),
//                      child: Text('Add To Basket'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.shopping_basket),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
