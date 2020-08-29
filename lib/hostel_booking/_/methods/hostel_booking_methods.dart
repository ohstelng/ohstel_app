import 'package:Ohstel_app/hostel_booking/_/model/hostel_booking_inspection_model.dart';
import 'package:Ohstel_app/hostel_booking/_/model/hostel_model.dart';
import 'package:Ohstel_app/hostel_booking/_/model/paid_hostel_details_model.dart';
import 'package:Ohstel_app/hostel_booking/_/model/save_hostel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class HostelBookingMethods {
  // collection ref
  final CollectionReference hostelCollection =
      Firestore.instance.collection('hostelBookings');

  final CollectionReference bookingInspectionRef =
      Firestore.instance.collection('bookingInspections');

  final DocumentReference bookingInspectionInfoRef = Firestore.instance
      .collection('bookingInspections')
      .document('hostelInspectionInfo');

  final CollectionReference paidHostelRef =
      Firestore.instance.collection('paidHostel');

  final DocumentReference paidHostelInfoRef =
      Firestore.instance.collection('paidHostel').document('paidHostelInfo');

  final CollectionReference savedHostelRef =
      Firestore.instance.collection('savedHostel');

  Future<List<HostelModel>> fetchAllHostel({@required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('dateAdded', descending: true)
          .limit(6)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['price']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>> fetchAllHostelWithPagination(
      {@required int perPage,
      @required HostelModel lastHostel,
      @required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('dateAdded', descending: true)
          .startAfter([lastHostel.dateAdded])
          .limit(3)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['id']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  ///

  Future<List<HostelModel>> fetchAllSchoolHostel(
      {@required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('dateAdded', descending: true)
          .where('isSchoolHostel', isEqualTo: true)
          .limit(6)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['email']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>> fetchAllSchoolHostelWithPagination({
    @required int perPage,
    @required HostelModel lastHostel,
    @required String uniName,
  }) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('dateAdded', descending: true)
          .where('isSchoolHostel', isEqualTo: true)
          .startAfter([lastHostel.dateAdded])
          .limit(3)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['id']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  ///

  Future<List<HostelModel>> fetchAllHostelSortByPrice(
      {@required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('price', descending: false)
          .limit(6)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['email']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>> fetchAllHostelSortByPriceWithPagination({
    @required int perPage,
    @required HostelModel lastHostel,
    @required String uniName,
  }) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      print(lastHostel.price);
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('price', descending: false)
          .startAfter([lastHostel.price])
          .limit(3)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['email']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>> fetchAllHostelSortByDistanceFromSchool(
      {@required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('distanceFromSchoolInKm', descending: false)
          .where('isSchoolHostel', isEqualTo: false)
          .limit(6)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['email']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>>
      fetchAllHostelSortByDistanceFromSchoolWithPagination({
    @required int perPage,
    @required HostelModel lastHostel,
    @required String uniName,
  }) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
//          .orderBy('dateAdded')
          .orderBy('distanceFromSchoolInKm', descending: false)
          .where('isSchoolHostel', isEqualTo: false)
          .startAfter([lastHostel.distanceFromSchoolInKm])
          .limit(3)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['email']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>> fetchAllHostelSortByRoommateNeeded(
      {@required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('dateAdded', descending: true)
          .where('isRoomMateNeeded', isEqualTo: true)
          .limit(6)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['email']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>> fetchAllHostelSortByRoommateNeededWithPagination({
    @required int perPage,
    @required HostelModel lastHostel,
    @required String uniName,
  }) async {
    List<HostelModel> hostelList = List<HostelModel>();

    try {
      QuerySnapshot querySnapshot = await hostelCollection
          .where('uniName', isEqualTo: uniName)
          .orderBy('dateAdded', descending: true)
          .where('isRoomMateNeeded', isEqualTo: true)
          .startAfter([lastHostel.dateAdded])
          .limit(3)
          .getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
        print(querySnapshot.documents[i].data['email']);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '${e}');
    }

    print(hostelList);
    return hostelList;
  }

  Future<List<HostelModel>> fetchHostelByKeyWord(
      {@required String keyWord, @required String uniName}) async {
    List<HostelModel> hostelList = List<HostelModel>();

    QuerySnapshot querySnapshot = await hostelCollection
//        .where('uniName', isEqualTo: uniName)
        .orderBy('dateAdded', descending: true)
        .where('hostelLocation', isEqualTo: keyWord)
        .limit(6)
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
    }

    print(hostelList);
    print(hostelList.length);
    return hostelList;
  }

  Future<List<HostelModel>> fetchHostelByKeyWordWithPagination({
    @required String keyWord,
    @required HostelModel lastHostel,
    @required String uniName,
  }) async {
    print(lastHostel.id);
    List<HostelModel> hostelList = List<HostelModel>();

    QuerySnapshot querySnapshot = await hostelCollection
        .where('uniName', isEqualTo: uniName)
        .orderBy('dateAdded', descending: true)
        .where('hostelLocation', isEqualTo: keyWord)
        .startAfter([lastHostel.dateAdded])
        .limit(3)
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      hostelList.add(HostelModel.fromMap(querySnapshot.documents[i].data));
      print(querySnapshot.documents[i].data['id']);
    }

    print(hostelList);
    print(hostelList.length);
    return hostelList;
  }

  Future<int> saveBookingInspectionDetails({
    @required String fullName,
    @required String phoneNumber,
    @required String email,
    @required String date,
    @required String time,
    @required HostelModel hostelDetails,
  }) async {
    final String id = Uuid().v4();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    final int month = dateParse.month;
    final int year = dateParse.year;

    try {
      HostelBookingInspectionModel bookingInspectionInfo =
          HostelBookingInspectionModel(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        date: date,
        time: time,
        id: id,
        hostelDetails: hostelDetails.toMap(),
      );
      print(bookingInspectionInfo.toMap());
      print(id);

      Firestore db = Firestore.instance;

      var batch = db.batch();

      batch.setData(
        bookingInspectionRef.document(id),
        bookingInspectionInfo.toMap(),
      );

      batch.setData(
        bookingInspectionInfoRef
            .collection(year.toString())
            .document(month.toString()),
        {"count": FieldValue.increment(1)},
        merge: true,
      );

      await batch.commit();

      print('save inspection details');

      return 0;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: '${e.message}',
        gravity: ToastGravity.CENTER,
      );
      return -1;
    }
  }

  Future<int> savePaidHostelDetailsDetails({
    @required String fullName,
    @required String phoneNumber,
    @required String email,
    @required int price,
    @required HostelModel hostelDetails,
  }) async {
    final String id = Uuid().v4();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    final int month = dateParse.month;
    final int year = dateParse.year;

    try {
      PaidHostelModel paidHostelInfo = PaidHostelModel(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        price: price,
        id: id,
        hostelDetails: hostelDetails.toMap(),
      );
      print(paidHostelInfo.toMap());
      print(id);

      Firestore db = Firestore.instance;

      var batch = db.batch();

      batch.setData(
        paidHostelRef.document(id),
        paidHostelInfo.toMap(),
      );

      batch.setData(
        paidHostelInfoRef
            .collection(year.toString())
            .document(month.toString()),
        {"count": FieldValue.increment(1)},
        merge: true,
      );

      await batch.commit();

      print('save inspection details');

      return 0;
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${e.message}',
        gravity: ToastGravity.CENTER,
      );
      return -1;
    }
  }

  Future<void> archiveHostel({
    @required Map userDetails,
    @required HostelModel hostelDetails,
  }) async {
    SavedHostelModel savedHostelModel = SavedHostelModel(
      hostelID: hostelDetails.id,
      userDetails: userDetails,
      hostelImageUrls: hostelDetails.imageUrl,
      hostelName: hostelDetails.hostelName,
      hostelLocation: hostelDetails.hostelLocation,
    );

    try {
      await savedHostelRef
          .document(userDetails['uid'].toString())
          .collection('all')
          .document()
          .setData(savedHostelModel.toMap());

      Fluttertoast.showToast(
        msg: 'Saved!!',
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${e.message}',
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<HostelModel> getHostelByID({@required String id}) async {
    HostelModel hostelModel;

    try {
      DocumentSnapshot doc = await hostelCollection.document(id).get();
      hostelModel = HostelModel.fromMap(doc.data);
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${e.message}',
        gravity: ToastGravity.CENTER,
      );
    }

    return hostelModel;
  }
}
