import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/model/save_hostel_model.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class SavedHostelPage extends StatefulWidget {
  @override
  _SavedHostelPageState createState() => _SavedHostelPageState();
}

class _SavedHostelPageState extends State<SavedHostelPage> {
  Map userDetails;
  bool isLoading = true;

  Future<void> getUniName() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    Map data = await HiveMethods().getUserData();
    print(data);
    userDetails = data;
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getUniName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : saveHostelPage(),
    );
  }

  Widget saveHostelPage() {
    return PaginateFirestore(
      itemsPerPage: 4,
      initialLoader: Container(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomLoader: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      emptyDisplay: Center(
        child: Text('No Hostel Has Been Saved!!'),
      ),
      query: FirebaseFirestore.instance
          .collection('savedHostel')
          .doc(userDetails['uid'])
          .collection('all')
          .orderBy('timestamp', descending: true),
      itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
        SavedHostelModel savedHostelModel =
            SavedHostelModel.fromMap(documentSnapshot.data());

        return Card(
          elevation: 2.5,
          child: InkWell(
            onTap: () {
              print(savedHostelModel.hostelID);
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (context) =>
//                      GetHostelByIDPage(id: savedHostelModel.hostelID),
//                ),
//              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: displayMultiPic(
                          imageList: savedHostelModel.hostelImageUrls)),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${savedHostelModel.hostelName}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Location',
                          style: TextStyle(
                            color: Color(0xff868686),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "₦ Price",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 15, color: Color(0xff868686)),
                            Expanded(
                              child: Text(
                                '${savedHostelModel.hostelLocation}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Spacer(),
                            Expanded(
                                child: Text(
                              "date",
                              style: TextStyle(color: Color(0xff868686)),
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemBuilderType: PaginateBuilderType.listView,
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 120,
        maxWidth: MediaQuery.of(context).size.width * .46,
      ),
      child: Carousel(
        images: imageList.map(
          (images) {
            return Container(
              child: ExtendedImage.network(
                images,
                fit: BoxFit.fill,
                handleLoadingProgress: true,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                cache: false,
                enableMemoryCache: true,
              ),
            );
          },
        ).toList(),
        autoplay: true,
        indicatorBgPadding: 0.0,
        dotPosition: DotPosition.bottomCenter,
        dotSpacing: 15.0,
        dotSize: 0,
        dotIncreaseSize: 2.5,
        dotIncreasedColor: Colors.deepOrange,
        dotBgColor: Colors.transparent,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }
}
