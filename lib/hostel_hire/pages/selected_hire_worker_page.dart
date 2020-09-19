import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_hire/model/hire_agent_model.dart';
import 'package:Ohstel_app/hostel_hire/pages/laundry_basket_page.dart';
import 'package:Ohstel_app/hostel_hire/pages/select_laundry_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:url_launcher/url_launcher.dart';

class SelectedHireWorkerPage extends StatefulWidget {
  final HireWorkerModel hireWorker;

  SelectedHireWorkerPage({@required this.hireWorker});

  @override
  _SelectedHireWorkerPageState createState() => _SelectedHireWorkerPageState();
}

class _SelectedHireWorkerPageState extends State<SelectedHireWorkerPage> {
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

  void book() {
    if (widget.hireWorker.workType.toLowerCase() == 'laundry') {
      print(widget.hireWorker.laundryList.length);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelectLaundryPage(
            laundryList: widget.hireWorker.laundryList,
            laundryWork: widget.hireWorker,
          ),
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
  void initState() {
    getBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              actions: [
                basketWidget(),
              ],
            ),
            body: body(),
          );
  }

  Widget body() {
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: widget.hireWorker.profileImageUrl != null
                    ? ExtendedImage.network(
                        widget.hireWorker.profileImageUrl,
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
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    '${widget.hireWorker.userName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    '${widget.hireWorker.workerPhoneNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    '${widget.hireWorker.workerEmail}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    '${widget.hireWorker.workType}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            FlatButton(
              onPressed: () {
                book();
//                  makeCall();
              },
              color: Colors.green,
              child: Text('Place A Booking'),
            )
          ],
        ),
      ),
    );
  }

  Widget basketWidget() {
    if (widget.hireWorker.workType.toLowerCase() == 'laundry') {
      return Container(
        margin: EdgeInsets.only(right: 5.0),
        child: ValueListenableBuilder(
          valueListenable: laundryBox.listenable(),
          builder: (context, Box box, widget) {
            if (box.values.isEmpty) {
              return Container(
                margin: EdgeInsets.only(right: 5.0),
                child: IconButton(
                  color: Colors.grey,
                  icon: Icon(
                    Icons.shopping_basket,
                    color: Theme.of(context).primaryColor,
                    size: 43,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LaundryBasketPage(),
                      ),
                    );
                  },
                ),
              );
            } else {
              int count = box.length;

              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        Icons.shopping_basket,
                        color: Theme.of(context).primaryColor,
                        size: 43,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LaundryBasketPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
