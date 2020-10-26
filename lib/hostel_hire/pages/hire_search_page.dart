import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../hive_methods/hive_class.dart';
import '../model/hire_agent_model.dart';
import 'selected_hire_worker_page.dart';

class HireSearchPage extends StatefulWidget {
  @override
  _HireSearchPageState createState() => _HireSearchPageState();
}

class _HireSearchPageState extends State<HireSearchPage> {
  TextEditingController searchController = TextEditingController();
  String query = '';
  bool searchStarted = false;
  bool showBlankScreen = false;
  String uniName;

  Future<void> getUserDetails() async {
    uniName = await HiveMethods().getUniName();
  }

  Future<void> startSearch() async {
    if (query.trim() != '') {
      searchStarted = true;
      setState(() {
        showBlankScreen = true;
      });
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        showBlankScreen = false;
      });
    }
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            customSearchBar(),
            searchStarted
                ? Expanded(
                    child: showBlankScreen == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: body(),
                          ),
                  )
                : greetingWidget(),
          ],
        ),
      ),
    );
  }

  Widget customSearchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            child: TextField(
              textInputAction: TextInputAction.search,
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  query = val.trim();
                });
              },
              onSubmitted: (_) {
                startSearch();
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget notFound() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error,
                  color: Colors.grey,
                  size: 85.0,
                ),
                Text(
                  'Sorry No Workr Was Founded :(',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget greetingWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.settings,
              color: Colors.grey,
              size: 85.0,
            ),
            Text(
              'Search For Worker By Name',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget body() {
    return PaginateFirestore(
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
        child: Text('Worker $query Not Found!'),
      ),
      shrinkWrap: true,
      query: FirebaseFirestore.instance
          .collection('hire')
          .doc('workers')
          .collection('allWorkers')
          .orderBy('dateJoined', descending: true)
          .where('searchKeys', arrayContains: query),
      itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
        Map data = documentSnapshot.data();
        HireWorkerModel currentWorkerModel = HireWorkerModel.fromMap(data);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: Card(
            elevation: 2.5,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectedHireWorkerPage(
                      hireWorker: currentWorkerModel,
                    ),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 200,
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: currentWorkerModel.profileImageUrl != null
                        ? ExtendedImage.network(
                            currentWorkerModel.profileImageUrl,
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
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 5.0, top: 10.0),
                      height: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              '${currentWorkerModel.userName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              '${currentWorkerModel.workerPhoneNumber}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              '${currentWorkerModel.workType}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(
                              '${currentWorkerModel.workerEmail}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemBuilderType: PaginateBuilderType.listView,
    );
  }
}
