import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../hive_methods/hive_class.dart';
import '../../utilities/app_style.dart';
import '../../utilities/shared_widgets.dart';
import '../model/laundry_basket_model.dart';
import 'laundry_address_details_page.dart';
import 'package:http/http.dart' as http;

class LaundryBasketPage extends StatefulWidget {
  @override
  _LaundryBasketPageState createState() => _LaundryBasketPageState();
}

class _LaundryBasketPageState extends State<LaundryBasketPage> {
  Box<Map> laundryBox;
  bool loading = true;
  int deliveryFee = 0;

  Future<void> getBox() async {
    laundryBox = await HiveMethods().getOpenBox('laundryBox');
    try {
      // getDeliveryFeeFromApi();
    } catch (e) {}
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future<void> getDeliveryFeeFromApi() async {
    String uniName = await HiveMethods().getUniName();
    Box<Map> laundry = await HiveMethods().getOpenBox('laundryBox');
    String url = 'https://quiz-demo-de79d.appspot.com/hire_api/$uniName';
    var response = await http.get(url);
    Map data = json.decode(response.body);
    deliveryFee = (data['$uniName'] * laundry.length);
  }

  int computeBasketPriceTotal() {
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
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: midnightExpress,
          size: 24,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Basket',
                style: heading2,
              ),
            ),
            preferredSize: Size.fromHeight(32)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ValueListenableBuilder(
                valueListenable: laundryBox.listenable(),
                builder: (context, box, widget) {
                  if (box.values.isEmpty) {
                    return Center(
                      child: Text(
                        "Basket is empty",
                        style: heading1,
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),

                      //Build basket items in a list
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: box.values.length,
                          itemBuilder: (context, index) {
                            Map data = box.getAt(index);
                            LaundryBookingBasketModel currentLaundry =
                                LaundryBookingBasketModel.fromMap(data.cast());

                            return LaundryBasketListTile(
                              currentLaundry: currentLaundry,
                              processBasket: (basketModel, newUnits) {
                                //TODO: BE Adjust basket where item is basketModel  with newUnits
                              },
                            );
                          },
                        ),
                      ),

//Show basket summary
                      SizedBox(height: 16),
                      // Number of items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Number of items',
                            style: tableLabelTextStyle,
                          ),
                          Text(
                            '${box.length}',
                            style: tableDataTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Sub Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sub Total',
                            style: tableLabelTextStyle,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'N',
                              style: nairaSignStyle,
                              children: [
                                TextSpan(
                                  text: '${computeBasketPriceTotal()}',
                                  style: tableDataTextStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),

                      // Delivery Fee
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Fee',
                            style: tableLabelTextStyle,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'N',
                              style: nairaSignStyle,
                              children: [
                                TextSpan(
                                  text: '$deliveryFee',
                                  style: tableDataTextStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      // Total
                      Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: tableLabelTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'N',
                              style: nairaSignStyle,
                              children: [
                                TextSpan(
                                  text:
                                      '${computeBasketPriceTotal() + deliveryFee}',
                                  style: tableDataTextStyle.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(height: 24),
                    ],
                  );
                },
              ),
      ),
      bottomNavigationBar: loading
          ? Container()
          : ValueListenableBuilder(
              valueListenable: laundryBox.listenable(),
              builder: (context, box, _) {
                return box.values.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CustomLongButton(
                          label: 'Wash Now',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    LaundryAddressDetailsPage(),
                              ),
                            );
                          },
                        ),
                      );
              }),
    );
  }
}

class LaundryBasketListTile extends StatefulWidget {
  final LaundryBookingBasketModel currentLaundry;
  final Function(LaundryBookingBasketModel, int units) processBasket;

  const LaundryBasketListTile(
      {Key key, @required this.currentLaundry, @required this.processBasket})
      : super(key: key);
  @override
  _LaundryBasketListTileState createState() => _LaundryBasketListTileState();
}

class _LaundryBasketListTileState extends State<LaundryBasketListTile> {
  String _selectedService;
  int _orderQuantity = 0;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.currentLaundry.laundryMode;
    _orderQuantity = widget.currentLaundry.units;
  }

  void processSelection() {
    widget.processBasket(widget.currentLaundry, _orderQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          /*  Center(
            child: Container(
              height: 70,
              width: 60,
              margin: EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.grey),
                borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
              ),
              child: */
          widget.currentLaundry.imageUrl != null
              ? ExtendedImage.network(
                  widget.currentLaundry.imageUrl,
                  fit: BoxFit.fill,
                  handleLoadingProgress: true,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  cache: false,
                  enableMemoryCache: true,
                  height: 64,
                  width: 64,
                )
              : Container(
                  color: cardBackground,
                  height: 56,
                  width: 56,
                  child: Center(
                    child: Icon(
                      Icons.blur_on,
                      color: midnightExpress,
                    ),
                  ),
                ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.currentLaundry.clothTypes}',
                  style: heading2.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 24,
                  child: DropdownButton(
                      isDense: false,
                      value: _selectedService,
                      style: body1.copyWith(fontWeight: FontWeight.w300),
                      underline: Container(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 24,
                        color: Color(0xFFBABAC1),
                      ),
                      elevation: 0,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            _selectedService,
                            style: body1,
                          ),
                          value: _selectedService,
                        )
                      ],
                      //  widget.currentLaundry.laundryModeAndPrice.keys
                      //     .map(
                      //       (key) => DropdownMenuItem(
                      //         child: Text(
                      //           '${key.toString()}',
                      //           style: body1,
                      //         ),
                      //         value: key.toString(),
                      //       ),
                      //     )
                      //     .toList(),
                      onChanged: (changedValue) {
                        setState(() {
                          _selectedService = changedValue;
                        });
                        processSelection();
                      }),
                ),
                RichText(
                  text: TextSpan(text: 'N', style: body1, children: [
                    TextSpan(
                      text: '${widget.currentLaundry.price.toStringAsFixed(2)}',
                      style: body1.copyWith(
                        color: Color(0xFF7C7C7F),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 88),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(height: 32, width: 24),
                  onPressed: () {
                    if (_orderQuantity > 0) {
                      setState(() {
                        _orderQuantity--;
                      });
                    }
                    processSelection();
                  },
                  icon: Icon(
                    FontAwesomeIcons.minusSquare,
                    size: 18,
                    color: Color(0xFF62666E),
                  ),
                ),
                Flexible(
                  child: Text(
                    '$_orderQuantity',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xFFB9BBBE),
                      fontSize: 24,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(height: 32, width: 24),
                  onPressed: () {
                    setState(() {
                      _orderQuantity++;
                    });

                    processSelection();
                  },
                  icon: Icon(
                    FontAwesomeIcons.plusSquare,
                    size: 18,
                    color: childeanFire,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class LaundryBasketPage extends StatefulWidget {
//   @override
//   _LaundryBasketPageState createState() => _LaundryBasketPageState();
// }

// class _LaundryBasketPageState extends State<LaundryBasketPage> {
//   Box<Map> laundryBox;
//   bool loading = true;

//   Future<void> getBox() async {
//     if (!mounted) return;

//     setState(() {
//       loading = true;
//     });
//     laundryBox = await HiveMethods().getOpenBox('laundryBox');
//     setState(() {
//       loading = false;
//     });
//   }

//   int getPrice() {
//     int _price = 0;

//     for (Map laundryData in laundryBox.values) {
//       _price = _price + laundryData['price'];
//     }

//     return _price;
//   }

//   @override
//   void initState() {
//     getBox();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//             color: Colors.black,
//             icon: Icon(Icons.arrow_back),
//             onPressed: () => Navigator.of(context).pop()),
//         title: Text(
//           "Laundry Basket",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 17,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: loading
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//               child: ValueListenableBuilder(
//                 valueListenable: laundryBox.listenable(),
//                 builder: (context, box, widget) {
//                   if (box.values.isEmpty) {
//                     return Center(
//                       child: Text("Basket list is empty"),
//                     );
//                   }

//                   return ListView(
//                     children: <Widget>[
//                       ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: box.values.length,
//                         itemBuilder: (context, index) {
//                           Map data = box.getAt(index);
//                           LaundryBookingBasketModel currentLaundry =
//                               LaundryBookingBasketModel.fromMap(data.cast());

//                           return Card(
//                             elevation: 2.5,
//                             child: Row(
//                               children: [
//                                 imageWidget(url: currentLaundry.imageUrl),
//                                 laundryInfo(laundry: currentLaundry),
//                                 Spacer(),
//                                 removeButton(),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                       pricingInfo(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//     );
//   }

//   Widget pricingInfo() {
//     return Container(
//       child: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Number Of Items:",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 Text("${laundryBox.length}", style: TextStyle(fontSize: 20))
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total Amount:",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 Text("${getPrice()}", style: TextStyle(fontSize: 20))
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
//             width: double.infinity,
//             child: FlatButton(
//               padding: EdgeInsets.all(15),
//               color: Color(0xFF202530),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               onPressed: () {
//                 getPrice();
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => LaundryAddressDetailsPage(),
//                   ),
//                 );
//               },
//               child: Text(
//                 'Wash Now',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget removeButton() {
//     return Row(
//       children: [
//         IconButton(
//           color: Colors.redAccent,
//           icon: Icon(Icons.delete),
//           onPressed: () {},
//         ),
//         Text('Remove'),
//       ],
//     );
//   }

//   Widget laundryInfo({@required LaundryBookingBasketModel laundry}) {
//     return Container(
//       margin: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${laundry.clothTypes}',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             '${laundry.laundryMode}',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//           Text(
//             '${laundry.price}',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget imageWidget({@required String url}) {
//     return Container(
//       height: 120,
//       width: 100,
//       color: Colors.grey,
//       child: url != null
//           ? Image.network(
//               url,
//               fit: BoxFit.fill,
// //        loadingBuilder: (context, child, _){
// //                return Center(child: CircularProgressIndicator());
// //        },
//             )
//           : Container(),
//     );
//   }
// }
