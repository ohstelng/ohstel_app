import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_hire/model/hire_agent_model.dart';
import 'package:Ohstel_app/hostel_hire/pages/selected_hire_worker_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class SelectedHireCategoryPage extends StatefulWidget {
  final String searchKey;

  SelectedHireCategoryPage({@required this.searchKey});

  @override
  _SelectedHireCategoryPageState createState() =>
      _SelectedHireCategoryPageState();
}

class _SelectedHireCategoryPageState extends State<SelectedHireCategoryPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: body(),
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
        child: Text('No ${widget.searchKey} Found!'),
      ),
      shrinkWrap: true,
      query: FirebaseFirestore.instance
          .collection('hire')
          .doc('workers')
          .collection('allWorkers')
          .where('workType', isEqualTo: widget.searchKey.toLowerCase())
          .orderBy('dateJoined', descending: true),
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
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          '${currentWorkerModel.userName}',
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          '${currentWorkerModel.workerEmail}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

  Widget customSearchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 2.0, 5.0),
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  query = val.trim();
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by Product Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
        ),
        Container(
          child: InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              startSearch();
            },
            child: Center(child: Icon(Icons.search)),
          ),
        ),
      ],
    );
  }
}
