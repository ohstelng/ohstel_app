import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../hive_methods/hive_class.dart';
import '../../utilities/app_style.dart';
import '../../utilities/shared_widgets.dart';
import '../model/hire_agent_model.dart';
import '../model/laundry_basket_model.dart';
import '../model/laundry_booking_model.dart';

class SelectLaundryPage extends StatelessWidget {
  final List laundryList;
  final HireWorkerModel laundryWork;

  SelectLaundryPage({
    @required this.laundryList,
    @required this.laundryWork,
  });

  final List<LaundryBookingBasketModel> userOrderList = [];
  void processOrderList(
    LaundryBookingModel laundry,
    String type,
    int units,
    double price,
  ) {
    //Remove the order of same type from the list if it exists before
    userOrderList.removeWhere(
      (order) => order.clothTypes == laundry.clothTypes,
    );

    //If the units to be processed is greater than 0
    if (units > 0) {
      //Create a new booking object
      LaundryBookingBasketModel laundryToAdd = LaundryBookingBasketModel(
        clothTypes: laundry.clothTypes,
        imageUrl: laundry.imageUrl,
        units: units,
        laundryMode: type,
        price: price.toInt(),
        laundryPersonName: laundryWork.workerName,
        laundryPersonEmail: laundryWork.workerEmail,
        laundryPersonUniName: laundryWork.uniName,
        laundryPersonPhoneNumber: laundryWork.workerPhoneNumber,
      );
      //Add the new booking object to the orderList
      userOrderList.add(laundryToAdd);
    }
    print(userOrderList.length);
    userOrderList.forEach((element) {
      print(element.toMap());
    });
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
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_basket),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        actionsIconTheme: IconThemeData(
          color: childeanFire,
          size: 24,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            //Tab Heading
            Container(
              height: 32,
              child: TabBar(
                indicatorColor: childeanFire,
                indicatorWeight: 4.0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                    body1.copyWith(fontWeight: FontWeight.w500, fontSize: 17),
                labelColor: textBlack,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  Tab(
                      child: Text(
                    "Gent",
                  )),
                  Tab(
                      child: Text(
                    "Lady",
                  )),
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 4,
            ),

            //Tabs
            Expanded(
              child: TabBarView(
                children: [
                  //Gent Tab
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    itemCount: laundryList.length,
                    itemBuilder: (context, index) {
                      LaundryBookingModel currentLaundry =
                          LaundryBookingModel.fromMap(laundryList[index]);

                      return LaundryItemListTile(
                        currentLaundry: currentLaundry,
                        processOrderList: processOrderList,
                      );
                    },
                  ),

                  //Lady Tab
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    itemCount: laundryList.length,
                    itemBuilder: (context, index) {
                      LaundryBookingModel currentLaundry =
                          LaundryBookingModel.fromMap(laundryList[index]);

                      return LaundryItemListTile(
                        currentLaundry: currentLaundry,
                        processOrderList: processOrderList,
                      );
                    },
                  ),
                ],
              ),
            ),

            //Action buttons
            CustomLongButton(
              label: 'Add to Basket',
              onTap: () {
                //Save all orders in order list to basket
                userOrderList.forEach((order) async {
                  await HiveMethods()
                      .saveLaundryToBasketCart(data: order.toMap());
                });
                Navigator.of(context).pop();
              },
              type: ButtonType.borderBlue,
            ),
            CustomLongButton(
              label: 'Wash Now',
              onTap: () {
                //Save all orders in order list to basket
                userOrderList.forEach((order) async {
                  await HiveMethods()
                      .saveLaundryToBasketCart(data: order.toMap());
                });
                //Navigate to checkout
                //TODO: UI
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LaundryItemListTile extends StatefulWidget {
  const LaundryItemListTile({
    Key key,
    @required this.currentLaundry,
    @required this.processOrderList,
  }) : super(key: key);

  final LaundryBookingModel currentLaundry;
  final Function(LaundryBookingModel, String, int, double) processOrderList;

  @override
  _LaundryItemListTileState createState() => _LaundryItemListTileState();
}

class _LaundryItemListTileState extends State<LaundryItemListTile>
    with AutomaticKeepAliveClientMixin {
  String _selectedService;
  int _orderQuantity = 0;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.currentLaundry.laundryModeAndPrice.keys.first;
  }

  void processSelection() {
    widget.processOrderList(
      widget.currentLaundry,
      _selectedService,
      _orderQuantity,
      (widget.currentLaundry.laundryModeAndPrice[_selectedService] *
              _orderQuantity)
          .toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                      // itemHeight: kMinInteractiveDimension,
                      underline: Container(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 24,
                        color: Color(0xFFBABAC1),
                      ),
                      elevation: 0,
                      items: widget.currentLaundry.laundryModeAndPrice.keys
                          .map(
                            (key) => DropdownMenuItem(
                              child: Text(
                                '${key.toString()}',
                                style: body1,
                              ),
                              value: key.toString(),
                            ),
                          )
                          .toList(),
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
                      text:
                          '${(widget.currentLaundry.laundryModeAndPrice[_selectedService] * _orderQuantity).toStringAsFixed(2)}',
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

  @override
  bool get wantKeepAlive => true;
}

// class SelectLaundryPage extends StatefulWidget {
//   final List laundryList;
//   final HireWorkerModel laundryWork;

//   SelectLaundryPage({
//     @required this.laundryList,
//     @required this.laundryWork,
//   });

//   @override
//   _SelectLaundryPageState createState() => _SelectLaundryPageState();
// }

// class _SelectLaundryPageState extends State<SelectLaundryPage> {
//   void selectOption({@required LaundryBookingModel laundry}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Container(
//             child: LaundryOptionPopUp(
//               laundryDetails: laundry,
//               hireWorkerDetails: widget.laundryWork,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           header(),
//           body(),
//         ],
//       ),
//     );
//   }

//   Widget body() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: widget.laundryList.length,
//       itemBuilder: (context, index) {
//         LaundryBookingModel currentLaundry =
//             LaundryBookingModel.fromMap(widget.laundryList[index]);

//         return Container(
// //          margin: EdgeInsets.all(5.0),
//           child: Card(
//             child: Container(
//               margin: EdgeInsets.all(5.0),
//               child: Row(
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 70,
//                       width: 60,
//                       margin: EdgeInsets.only(right: 20.0),
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                       child: currentLaundry.imageUrl != null
//                           ? ExtendedImage.network(
//                               currentLaundry.imageUrl,
//                               fit: BoxFit.fill,
//                               handleLoadingProgress: true,
//                               shape: BoxShape.rectangle,
//                               borderRadius: BorderRadius.circular(10),
//                               cache: false,
//                               enableMemoryCache: true,
//                             )
//                           : Center(
//                               child: Icon(Icons.person),
//                             ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('${currentLaundry.clothTypes}'),
//                       SizedBox(height: 20),
//                       Text(
//                           '${currentLaundry.laundryModeAndPrice['Wash Only']}'),
//                     ],
//                   ),
//                   Spacer(),
//                   InkWell(
//                     onTap: () {
// //                      setPrice();
//                       selectOption(
//                         laundry: currentLaundry,
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(Icons.add_shopping_cart),
// //                      child: Text('Add To Basket'),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5.0),
//                         color: Colors.green,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget header() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: Icon(Icons.shopping_basket),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ],
//     );
//   }
// }
