import 'package:Ohstel_app/hostel_hire/methods/hire_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HireWorkerModel {
  String workerName;
  String userName;
  String workType;
  String workerPhoneNumber;
  String workerEmail;
  String uniName;
  Timestamp dateJoined;
  String profileImageUrl;
  List searchKeys;

  HireWorkerModel({
    @required this.workerName,
    @required this.userName,
    @required this.workType,
    @required this.workerPhoneNumber,
    @required this.workerEmail,
    @required this.uniName,
    @required this.profileImageUrl,
  });

  HireWorkerModel.fromMap(Map<String, dynamic> mapData) {
    this.workerName = mapData['workerName'];
    this.userName = mapData['userName'];
    this.workType = mapData['workType'];
    this.workerPhoneNumber = mapData['workerPhoneNumber'];
    this.workerEmail = mapData['workerEmail'];
    this.uniName = mapData['uniName'];
    this.dateJoined = mapData['dateJoined'];
    this.profileImageUrl = mapData['profileImageUrl'];
    this.searchKeys = mapData['searchKeys'];
  }

  Map toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    List<String> _searchKeys = [];
    _searchKeys.add(this.userName.toLowerCase());
    workerName.trim().split(' ').forEach((element) {
      _searchKeys.add(element.toLowerCase());
    });

    data['workerName'] = this.workerName.toLowerCase();
    data['userName'] = this.userName.toLowerCase();
    data['workType'] = this.workType.toLowerCase();
    data['workerPhoneNumber'] = this.workerPhoneNumber;
    data['workerEmail'] = this.workerEmail;
    data['uniName'] = this.uniName.toLowerCase();
    data['dateJoined'] = Timestamp.now();
    data['profileImageUrl'] = this.profileImageUrl;
    data['searchKeys'] = _searchKeys;

    return data;
  }
}

List<HireWorkerModel> list = [
  HireWorkerModel(
    workerName: 'Kristin Stephens',
    userName: 'Stephens',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl: null,
    workType: 'Laundry',
  ),
  HireWorkerModel(
    workerName: 'Janet Garner',
    userName: 'Janet',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl: null,
    workType: 'Laundry',
  ),
  HireWorkerModel(
    workerName: 'Janet Garner3',
    userName: 'Jet',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl: null,
    workType: 'Laundry',
  ),
  HireWorkerModel(
    workerName: 'Hikmat',
    userName: 'Hikmat',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilag',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Laundry',
  ),
  HireWorkerModel(
    workerName: 'April Peters',
    userName: 'Peters',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Painter',
  ),
  HireWorkerModel(
    workerName: 'Rosa Payne',
    userName: 'Rosa',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Painter',
  ),
  HireWorkerModel(
    workerName: 'Jan Ortega',
    userName: 'Jan',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Painter',
  ),
  HireWorkerModel(
    workerName: 'Teni Ola',
    userName: 'Teni',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilag',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Painter',
  ),
  HireWorkerModel(
    workerName: 'Teni Ola',
    userName: 'Ola',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Painter',
  ),
  HireWorkerModel(
    workerName: 'Teni Ola',
    userName: 'Ola',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Carpenter',
  ),
  HireWorkerModel(
    workerName: 'Marsha',
    userName: 'Marsha',
    workerPhoneNumber: '08011223344',
    workerEmail: 'workMan@gmail.com',
    uniName: 'unilorin',
    profileImageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ8dceeddkD9IrvfZK0FfA-ZvvSEblMOdQIPA&usqp=CAU',
    workType: 'Carpenter',
  ),
];

Future<void> saveHire() async {
  for (HireWorkerModel h in list) {
    print(h.workType);
    print(h.toMap());

    await HireMethods()
        .hireCollection
        .document('workers')
        .collection('allWorkers')
        .document()
        .setData(h.toMap());
  }
}
