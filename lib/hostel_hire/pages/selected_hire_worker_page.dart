import 'package:Ohstel_app/hostel_hire/model/hire_agent_model.dart';
import 'package:Ohstel_app/hostel_hire/pages/select_laundry_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class SelectedHireWorkerPage extends StatefulWidget {
  final HireWorkerModel hireWorker;

  SelectedHireWorkerPage({@required this.hireWorker});

  @override
  _SelectedHireWorkerPageState createState() => _SelectedHireWorkerPageState();
}

class _SelectedHireWorkerPageState extends State<SelectedHireWorkerPage> {
  void book() {
    if (widget.hireWorker.workType.toLowerCase() == 'laundry') {
      print(widget.hireWorker.laundryList.length);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SelectLaundryPage(laundryList: widget.hireWorker.laundryList),
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
      body: body(),
    );
  }

  Widget body() {
    return Container(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
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
      ),
    );
  }
}
