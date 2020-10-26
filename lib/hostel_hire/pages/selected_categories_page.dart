import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../utilities/app_style.dart';
import '../../utilities/shared_widgets.dart';
import '../model/hire_agent_model.dart';
import 'hire_search_page.dart';
import 'laundry_basket_page.dart';
import 'selected_hire_worker_page.dart';

class SelectedHireCategoryPage extends StatelessWidget {
  final String searchKey;
  SelectedHireCategoryPage({@required this.searchKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFFFDFDFD),
        elevation: 0,
        iconTheme: IconThemeData(
          color: midnightExpress,
          size: 20,
        ),
        actionsIconTheme: IconThemeData(
          color: midnightExpress,
          size: 20,
        ),
        title: Text(
          "$searchKey",
          style: pageTitle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_basket),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LaundryBasketPage()),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 1,
        child: Column(
          children: [
            //Search Bar
            OhstelSearchBar(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HireSearchPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16),

            //Tab bar Heading
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TabBar(
                indicatorColor: childeanFire,
                indicatorWeight: 4.0,
                labelStyle:
                    body1.copyWith(fontWeight: FontWeight.w500, fontSize: 17),
                labelColor: textBlack,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  Tab(
                      child: Text(
                    "Explore",
                  )),
//                  Tab(
//                      child: Text(
//                    "Saved",
//                  )),
                ],
              ),
            ),
            Divider(height: 0),

            //Tab Body
            Expanded(
              child: TabBarView(
                children: [
                  //Explore Tab
                  PaginateFirestore(
                    scrollDirection: Axis.vertical,
                    itemsPerPage: 3,
                    physics: BouncingScrollPhysics(),
                    initialLoader: Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    bottomLoader: Center(
                      child: CircularProgressIndicator(),
                    ),
                    emptyDisplay: Center(
                      child: Text('No $searchKey Found!'),
                    ),
                    shrinkWrap: true,
                    query: FirebaseFirestore.instance
                        .collection('hire')
                        .doc('workers')
                        .collection('allWorkers')
                        .where('workType', isEqualTo: searchKey.toLowerCase())
                        .orderBy('dateJoined', descending: true),
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder:
                        (_, context, DocumentSnapshot documentSnapshot) {
                      Map data = documentSnapshot.data();
                      HireWorkerModel currentWorkerModel =
                          HireWorkerModel.fromMap(data);
                      return HireWorkerListTile(worker: currentWorkerModel);
                    },
                  ),

                  //Saved Tab
//                  Placeholder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HireWorkerListTile extends StatelessWidget {
  const HireWorkerListTile({
    Key key,
    @required this.worker,
  }) : super(key: key);

  final HireWorkerModel worker;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SelectedHireWorkerPage(
              hireWorker: worker,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Color(0xFFE9E9F1),
            width: 1,
          ),
        )),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          children: [
            worker.profileImageUrl != null
                ? ExtendedImage.network(
                    '${worker.profileImageUrl}',
                    borderRadius: BorderRadius.circular(8),
                    fit: BoxFit.fill,
                    handleLoadingProgress: true,
                    shape: BoxShape.rectangle,
                    cache: false,
                    enableMemoryCache: true,
                    height: 100,
                    width: 100,
                  )
                : Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: midnightExpress,
                        size: 20,
                      ),
                    ),
                  ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${worker.workerName}',
                          style: heading2.copyWith(
                            color: Color(0xFF3A3A3A),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
//                      IconButton(
//                        constraints: BoxConstraints.tightFor(
//                          height: 20,
//                        ),
//                        padding: EdgeInsets.zero,
//                        iconSize: 18,
//                        icon: Icon(
//                          Random().nextBool() //TODO: BE Change to whether saved or not boolean
//                              ? Icons.bookmark_border
//                              : Icons.bookmark,
//                          color: midnightExpress,
//                        ),
//                        onPressed: () {},
//                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${worker.workerPhoneNumber}',
                    style: body1.copyWith(fontSize: 14),
                    softWrap: true,
                  ),
//                  Padding(
//                    padding: const EdgeInsets.symmetric(vertical: 8.0),
//                    child: SmoothStarRating(
//                      isReadOnly: true,
//                      starCount: 5,
//                      rating:
//                          3.5, //TODO: BE add RATING to worker model and use here
//                      color: midnightExpress,
//                      borderColor: midnightExpress,
//                      size: 14,
//                    ),
//                  ),
                  Text(
                    '${worker.openTime}', //TODO: BE add OPEN PERIOD to worker model and use here
                    style: body1.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: midnightExpress,
                      ),
                      Expanded(
                        child: Text(
                          '${worker.uniName}',
                          style: body1.copyWith(fontSize: 14),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: childeanFire,
                        ),
                      ),
                      Text(
                        'OPENED',
                        style: body1.copyWith(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class SelectedHireCategoryPage extends StatefulWidget {
//   final String searchKey;

//   SelectedHireCategoryPage({@required this.searchKey});

//   @override
//   _SelectedHireCategoryPageState createState() =>
//       _SelectedHireCategoryPageState();
// }

// class _SelectedHireCategoryPageState extends State<SelectedHireCategoryPage> {
//   TextEditingController searchController = TextEditingController();
//   String query = '';
//   bool searchStarted = false;
//   bool showBlankScreen = false;
//   String uniName;

//   Future<void> getUserDetails() async {
//     uniName = await HiveMethods().getUniName();
//   }

//   Future<void> startSearch() async {
//     if (query.trim() != '') {
//       searchStarted = true;
//       setState(() {
//         showBlankScreen = true;
//       });
//       await Future.delayed(Duration(milliseconds: 100));
//       setState(() {
//         showBlankScreen = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: body(),
//         ),
//       ),
//     );
//   }

//   Widget body() {
//     return PaginateFirestore(
//       scrollDirection: Axis.vertical,
//       itemsPerPage: 3,
//       physics: BouncingScrollPhysics(),
//       initialLoader: Container(
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//       bottomLoader: Center(
//         child: CircularProgressIndicator(),
//       ),
//       emptyDisplay: Center(
//         child: Text('No ${widget.searchKey} Found!'),
//       ),
//       shrinkWrap: true,
//       query: FirebaseFirestore.instance
//           .collection('hire')
//           .doc('workers')
//           .collection('allWorkers')
//           .where('workType', isEqualTo: widget.searchKey.toLowerCase())
//           .orderBy('dateJoined', descending: true),
//       itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
//         Map data = documentSnapshot.data();
//         HireWorkerModel currentWorkerModel = HireWorkerModel.fromMap(data);

//         return Container(
//           margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
//           child: Card(
//             elevation: 2.5,
//             child: InkWell(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => SelectedHireWorkerPage(
//                       hireWorker: currentWorkerModel,
//                     ),
//                   ),
//                 );
//               },
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     height: 150,
//                     width: 200,
//                     margin:
//                         EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     ),
//                     child: currentWorkerModel.profileImageUrl != null
//                         ? ExtendedImage.network(
//                             currentWorkerModel.profileImageUrl,
//                             fit: BoxFit.fill,
//                             handleLoadingProgress: true,
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.circular(10),
//                             cache: false,
//                             enableMemoryCache: true,
//                           )
//                         : Center(
//                             child: Icon(Icons.person),
//                           ),
//                   ),
//                   Column(
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.symmetric(horizontal: 2.0),
//                         child: Text(
//                           '${currentWorkerModel.userName}',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(horizontal: 2.0),
//                         child: Text(
//                           '${currentWorkerModel.workerPhoneNumber}',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(horizontal: 2.0),
//                         child: Text(
//                           '${currentWorkerModel.workerEmail}',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       itemBuilderType: PaginateBuilderType.listView,
//     );
//   }

//   Widget customSearchBar() {
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(5.0, 5.0, 2.0, 5.0),
//             child: TextField(
//               textInputAction: TextInputAction.done,
//               controller: searchController,
//               onChanged: (val) {
//                 setState(() {
//                   query = val.trim();
//                 });
//               },
//               decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(left: 25.0),
//                   hintText: 'Search by Product Name',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4.0))),
//             ),
//           ),
//         ),
//         Container(
//           child: InkWell(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//               startSearch();
//             },
//             child: Center(child: Icon(Icons.search)),
//           ),
//         ),
//       ],
//     );
//   }
// }
