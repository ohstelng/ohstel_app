import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../utilities/app_style.dart';
import '../model/hire_agent_model.dart';
import 'select_laundry_page.dart';
//import 'package:url_launcher/url_launcher.dart';

class SelectedHireWorkerPage extends StatelessWidget {
  final HireWorkerModel hireWorker;

  SelectedHireWorkerPage({@required this.hireWorker});

  void book(BuildContext context) {
    if (hireWorker.workType.toLowerCase() == 'laundry') {
      print(hireWorker.laundryList.length);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SelectLaundryPage(laundryList: hireWorker.laundryList),
        ),
      );
    } else {
      //TODO: implement call sells rep
    }
  }

//  void makeCall() async {
//    String _phoneNumber = "tel:${widget.hireWorker.workerPhoneNumber}";
//
//    if (await canLaunch(_phoneNumber)) {
//      await launch(_phoneNumber);
//    } else {
//      throw 'Could not call';
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Random().nextBool() //TODO: BE Change Random bool to if worker is saved
                  ? Icons.bookmark_border
                  : Icons.bookmark,
            ),
            onPressed: () {},
          )
        ],
        actionsIconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          hireWorker.profileImageUrl != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: ExtendedImage.network(
                    hireWorker.profileImageUrl,
                    fit: BoxFit.fill,
                    handleLoadingProgress: true,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    cache: false,
                    enableMemoryCache: true,
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: midnightExpress,
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: childeanFire,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: kToolbarHeight, horizontal: 24),
                ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -30),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      //Worker Data
                      Container(
                          margin: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${hireWorker.workerName}',
                                      style: heading2.copyWith(
                                        color: Color(0xFF3A3A3A),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${hireWorker.priceRange ?? 'NA'}',
                                    style: heading2.copyWith(
                                      color: textAnteBlack,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${hireWorker.uniName},',
                                        style: body1,
                                      ),
                                    ),
                                    Text(
                                      '${hireWorker.workerPhoneNumber}',
                                      style: body1,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: textAnteBlack,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${hireWorker.uniName}',
                                      style: body2,
                                    ),
                                  ),
                                  Text(
                                    'NA', //TODO: BE change to OPEN PERIOD of hireworker
                                    style: body2,
                                  ),
                                ],
                              ),
                            ],
                          )),

                      //Tab heading
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TabBar(
                          indicatorColor: childeanFire,
                          indicatorWeight: 4.0,
                          labelStyle: body1.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 17),
                          labelColor: textBlack,
                          labelPadding: EdgeInsets.zero,
                          tabs: [
                            Tab(
                                child: Text(
                              "Details",
                            )),
                            Tab(
                                child: Text(
                              "Reviews",
                            )),
                          ],
                        ),
                      ),
                      Divider(height: 0),

                      //Tabs
                      Expanded(
                        child: TabBarView(children: [
                          //Details Tab
                          ListView(
                            primary: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            children: [
                              Text(
                                'About',
                                style: body1.copyWith(fontSize: 17),
                              ),
                              SizedBox(height: 4),
                              Text(
                                //TODO: BE change to worker short description
                                'dfjkajdflajd ajdkflkjdlfjasld dkjfladk falkfjdsf ladkjfldsjf lakdjflsadjf lkadjf ldjflkjdskfla jdslkf jsadlkfj alkdsjflkdsj flkjdsfljdslfjls',
                                style: body2.copyWith(
                                  color: Color(0xFF868686),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 24.0, bottom: 16),
                                child: Text(
                                  'Services',
                                  style: body1.copyWith(fontSize: 17),
                                ),
                              ),
                              Wrap(
                                children: List.generate(
                                  hireWorker?.laundryList?.length ?? 0,
                                  (index) => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: 40,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //Reviews Tab
                          ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            itemBuilder: (context, index) {
                              return Container(
                                height: 40,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: textAnteBlack,
                                      radius: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Khalid Karem',
                                                ),
                                              ),
                                              Text('12/07/2020')
                                            ],
                                          ),
                                          SmoothStarRating(
                                            isReadOnly: true,
                                            starCount: 5,
                                            rating: 3.5,
                                            borderColor: midnightExpress,
                                            color: midnightExpress,
                                            size: 14,
                                          ),
                                          Text(
                                              'Lorem ipsum dolor sit amet. consecteture adipicing elit.'),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Container(
          color: childeanFire,
          height: 48,
          width: double.infinity,
        ),
      ),
    );
  }

//   Widget body() {
//     return Container(
//       child: SafeArea(
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Center(
//                 child: Container(
//                   height: 250,
//                   width: MediaQuery.of(context).size.width * 0.85,
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   ),
//                   child: widget.hireWorker.profileImageUrl != null
//                       ? ExtendedImage.network(
//                           widget.hireWorker.profileImageUrl,
//                           fit: BoxFit.fill,
//                           handleLoadingProgress: true,
//                           shape: BoxShape.rectangle,
//                           borderRadius: BorderRadius.circular(10),
//                           cache: false,
//                           enableMemoryCache: true,
//                         )
//                       : Center(
//                           child: Icon(Icons.person),
//                         ),
//                 ),
//               ),
//               Column(
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 2.0),
//                     child: Text(
//                       '${widget.hireWorker.userName}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 2.0),
//                     child: Text(
//                       '${widget.hireWorker.workerPhoneNumber}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 2.0),
//                     child: Text(
//                       '${widget.hireWorker.workerEmail}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 2.0),
//                     child: Text(
//                       '${widget.hireWorker.workType}',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               FlatButton(
//                 onPressed: () {
//                   book();
// //                  makeCall();
//                 },
//                 color: Colors.green,
//                 child: Text('Place A Booking'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
}
